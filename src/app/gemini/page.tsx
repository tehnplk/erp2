'use client';

import { useState, useEffect, useRef } from 'react';
import { Bot, Send, User, Sparkles, Trash2 } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

interface Message {
  content: string;
  isUser: boolean;
}

export default function GeminiChatPage() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [input, setInput] = useState('');
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, isLoading]);

  // Auto-focus on mount and after loading completes
  useEffect(() => {
    if (!isLoading) {
      // Small timeout to ensure DOM is ready and prevent conflict with other focus events
      setTimeout(() => {
        inputRef.current?.focus();
      }, 100);
    }
  }, [isLoading]);

  const handleSendMessage = async (e?: React.FormEvent) => {
    e?.preventDefault();
    if (!input.trim() || isLoading) return;

    const userMessage = input;
    setInput('');
    
    // Add user message immediately
    setMessages(prev => [...prev, { content: userMessage, isUser: true }]);
    setIsLoading(true);

    try {
      const response = await fetch('/api/gemini', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: userMessage,
          // Convert local state messages to API format
          messages: messages.map(msg => ({
            role: msg.isUser ? 'user' : 'assistant',
            content: msg.content
          }))
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Failed to get response from Gemini');
      }

      setMessages(prev => [...prev, { content: data.message, isUser: false }]);
    } catch (error) {
      console.error('Error calling Gemini:', error);
      setMessages(prev => [...prev, { 
        content: 'ขออภัย เกิดข้อผิดพลาดในการเชื่อมต่อกับ Gemini กรุณาลองใหม่อีกครั้ง', 
        isUser: false 
      }]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="container mx-auto max-w-7xl p-4 h-[calc(100vh-60px)] flex flex-col">
      <div className="bg-white rounded-xl shadow-lg flex-1 flex flex-col overflow-hidden border border-gray-200">
        {/* Header */}
        <div className="bg-white p-4 flex justify-between items-center border-b border-gray-200">
          <div className="flex items-center gap-2">
            <div className="bg-blue-50 p-2 rounded-lg">
              <Sparkles className="h-5 w-5 text-blue-600" />
            </div>
            <h1 className="text-xl font-bold text-gray-800">Gemini AI Assistant</h1>
          </div>
          <button 
            onClick={() => setMessages([])}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors text-gray-500 hover:text-red-500"
            title="Clear chat"
          >
            <Trash2 className="h-5 w-5" />
          </button>
        </div>

        {/* Messages Area */}
        <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-gray-50">
          {messages.length === 0 && (
            <div className="flex flex-col items-center justify-center h-full text-gray-400 space-y-4">
              <div className="bg-blue-50 p-4 rounded-full">
                <Sparkles className="h-12 w-12 text-blue-400" />
              </div>
              <p className="text-lg">เริ่มสนทนากับ Gemini AI ได้เลยครับ</p>
            </div>
          )}
          
          {messages.map((msg, index) => (
            <div
              key={index}
              className={`flex gap-3 ${msg.isUser ? 'justify-end' : 'justify-start'}`}
            >
              {!msg.isUser && (
                <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-500 to-purple-500 flex items-center justify-center flex-shrink-0 shadow-sm">
                  <Bot className="h-5 w-5 text-white" />
                </div>
              )}
              
              <div
                className={`max-w-[80%] p-3 rounded-2xl shadow-sm overflow-x-auto ${
                  msg.isUser
                    ? 'bg-blue-600 text-white rounded-br-none'
                    : 'bg-white text-gray-800 border border-gray-100 rounded-bl-none'
                }`}
              >
                <div className="markdown-content text-sm">
                  <ReactMarkdown 
                    remarkPlugins={[remarkGfm]}
                    components={{
                      // Override p to avoid nesting issues with block elements like pre
                      p: ({node, ...props}) => <div className="my-2" {...props} />,
                      // Style tables
                      table: ({node, ...props}) => (
                        <table className="border-collapse table-auto w-full my-2 border border-gray-300" {...props} />
                      ),
                      thead: ({node, ...props}) => (
                        <thead className="bg-gray-100 text-gray-700" {...props} />
                      ),
                      th: ({node, ...props}) => (
                        <th className="border border-gray-300 px-3 py-2 text-left font-semibold" {...props} />
                      ),
                      td: ({node, ...props}) => (
                        <td className="border border-gray-300 px-3 py-2" {...props} />
                      ),
                      // Style lists
                      ul: ({node, ...props}) => (
                        <ul className="list-disc list-inside my-2" {...props} />
                      ),
                      ol: ({node, ...props}) => (
                        <ol className="list-decimal list-inside my-2" {...props} />
                      ),
                      // Style headings
                      h1: ({node, ...props}) => <h1 className="text-xl font-bold my-2" {...props} />,
                      h2: ({node, ...props}) => <h2 className="text-lg font-bold my-2" {...props} />,
                      h3: ({node, ...props}) => <h3 className="text-md font-bold my-1" {...props} />,
                      // Style links
                      a: ({node, ...props}) => (
                        <a className="text-blue-600 hover:underline" target="_blank" rel="noopener noreferrer" {...props} />
                      ),
                      // Style code
                      code: ({node, inline, className, children, ...props}: any) => {
                        return inline ? (
                          <code className="bg-gray-100 px-1 py-0.5 rounded text-red-500 font-mono text-xs" {...props}>
                            {children}
                          </code>
                        ) : (
                          <pre className="bg-gray-800 text-white p-3 rounded-lg overflow-x-auto my-2">
                            <code className="font-mono text-xs" {...props}>
                              {children}
                            </code>
                          </pre>
                        );
                      }
                    }}
                  >
                    {msg.content}
                  </ReactMarkdown>
                </div>
              </div>

              {msg.isUser && (
                <div className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center flex-shrink-0">
                  <User className="h-5 w-5 text-gray-600" />
                </div>
              )}
            </div>
          ))}

          {isLoading && (
            <div className="flex gap-3 justify-start">
              <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-500 to-purple-500 flex items-center justify-center flex-shrink-0">
                <Bot className="h-5 w-5 text-white" />
              </div>
              <div className="bg-white p-4 rounded-2xl rounded-bl-none border border-gray-100 shadow-sm flex gap-2 items-center">
                <span className="w-2 h-2 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                <span className="w-2 h-2 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
                <span className="w-2 h-2 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
              </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        {/* Input Area */}
        <div className="p-4 bg-white border-t border-gray-100">
          <form onSubmit={handleSendMessage} className="flex gap-2">
            <input
              ref={inputRef}
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="พิมพ์ข้อความของคุณ..."
              className="flex-1 p-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
              disabled={isLoading}
            />
            <button
              type="submit"
              disabled={isLoading || !input.trim()}
              className="bg-blue-600 text-white p-3 rounded-xl hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center justify-center min-w-[50px] shadow-md"
            >
              <Send className="h-5 w-5" />
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
