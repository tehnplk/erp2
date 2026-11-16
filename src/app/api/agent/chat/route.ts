import OpenAI from 'openai';
import { NextResponse } from 'next/server';

import { getAccessibleSchema, inspectErpTable, queryErpDatabase } from '@/lib/erp-agent';
import {
  answerErpQuestion,
  ErpAgentError,
  getErpAgentErrorResponse,
  type AgentHistoryMessage,
  type AgentModel,
} from '@/lib/erp-agent-loop';
import { consumeRateLimit } from '@/lib/redis';

export const runtime = 'nodejs';

const MAX_QUESTION_LENGTH = 1_000;
const MAX_HISTORY_MESSAGES = 6;
const RATE_LIMIT = 10;
const RATE_LIMIT_SECONDS = 60 * 60;

const getClientIp = (request: Request) => {
  const forwardedFor = request.headers.get('x-forwarded-for');
  return forwardedFor?.split(',')[0]?.trim() || request.headers.get('x-real-ip') || 'unknown';
};

const getAgentHistory = (value: unknown): AgentHistoryMessage[] => {
  if (!Array.isArray(value)) return [];

  return value
    .filter(
      (item): item is AgentHistoryMessage =>
        (item?.role === 'user' || item?.role === 'assistant') &&
        typeof item?.content === 'string' &&
        item.content.trim().length > 0
    )
    .slice(-MAX_HISTORY_MESSAGES)
    .map((item) => ({
      role: item.role,
      content: item.content.slice(0, MAX_QUESTION_LENGTH),
    }));
};

const getDeepSeekModel = (): AgentModel => {
  const apiKey = process.env.DEEPSEEK_API_KEY;
  if (!apiKey) {
    throw new ErpAgentError('not-configured', 'DEEPSEEK_API_KEY is not configured.');
  }

  const client = new OpenAI({
    apiKey,
    baseURL: process.env.DEEPSEEK_BASE_URL || 'https://api.deepseek.com',
  });
  const model = process.env.DEEPSEEK_MODEL || 'deepseek-v4-flash';

  return async ({ messages, tools }) => {
    const completion = await client.chat.completions.create({
      model,
      temperature: 0.2,
      messages,
      tools,
      tool_choice: 'auto',
    });
    return completion.choices[0]?.message;
  };
};

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const question = typeof body?.question === 'string' ? body.question.trim() : '';
    if (!question) {
      return NextResponse.json({ error: 'Question is required.' }, { status: 400 });
    }
    if (question.length > MAX_QUESTION_LENGTH) {
      return NextResponse.json({ error: 'Question is too long.' }, { status: 400 });
    }

    const ip = getClientIp(request);
    const rateLimit = await consumeRateLimit(`erp-agent:${ip}`, RATE_LIMIT, RATE_LIMIT_SECONDS);
    if (!rateLimit.allowed) {
      return NextResponse.json(
        { error: 'Rate limit exceeded. Please try again later.' },
        {
          status: 429,
          headers: { 'Retry-After': String(Math.max(1, rateLimit.resetAfterSeconds)) },
        }
      );
    }

    const model = getDeepSeekModel();
    const result = await answerErpQuestion({
      question,
      history: getAgentHistory(body?.history),
      model,
      database: { getAccessibleSchema, inspectErpTable, queryErpDatabase },
    });

    return NextResponse.json(result, {
      headers: { 'X-RateLimit-Remaining': String(rateLimit.remaining) },
    });
  } catch (error) {
    console.error('ERP agent error:', error);

    const { status, message } = getErpAgentErrorResponse(error);
    return NextResponse.json({ error: message }, { status });
  }
}
