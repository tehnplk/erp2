import { NextResponse } from 'next/server';

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  totalCount?: number;
  page?: number;
  pageSize?: number;
}

export function apiSuccess<T>(
  data: T,
  message?: string,
  totalCount?: number,
  status: number = 200,
  meta?: {
    page?: number;
    pageSize?: number;
  }
) {
  const response: ApiResponse<T> = {
    success: true,
    data,
    ...(message && { message }),
    ...(totalCount !== undefined && { totalCount }),
    ...(meta?.page !== undefined && { page: meta.page }),
    ...(meta?.pageSize !== undefined && { pageSize: meta.pageSize })
  };
  
  return NextResponse.json(response, { status });
}

export function apiError(
  error: string,
  status: number = 500,
  details?: any
) {
  const response: ApiResponse = {
    success: false,
    error,
    ...(details && process.env.NODE_ENV === 'development' && { details })
  };
  
  return NextResponse.json(response, { status });
}

export function apiValidationError(error: string) {
  return apiError(error, 400);
}

export function apiNotFound(resource: string = 'Resource') {
  return apiError(`${resource} not found`, 404);
}

export function apiUnauthorized(error: string = 'Unauthorized') {
  return apiError(error, 401);
}

export function apiForbidden(error: string = 'Forbidden') {
  return apiError(error, 403);
}

export function apiMethodNotAllowed(method: string) {
  return apiError(`Method ${method} not allowed`, 405);
}

export function apiConflict(error: string) {
  return apiError(error, 409);
}
