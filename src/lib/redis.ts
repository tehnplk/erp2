import Redis from 'ioredis';

const globalForRedis = globalThis as unknown as { redis?: Redis };

export const redis =
  globalForRedis.redis ||
  new Redis(process.env.REDIS_URL || 'redis://localhost:6379', {
    maxRetriesPerRequest: 3,
  });

if (process.env.NODE_ENV !== 'production') {
  globalForRedis.redis = redis;
}

/**
 * Cache helper to get or set data from Redis
 */
export async function cacheGet<T>(key: string): Promise<T | null> {
  try {
    const cachedData = await redis.get(key);
    if (cachedData) {
      return JSON.parse(cachedData) as T;
    }
  } catch (error) {
    console.error(`Redis Get Error (Key: ${key}):`, error);
  }
  return null;
}

export async function cacheSet(key: string, data: any, ttlSeconds: number = 3600): Promise<void> {
  try {
    await redis.set(key, JSON.stringify(data), 'EX', ttlSeconds);
  } catch (error) {
    console.error(`Redis Set Error (Key: ${key}):`, error);
  }
}

export async function cacheDel(key: string): Promise<void> {
  try {
    await redis.del(key);
  } catch (error) {
    console.error(`Redis Del Error (Key: ${key}):`, error);
  }
}

/**
 * Delete all keys matching a pattern
 */
export async function cacheDelByPattern(pattern: string): Promise<void> {
  try {
    const keys = await redis.keys(pattern);
    if (keys.length > 0) {
      await redis.del(...keys);
    }
  } catch (error) {
    console.error(`Redis DelPattern Error (Pattern: ${pattern}):`, error);
  }
}
