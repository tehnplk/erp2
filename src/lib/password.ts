import { pbkdf2, randomBytes, timingSafeEqual } from 'node:crypto';
import { promisify } from 'node:util';

const pbkdf2Async = promisify(pbkdf2);
const algorithm = 'sha256';
const iterations = 310000;
const keyLength = 32;
const hashPrefix = 'pbkdf2';

export const hashPassword = async (password: string) => {
  const salt = randomBytes(16);
  const derivedKey = await pbkdf2Async(password, salt, iterations, keyLength, algorithm);

  return [
    hashPrefix,
    algorithm,
    String(iterations),
    salt.toString('base64url'),
    derivedKey.toString('base64url'),
  ].join('$');
};

export const verifyPassword = async (password: string, passwordHash: string) => {
  const parts = passwordHash.split('$');
  if (parts.length !== 5) return false;

  const [prefix, storedAlgorithm, storedIterations, storedSalt, storedHash] = parts;
  if (prefix !== hashPrefix || storedAlgorithm !== algorithm) return false;

  const iterationCount = Number.parseInt(storedIterations, 10);
  if (!Number.isInteger(iterationCount) || iterationCount <= 0) return false;

  try {
    const salt = Buffer.from(storedSalt, 'base64url');
    const expectedHash = Buffer.from(storedHash, 'base64url');
    const actualHash = await pbkdf2Async(password, salt, iterationCount, expectedHash.length, storedAlgorithm);

    return expectedHash.length === actualHash.length && timingSafeEqual(expectedHash, actualHash);
  } catch {
    return false;
  }
};
