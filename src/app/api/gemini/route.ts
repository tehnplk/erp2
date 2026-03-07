import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { getSystemPrompt } from '@/lib/ai/prompts';

interface GeminiPart {
    text: string;
}

interface GeminiContent {
    role: 'user' | 'model';
    parts: GeminiPart[];
}

interface Message {
    role: 'user' | 'assistant' | 'system';
    content: string;
}

export async function POST(request: Request) {
    try {
        const { message, messages } = await request.json();

        if (!message) {
            return NextResponse.json(
                { error: 'Message is required' },
                { status: 400 }
            );
        }

        const apiKey = process.env.GOOGLE_API_KEY;
        const modelName = 'gemini-2.5-flash-lite'; 
        const api = `https://generativelanguage.googleapis.com/v1beta/models/${modelName}:generateContent?key=${apiKey}`;

        if (!apiKey) {
            return NextResponse.json(
                { message: 'Server Error: GOOGLE_API_KEY is missing.' },
                { status: 500 }
            );
        }

        const contents: GeminiContent[] = [];
        let systemInstruction = getSystemPrompt();

        const callGemini = async (payload: any) => {
            const response = await fetch(api, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload),
            });
            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error?.message || 'Failed to get response from Google Gemini');
            }
            return data.candidates?.[0]?.content?.parts?.[0]?.text || '';
        };

        if (messages && Array.isArray(messages)) {
            messages.forEach((msg: Message) => {
                if (msg.role === 'system') {
                    systemInstruction = msg.content;
                } else if (msg.role === 'user' || msg.role === 'assistant') {
                    contents.push({
                        role: msg.role === 'assistant' ? 'model' : 'user',
                        parts: [{ text: msg.content }]
                    });
                }
            });
        }

        contents.push({
            role: 'user',
            parts: [{ text: message }]
        });

        let payload = {
            contents: contents,
            systemInstruction: { parts: [{ text: systemInstruction }] },
            generationConfig: { temperature: 0.2, maxOutputTokens: 1000 }
        };

        let aiMessage = await callGemini(payload);
        let cleanMessage = aiMessage.trim();
        
        if (cleanMessage.startsWith('```')) {
            cleanMessage = cleanMessage.replace(/^```(json)?\n/, '').replace(/\n```$/, '');
        }

        try {
            const parsed = JSON.parse(cleanMessage);
            
            if (parsed.sql) {
                console.log('Executing SQL:', parsed.sql);
                const normalizedSql = String(parsed.sql).trim();
                if (!normalizedSql.toUpperCase().startsWith('SELECT')) {
                     throw new Error('Only SELECT queries are allowed for security reasons.');
                }
                if (normalizedSql.includes(';')) {
                    throw new Error('Multiple SQL statements are not allowed.');
                }

                try {
                    const results = await pgQuery(normalizedSql);
                    const resultStr = JSON.stringify(results.rows, (_, v) => typeof v === 'bigint' ? v.toString() : v);
                    
                    contents.push({ role: 'model', parts: [{ text: aiMessage }] });
                    contents.push({ 
                        role: 'user', 
                        parts: [{ text: `Here is the data from the database: ${resultStr}\nPlease analyze this data and answer my original question.` }] 
                    });

                    payload = {
                        contents: contents,
                        systemInstruction: { parts: [{ text: systemInstruction }] },
                        generationConfig: { temperature: 0.7, maxOutputTokens: 1000 }
                    };

                    aiMessage = await callGemini(payload);

                } catch (dbError: any) {
                    console.error('Database execution error:', dbError);
                    contents.push({ role: 'model', parts: [{ text: aiMessage }] });
                    contents.push({ 
                        role: 'user', 
                        parts: [{ text: `Error executing SQL: ${dbError.message}. Please try again with a corrected query or explain the issue.` }] 
                    });
                    
                    payload = {
                        contents: contents,
                        systemInstruction: { parts: [{ text: systemInstruction }] },
                        generationConfig: { temperature: 0.7, maxOutputTokens: 1000 }
                    };
                    aiMessage = await callGemini(payload);
                }
            }
        } catch (e) {
        }

        return NextResponse.json({ message: aiMessage });

    } catch (error: any) {
        console.error('Error calling LLM:', error);
        return NextResponse.json(
            { message: `Error: ${error.message || 'Unknown error'}` },
            { status: 500 }
        );
    }
}
