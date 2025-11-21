export interface MessagePart {
    // Define the structure of message parts if needed
    [key: string]: any;
}

export interface Usage {
    requests: number;
    request_tokens: number;
    response_tokens: number;
    total_tokens: number;
    details: any; // Define more specific structure if needed
}

export interface HistoryEntry {
    parts: MessagePart[][];
    instructions?: string;
    usage?: Usage;
    model_name?: string;
    timestamp?: string;
    kind: 'request' | 'response';
    vendor_details: any | null;
    vendor_id?: string;
}

export type MessageHistory = HistoryEntry[];
