import { ArrowDown, ArrowUp, ArrowUpDown } from 'lucide-react';

type SortOrder = 'asc' | 'desc';

type SortableHeaderProps = {
  label: string;
  sortKey: string;
  activeKey: string;
  activeOrder: SortOrder;
  onSort: (sortKey: string) => void;
  align?: 'left' | 'right';
  className?: string;
};

export function SortableHeader({
  label,
  sortKey,
  activeKey,
  activeOrder,
  onSort,
  align = 'left',
  className = '',
}: SortableHeaderProps) {
  const isActive = activeKey === sortKey;
  const iconClassName = 'h-3.5 w-3.5 shrink-0';

  return (
    <button
      type="button"
      onClick={() => onSort(sortKey)}
      className={`inline-flex w-full items-center gap-1 font-semibold hover:text-gray-900 ${align === 'right' ? 'justify-end' : 'justify-start'} ${className}`}
    >
      <span>{label}</span>
      {isActive ? (
        activeOrder === 'asc' ? <ArrowUp className={iconClassName} /> : <ArrowDown className={iconClassName} />
      ) : (
        <ArrowUpDown className={`${iconClassName} opacity-60`} />
      )}
    </button>
  );
}
