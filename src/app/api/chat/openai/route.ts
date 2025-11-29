import { NextResponse } from 'next/server';

// Define types for Google GenAI API
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

        // --- Configuration ---
        const apiKey = process.env.GOOGLE_API_KEY;
        // Models: 'gemini-2.0-flash-lite-preview-02-05', 'gemini-1.5-flash', 'gemini-1.5-pro'
        const modelName = 'gemini-2.0-flash-lite-preview-02-05'; 
        const api = `https://generativelanguage.googleapis.com/v1beta/models/${modelName}:generateContent?key=${apiKey}`;

        if (!apiKey) {
            return NextResponse.json(
                { message: 'Server Error: GOOGLE_API_KEY is missing.' },
                { status: 500 }
            );
        }

        // Convert OpenAI-style messages to Gemini-style contents
        // Note: Gemini REST API uses 'user' and 'model' roles. 'system' instructions are handled differently in v1beta via systemInstruction, 
        // but for simple chat, we can prepend or use the `systemInstruction` field if supported, 
        // or just treat it as initial context.
        // For simplicity and compatibility with this endpoint structure, we'll map:
        // user -> user
        // assistant -> model
        
        const contents: GeminiContent[] = [];
        let systemInstruction = 'You are a helpful SQL assistant.';

        // Process history messages
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

        // Add current user message
        contents.push({
            role: 'user',
            parts: [{ text: message }]
        });

        // Construct payload
        // Note: 'systemInstruction' is supported in v1beta for some models. 
        // If strict system prompt is needed, we include it at the top level.
        const payload = {
            contents: contents,
            systemInstruction: {
                parts: [{ text: systemInstruction }]
            },
            generationConfig: {
                temperature: 0.7,
                maxOutputTokens: 1000,
            }
        };

        const response = await fetch(api, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(payload),
        });

        const data = await response.json();

        if (!response.ok) {
            const errorMsg = data.error?.message || 'Failed to get response from Google Gemini';
            console.error('Gemini API Error:', data);
            throw new Error(errorMsg);
        }

        // Extract text from Gemini response
        // Structure: candidates[0].content.parts[0].text
        const aiMessage = data.candidates?.[0]?.content?.parts?.[0]?.text || '';
        
        // console.log('AI Response:', aiMessage);

        return NextResponse.json({ message: aiMessage });

    } catch (error: any) {
        console.error('Error calling LLM:', error);
        return NextResponse.json(
            { message: `Error: ${error.message || 'Unknown error'}` },
            { status: 500 }
        );
    }
}
