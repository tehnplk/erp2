import { ZodSchema, ZodError } from 'zod';
import { apiValidationError } from '../api-response';

export async function validateRequest<T>(
  schema: ZodSchema<T>,
  data: unknown
): Promise<{ success: true; data: T } | { success: false; error: ReturnType<typeof apiValidationError> }> {
  try {
    const validatedData = await schema.parseAsync(data);
    return { success: true, data: validatedData };
  } catch (error) {
    if (error instanceof ZodError) {
      const errorMessage = error.issues.map((e: any) => `${e.path.join('.')}: ${e.message}`).join(', ');
      return { success: false, error: apiValidationError(errorMessage) };
    }
    return { success: false, error: apiValidationError('Invalid request data') };
  }
}

export function validateQuery<T>(
  schema: ZodSchema<T>,
  searchParams: URLSearchParams
): { success: true; data: T } | { success: false; error: ReturnType<typeof apiValidationError> } {
  try {
    const queryObject: Record<string, any> = {};
    searchParams.forEach((value, key) => {
      queryObject[key] = value;
    });
    
    const validatedData = schema.parse(queryObject);
    return { success: true, data: validatedData };
  } catch (error) {
    if (error instanceof ZodError) {
      const errorMessage = error.issues.map((e: any) => `${e.path.join('.')}: ${e.message}`).join(', ');
      return { success: false, error: apiValidationError(errorMessage) };
    }
    return { success: false, error: apiValidationError('Invalid query parameters') };
  }
}
