import { NextResponse } from 'next/server';
import { MessageHistory } from '@/app/types/messageHistory';

interface ChatResponse {
    message: string;
    message_history: MessageHistory;
}

export async function POST(request: Request) {

    const { message ,message_history} = await request.json();
    const api = 'http://localhost:8000/chat';
    const response = await fetch(api, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            user_prompt: message,
            message_history: message_history
        }),
    });

    const data = await response.json();
    
    if (!response.ok) {
        throw new Error('Failed to get response from chat server');
    }

    const aiMessage = data['message'];
    const aiMessageHistory = data['message_history'] as MessageHistory;

    // Validate message history structure
    if (Array.isArray(aiMessageHistory)) {
        //console.log('AI message history:', JSON.stringify(aiMessageHistory, null, 2));
    } else {
        console.warn('Received invalid message history format');
    }

    const responseData: ChatResponse = {
        message: aiMessage,
        message_history: aiMessageHistory
    };

    return NextResponse.json(responseData);

}
