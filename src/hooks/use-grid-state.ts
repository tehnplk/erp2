import { useState } from 'react';
import type { ChangeEvent } from 'react';

export type SortOrder = 'asc' | 'desc';

export type GridDefaults = {
  sortBy: string;
  sortOrder: SortOrder;
  pageSizes?: readonly number[];
};

export type GridParams = {
  sortBy: string;
  sortOrder: SortOrder;
  page: number;
  pageSize: number;
};

type ParamReader = { get(name: string): string | null };

const DEFAULT_PAGE_SIZE = 20;

export function readGridParams(searchParams: ParamReader, defaults: GridDefaults): GridParams {
  const otherOrder: SortOrder = defaults.sortOrder === 'asc' ? 'desc' : 'asc';
  const pageSizeRaw = parseInt(searchParams.get('page_size') || String(DEFAULT_PAGE_SIZE), 10) || DEFAULT_PAGE_SIZE;
  return {
    sortBy: searchParams.get('order_by') || defaults.sortBy,
    sortOrder: searchParams.get('sort_order') === otherOrder ? otherOrder : defaults.sortOrder,
    page: Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1),
    pageSize: defaults.pageSizes
      ? (defaults.pageSizes.includes(pageSizeRaw) ? pageSizeRaw : DEFAULT_PAGE_SIZE)
      : Math.max(1, pageSizeRaw),
  };
}

export function writeGridParams(params: URLSearchParams, grid: GridParams, defaults: GridDefaults) {
  if (grid.sortBy && grid.sortBy !== defaults.sortBy) params.set('order_by', grid.sortBy);
  if (grid.sortOrder !== defaults.sortOrder) params.set('sort_order', grid.sortOrder);
  if (grid.page > 1) params.set('page', String(grid.page));
  if (grid.pageSize !== DEFAULT_PAGE_SIZE) params.set('page_size', String(grid.pageSize));
}

export function useGridState(searchParams: ParamReader, totalCount: number, defaults: GridDefaults) {
  const initial = readGridParams(searchParams, defaults);
  const [sortBy, setSortBy] = useState(initial.sortBy);
  const [sortOrder, setSortOrder] = useState<SortOrder>(initial.sortOrder);
  const [page, setPage] = useState(initial.page);
  const [pageSize, setPageSize] = useState(initial.pageSize);
  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));

  const handleSort = (column: string) => {
    if (sortBy === column) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
      return;
    }
    setSortBy(column);
    setSortOrder('asc');
  };

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
  };

  const handlePageSizeChange = (event: ChangeEvent<HTMLSelectElement>) => {
    const newSize = parseInt(event.target.value, 10);
    if (defaults.pageSizes && !defaults.pageSizes.includes(newSize)) return;
    setPageSize(newSize);
    setPage(1);
  };

  const applySearchParams = (next: ParamReader) => {
    const values = readGridParams(next, defaults);
    setSortBy(values.sortBy);
    setSortOrder(values.sortOrder);
    setPage(values.page);
    setPageSize(values.pageSize);
  };

  return {
    sortBy,
    sortOrder,
    page,
    pageSize,
    setSortBy,
    setSortOrder,
    setPage,
    setPageSize,
    totalPages,
    handleSort,
    goToPage,
    handlePageSizeChange,
    applySearchParams,
  };
}
