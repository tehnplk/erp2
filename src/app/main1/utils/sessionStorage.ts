import { MessageHistory } from '../types/messageHistory';

const CHAT_HISTORY_KEY = 'chat_message_history';

export const saveMessageHistory = (messageHistory: MessageHistory) => {
    if (typeof window !== 'undefined') {
        try {
            const serialized = JSON.stringify(messageHistory);
            sessionStorage.setItem(CHAT_HISTORY_KEY, serialized);
        } catch (error) {
            console.error('Error saving message history:', error);
        }
    }
};

export const getMessageHistory = (): MessageHistory => {
    if (typeof window !== 'undefined') {
        try {
            const saved = sessionStorage.getItem(CHAT_HISTORY_KEY);
            return saved ? JSON.parse(saved) : [];
        } catch (error) {
            console.error('Error retrieving message history:', error);
            return [];
        }
    }
    return [];
};

export const clearMessageHistory = () => {
    if (typeof window !== 'undefined') {
        sessionStorage.removeItem(CHAT_HISTORY_KEY);
    }
};
