import { NextResponse } from 'next/server';

interface Message {
    role: 'user' | 'assistant';
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
        const api = 'https://api.openai.com/v1/chat/completions';        
        const response = await fetch(api, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
            },
            body: JSON.stringify({
                model: 'gpt-4o-mini',
                messages: [
                    ...messages,
                    {role :'system', content: 'You are a helpful SQL assistant.'},
                    { role: 'user', content: message }
                ],
                temperature: 0.7,
                max_tokens: 1000,
            }),
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error?.message || 'Failed to get response from LLM');
        }

        const aiMessage = data.choices[0].message.content;
        console.log('AI Response:', aiMessage);

        return NextResponse.json({ message: aiMessage });
    } catch (error) {
        console.error('Error calling LLM:', error);
        return NextResponse.json(
            { message: 'Sorry, I encountered an error. Please try again.' },
            { status: 500 }
        );
    }
}
