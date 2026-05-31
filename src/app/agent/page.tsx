'use client';

import { useEffect, useRef, useState, type FormEvent } from 'react';
import { Bot, Code2, LoaderCircle, Send, UserRound } from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

import AgentChart from './AgentChart';
import type { AgentChart as AgentChartSpec } from '@/lib/erp-agent-chart';

type ChatMessage = {
  role: 'user' | 'assistant';
  content: string;
  sql?: string;
  chart?: AgentChartSpec;
};

export default function AgentPage() {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [question, setQuestion] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const conversationEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    conversationEndRef.current?.scrollIntoView({ behavior: 'smooth', block: 'end' });
  }, [messages, isLoading, error]);

  useEffect(() => {
    if (!isLoading) {
      inputRef.current?.focus();
    }
  }, [isLoading]);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const trimmedQuestion = question.trim();
    if (!trimmedQuestion || isLoading) return;

    const nextMessages: ChatMessage[] = [...messages, { role: 'user', content: trimmedQuestion }];
    setMessages(nextMessages);
    setQuestion('');
    setError('');
    setIsLoading(true);

    try {
      const response = await fetch('/api/agent/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          question: trimmedQuestion,
          history: messages.slice(-6).map(({ role, content }) => ({ role, content })),
        }),
      });
      const payload = await response.json();

      if (!response.ok) {
        throw new Error(payload.error || 'Agent request failed.');
      }

      setMessages((current) => [
        ...current,
        {
          role: 'assistant',
          content: payload.answer,
          sql: payload.sql,
          chart: payload.chart,
        },
      ]);
    } catch (requestError) {
      setError(requestError instanceof Error ? requestError.message : 'Agent request failed.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <main className="h-[calc(100dvh-52px)] overflow-hidden bg-[radial-gradient(circle_at_top_left,_#dbeafe,_transparent_36%),linear-gradient(135deg,_#f8fafc,_#ecfeff)] p-3 text-slate-900 sm:p-6">
      <div className="flex h-full w-full flex-col">
        <section className="flex h-full min-h-0 flex-col overflow-hidden rounded-3xl border border-white/80 bg-white/85 shadow-xl shadow-slate-900/5 backdrop-blur">
          <div
            data-testid="agent-conversation"
            className="min-h-0 flex-1 space-y-4 overflow-y-auto overscroll-contain p-4 scroll-smooth sm:p-6"
          >
            {messages.length === 0 && (
              <div className="mx-auto mt-20 max-w-xl text-center">
                <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl bg-cyan-100 text-cyan-700">
                  <Bot className="h-8 w-8" />
                </div>
                <h2 className="mt-5 text-xl font-bold text-slate-900">Hi, I&apos;m Fern</h2>
                <p className="mt-2 text-sm leading-6 text-slate-500">
                  Try asking for purchase plan totals, department summaries, inventory balances, or recent operational records.
                </p>
              </div>
            )}

            {messages.map((message, index) => (
              <article
                key={`${message.role}-${index}`}
                className={`flex gap-3 ${message.role === 'user' ? 'justify-end' : 'justify-start'}`}
              >
                {message.role === 'assistant' && (
                  <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-cyan-100 text-cyan-700">
                    <Bot className="h-5 w-5" />
                  </div>
                )}
                <div
                  className={`max-w-[86%] rounded-2xl px-4 py-3 text-sm leading-6 ${
                    message.role === 'user'
                      ? 'bg-slate-950 text-white'
                      : 'border border-slate-200 bg-white text-slate-700 shadow-sm'
                  }`}
                >
                  <ReactMarkdown remarkPlugins={[remarkGfm]}>{message.content}</ReactMarkdown>
                  {message.chart && <AgentChart chart={message.chart} />}
                  {message.sql && (
                    <details className="mt-3 rounded-xl border border-slate-200 bg-slate-950 text-left text-slate-100">
                      <summary className="flex cursor-pointer items-center gap-2 px-3 py-2 text-xs font-semibold uppercase tracking-wider text-cyan-300">
                        <Code2 className="h-4 w-4" />
                        View generated SQL
                      </summary>
                      <pre className="overflow-x-auto border-t border-slate-800 px-3 py-3 text-xs leading-5">
                        <code>{message.sql}</code>
                      </pre>
                    </details>
                  )}
                </div>
                {message.role === 'user' && (
                  <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-slate-200 text-slate-700">
                    <UserRound className="h-5 w-5" />
                  </div>
                )}
              </article>
            ))}

            {isLoading && (
              <div className="flex items-center gap-3 text-sm text-slate-500">
                <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-cyan-100 text-cyan-700">
                  <LoaderCircle className="h-5 w-5 animate-spin" />
                </div>
                Querying ERP data...
              </div>
            )}
            <div ref={conversationEndRef} data-testid="agent-conversation-end" aria-hidden="true" />
          </div>

          <div
            data-testid="agent-composer"
            className="shrink-0 border-t border-slate-200 bg-white/90 p-3 pb-[max(0.75rem,env(safe-area-inset-bottom))] sm:p-5"
          >
            {error && <p className="mb-3 rounded-xl bg-red-50 px-3 py-2 text-sm text-red-700">{error}</p>}
            <form onSubmit={handleSubmit} className="flex flex-col gap-3 sm:flex-row">
              <input
                ref={inputRef}
                type="text"
                value={question}
                onChange={(event) => setQuestion(event.target.value)}
                placeholder="Ask about ERP data..."
                maxLength={1_000}
                disabled={isLoading}
                className="min-h-12 flex-1 rounded-xl border border-slate-300 bg-white px-4 text-sm outline-none transition focus:border-cyan-600 focus:ring-4 focus:ring-cyan-100 disabled:bg-slate-100"
              />
              <button
                type="submit"
                disabled={!question.trim() || isLoading}
                className="inline-flex min-h-12 items-center justify-center gap-2 rounded-xl bg-cyan-700 px-5 text-sm font-semibold text-white transition hover:bg-cyan-800 disabled:cursor-not-allowed disabled:opacity-50"
              >
                <Send className="h-4 w-4" />
                Ask agent
              </button>
            </form>
          </div>
        </section>
      </div>
    </main>
  );
}
