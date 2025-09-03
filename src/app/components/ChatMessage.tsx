import { useState, useEffect } from 'react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import styles from './ChatMessage.module.css';

interface ChatMessageProps {
    message: string;
    isUser: boolean;
    isTyping: boolean;
    onStream?: () => void;
}

export default function ChatMessage({ message, isUser, isTyping, onStream }: ChatMessageProps) {
    const [displayedText, setDisplayedText] = useState<string>('');
    const [currentIndex, setCurrentIndex] = useState<number>(0);
    const [isStreaming, setIsStreaming] = useState<boolean>(false);

    useEffect(() => {
        if (!isUser && !isTyping && message) {
            setIsStreaming(true);
            const timer = setTimeout(() => {
                if (currentIndex < message.length) {
                    setDisplayedText(message.slice(0, currentIndex + 1));
                    setCurrentIndex(currentIndex + 1);
                    onStream?.();
                } else {
                    setIsStreaming(false);
                }
            }, 20);

            return () => {
                clearTimeout(timer);
                setIsStreaming(false);
            };
        } else if (isUser) {
            setDisplayedText(message);
            setIsStreaming(false);
        }
    }, [currentIndex, message, isUser, isTyping, onStream]);

    return (
        <div className={`flex ${isUser ? 'justify-end' : 'justify-start'} mb-4`}>
            <div
                className={`max-w-xl lg:max-w-3xl px-6 py-3 rounded-lg ${isUser
                        ? 'bg-blue-500 text-white rounded-br-none'
                        : 'bg-gray-200 text-gray-800 rounded-bl-none'
                    }`}
            >
                {isTyping ? (
                    <div className="flex items-center space-x-1">
                        <div className="flex space-x-1">
                            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.1s' }}></div>
                            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
                        </div>
                    </div>
                ) : (
                    <div className={styles['markdown-content']}>
                        <ReactMarkdown 
                            remarkPlugins={[remarkGfm]}
                            components={{
                                img: ({node, src, alt, ...props}) => (
                                    <img 
                                        src={src} 
                                        alt={alt} 
                                        className="max-w-full h-auto rounded-lg my-2"
                                        loading="lazy"
                                        {...props}
                                    />
                                ),
                                p: ({children}) => (
                                    <p className="whitespace-pre-wrap mb-2">{children}</p>
                                )
                            }}
                        >
                            {displayedText}
                        </ReactMarkdown>
                    </div>
                )}
            </div>
        </div>
    );
}