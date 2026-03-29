'use client';

import { Suspense, useEffect, useMemo, useRef, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { ArrowUpDown } from 'lucide-react';
import { useSysSetting } from '@/hooks/use-sys-setting';

const get_current_budget_year = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

type UsagePlanRow = {
  id: number;
  product_code: string | null;
  product_name: string | null;
  category?: string | null;
  type?: string | null;
  subtype?: string | null;
  unit?: string | null;
  requested_amount: number | null;
  price_per_unit?: number | null;
  requesting_dept_code: string | null;
  requesting_dept: string | null;
  plan_flag?: 'ในแผน' | 'นอกแผน' | null;
  approved_quota: number | null;
  budget_year: number | null;
  sequence_no: number | null;
  has_purchase_plan: boolean;
};

type FormState = {
  product_code: string;
  requesting_dept_code: string;
  requested_amount: string;
  approved_quota: string;
  budget_year: string;
  sequence_no: string;
};

type ProductOption = {
  code: string;
  name: string;
  category?: string | null;
  type?: string | null;
  subtype?: string | null;
  unit?: string | null;
};

type DepartmentOption = {
  department_code: string;
  name: string;
};

type BulkUsagePlanItem = {
  temp_id: string;
  product_code: string;
  product_name: string;
  category?: string | null;
  type?: string | null;
  subtype?: string | null;
  unit?: string | null;
  requested_amount: string;
};

type EditableField = 'requested_amount' | 'approved_quota';

const default_form_state = (budgetYear = ''): FormState => ({
  product_code: '',
  requesting_dept_code: '',
  requested_amount: '',
  approved_quota: '',
  budget_year: budgetYear,
  sequence_no: '1',
});

function UsagePlansPageContent() {
  const router = useRouter();
  const pathname = usePathname();
  const search_params = useSearchParams();
  const budget_year_setting = useSysSetting('budget_year', '');
  const effective_budget_year = useMemo<number | null>(() => {
    const parsed = Number(budget_year_setting);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
  }, [budget_year_setting]);

  const initial_page = Math.max(1, Number(search_params.get('page') || '1') || 1);
  const requested_page_size = Number(search_params.get('page_size') || '20');
  const initial_page_size = [20, 50, 100].includes(requested_page_size) ? requested_page_size : 20;
  const initial_sort_by = search_params.get('order_by') || 'id';
  const initial_sort_order = (search_params.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';

  const [usage_plans, set_usage_plans] = useState<UsagePlanRow[]>([]);
  const [loading, set_loading] = useState(true);
  const [saving, set_saving] = useState(false);

  const [page, set_page] = useState(initial_page);
  const [page_size, set_page_size] = useState(initial_page_size);
  const [total_count, set_total_count] = useState(0);
  const [total_value_amount, set_total_value_amount] = useState(0);
  const [sort_by, set_sort_by] = useState(initial_sort_by);
  const [sort_order, set_sort_order] = useState<'asc' | 'desc'>(initial_sort_order);

  const [product_code_filter, set_product_code_filter] = useState('');
  const [requesting_dept_code_filter, set_requesting_dept_code_filter] = useState('');
  const [plan_flag_filter, set_plan_flag_filter] = useState('');
  const [budget_year_filter, set_budget_year_filter] = useState('');
  const [category_filter, set_category_filter] = useState('');
  const [type_filter, set_type_filter] = useState('');

  const [departments, set_departments] = useState<DepartmentOption[]>([]);
  const [budget_years, set_budget_years] = useState<number[]>([]);
  const [categories, set_categories] = useState<any[]>([]);
  const [unique_categories, set_unique_categories] = useState<string[]>([]);
  const [unique_types, set_unique_types] = useState<string[]>([]);
  const [available_types_for_category, set_available_types_for_category] = useState<string[]>([]);
  const [category_type_map, set_category_type_map] = useState<Map<string, Set<string>>>(new Map());

  const [show_form, set_show_form] = useState(false);
  const [editing_usage_plan, set_editing_usage_plan] = useState<UsagePlanRow | null>(null);
  const [form_state, set_form_state] = useState<FormState>(default_form_state());
  const [form_errors, set_form_errors] = useState<Record<string, string>>({});
  const [editing_cell, set_editing_cell] = useState<{ row_id: number; field: EditableField } | null>(null);
  const [editing_cell_value, set_editing_cell_value] = useState('');
  const skip_blur_save_ref = useRef(false);

  const [product_search, set_product_search] = useState('');
  const [product_options, set_product_options] = useState<ProductOption[]>([]);
  const [category_options, set_category_options] = useState<string[]>([]);
  const [selected_bulk_category, set_selected_bulk_category] = useState('');
  const [bulk_items, set_bulk_items] = useState<BulkUsagePlanItem[]>([]);
  const [is_bulk_product_search_focused, set_is_bulk_product_search_focused] = useState(false);
  const [active_bulk_product_suggestion_index, set_active_bulk_product_suggestion_index] = useState(-1);
  const bulk_product_input_ref = useRef<HTMLInputElement | null>(null);
  const bulk_product_suggestion_item_refs = useRef<Array<HTMLButtonElement | null>>([]);
  const has_synced_search_params_ref = useRef(false);
  const last_pushed_url_ref = useRef('');
  const editable_fields = useMemo<EditableField[]>(() => ['requested_amount', 'approved_quota'], []);

  const product_option_by_code = useMemo(() => {
    const map = new Map<string, ProductOption>();
    for (const option of product_options) {
      map.set(option.code, option);
    }
    return map;
  }, [product_options]);

  const total_pages = Math.max(1, Math.ceil(total_count / page_size));

  const filtered_product_options = useMemo(() => {
    const search_value = product_search.trim().toLowerCase();
    if (search_value.length < 2) return [];

    return product_options
      .filter((item) => `${item.code} ${item.name}`.toLowerCase().includes(search_value))
      .slice(0, 12);
  }, [product_options, product_search]);

  const show_bulk_product_suggestions = useMemo(() => {
    if (editing_usage_plan) return false;
    if (!is_bulk_product_search_focused) return false;
    if (!form_state.requesting_dept_code.trim() || !selected_bulk_category.trim()) return false;
    return filtered_product_options.length > 0;
  }, [
    editing_usage_plan,
    is_bulk_product_search_focused,
    form_state.requesting_dept_code,
    selected_bulk_category,
    filtered_product_options,
  ]);

  const form_department_options = useMemo(() => {
    const current = form_state.requesting_dept_code.trim();
    if (!current) return departments;
    if (departments.some((department) => department.department_code === current)) return departments;
    return [{ department_code: current, name: current }, ...departments];
  }, [departments, form_state.requesting_dept_code]);

  useEffect(() => {
    void Promise.all([fetch_filter_options(), fetch_departments(), fetch_categories()]);
  }, []);

  useEffect(() => {
    if (!effective_budget_year) return;
    const next_budget_year = String(effective_budget_year);

    set_budget_year_filter((prev) => {
      if (!search_params.get('budget_year') && prev === '') {
        return next_budget_year;
      }
      return prev;
    });

    set_form_state((prev) => {
      if (editing_usage_plan) return prev;
      if (prev.budget_year === '') {
        return { ...prev, budget_year: next_budget_year };
      }
      return prev;
    });
  }, [effective_budget_year, editing_usage_plan, search_params]);

  useEffect(() => {
    if (!search_params.get('budget_year') && !effective_budget_year) {
      return;
    }
    void fetch_usage_plans();
  }, [page, page_size, sort_by, sort_order, product_code_filter, requesting_dept_code_filter, plan_flag_filter, budget_year_filter, category_filter, type_filter, search_params, effective_budget_year]);

  useEffect(() => {
    if (!category_filter) {
      set_available_types_for_category([]);
      set_type_filter('');
      return;
    }

    if (category_type_map.size === 0) {
      return;
    }

    const types = Array.from(category_type_map.get(category_filter) || []).sort();
    set_available_types_for_category(types);

    if (type_filter && !types.includes(type_filter)) {
      set_type_filter('');
    }
  }, [category_filter, type_filter, category_type_map]);

  useEffect(() => {
    const trimmed_search = product_search.trim();
    if (!editing_usage_plan && trimmed_search.length < 2) {
      set_product_options([]);
      return;
    }

    const timeout_id = window.setTimeout(() => {
      void fetch_product_options(product_search, editing_usage_plan ? '' : selected_bulk_category);
    }, 200);

    return () => window.clearTimeout(timeout_id);
  }, [product_search, selected_bulk_category, editing_usage_plan]);

  useEffect(() => {
    set_active_bulk_product_suggestion_index(-1);
  }, [product_search, selected_bulk_category, form_state.requesting_dept_code]);

  useEffect(() => {
    if (!show_bulk_product_suggestions) return;
    if (active_bulk_product_suggestion_index < 0) return;

    const target = bulk_product_suggestion_item_refs.current[active_bulk_product_suggestion_index];
    target?.scrollIntoView({ block: 'nearest' });
  }, [active_bulk_product_suggestion_index, show_bulk_product_suggestions]);

  useEffect(() => {
    const current_budget_year = effective_budget_year;
    const next_page = Math.max(1, Number(search_params.get('page') || '1') || 1);
    const next_page_size_raw = Number(search_params.get('page_size') || '20');
    const next_page_size = [20, 50, 100].includes(next_page_size_raw) ? next_page_size_raw : 20;
    const next_sort_by = search_params.get('order_by') || 'id';
    const next_sort_order = (search_params.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
    const next_product_code_filter = search_params.get('product_code') || '';
    const next_requesting_dept_code_filter = search_params.get('requesting_dept_code') || '';
    const next_plan_flag_filter = search_params.get('plan_flag') || '';
    const next_budget_year_filter = search_params.get('budget_year') || (current_budget_year ? String(current_budget_year) : '');
    const next_category_filter = search_params.get('category') || '';
    const next_type_filter = search_params.get('type') || '';

    set_page((prev) => (prev === next_page ? prev : next_page));
    set_page_size((prev) => (prev === next_page_size ? prev : next_page_size));
    set_sort_by((prev) => (prev === next_sort_by ? prev : next_sort_by));
    set_sort_order((prev) => (prev === next_sort_order ? prev : next_sort_order));
    set_product_code_filter((prev) => (prev === next_product_code_filter ? prev : next_product_code_filter));
    set_requesting_dept_code_filter((prev) => (prev === next_requesting_dept_code_filter ? prev : next_requesting_dept_code_filter));
    set_plan_flag_filter((prev) => (prev === next_plan_flag_filter ? prev : next_plan_flag_filter));
    set_budget_year_filter((prev) => (prev === next_budget_year_filter ? prev : next_budget_year_filter));
    set_category_filter((prev) => (prev === next_category_filter ? prev : next_category_filter));
    set_type_filter((prev) => (prev === next_type_filter ? prev : next_type_filter));

    has_synced_search_params_ref.current = true;
  }, [search_params, effective_budget_year]);

  useEffect(() => {
    if (!has_synced_search_params_ref.current) {
      return;
    }

    const current_budget_year = effective_budget_year;
    const params = new URLSearchParams(search_params.toString());
    params.set('page', String(page));
    params.set('page_size', String(page_size));
    
    // Update filter params
    if (sort_by && sort_by !== 'id') {
      params.set('order_by', sort_by);
    } else {
      params.delete('order_by');
    }

    if (sort_order !== 'desc') {
      params.set('sort_order', sort_order);
    } else {
      params.delete('sort_order');
    }

    if (product_code_filter) {
      params.set('product_code', product_code_filter);
    } else {
      params.delete('product_code');
    }
    
    if (requesting_dept_code_filter) {
      params.set('requesting_dept_code', requesting_dept_code_filter);
    } else {
      params.delete('requesting_dept_code');
    }

    if (plan_flag_filter) {
      params.set('plan_flag', plan_flag_filter);
    } else {
      params.delete('plan_flag');
    }
    
    if (budget_year_filter && (!current_budget_year || budget_year_filter !== String(current_budget_year))) {
      params.set('budget_year', budget_year_filter);
    } else {
      params.delete('budget_year');
    }
    
    if (category_filter) {
      params.set('category', category_filter);
    } else {
      params.delete('category');
    }
    
    if (type_filter) {
      params.set('type', type_filter);
    } else {
      params.delete('type');
    }

    const next_url = `${pathname}?${params.toString()}`;
    if (last_pushed_url_ref.current !== next_url) {
      last_pushed_url_ref.current = next_url;
      router.replace(next_url, { scroll: false });
    }
  }, [pathname, router, search_params, page, page_size, sort_by, sort_order, product_code_filter, requesting_dept_code_filter, plan_flag_filter, budget_year_filter, category_filter, type_filter, effective_budget_year]);

  const fetch_filter_options = async () => {
    try {
      const response = await fetch('/api/usage-plans/filters');
      if (!response.ok) return;

      const data = await response.json();
      set_budget_years((data.budget_years || []).slice().sort((a: number, b: number) => b - a));
    } catch (error) {
      console.error('failed to fetch usage plan filters', error);
    }
  };

  const fetch_categories = async () => {
    try {
      const response = await fetch('/api/categories');
      const payload = await response.json().catch(() => null);
      if (!response.ok || !payload?.success) return;

      const category_list: string[] = (payload.data || [])
        .map((item: { category?: string | null }) => item?.category?.trim() || '')
        .filter((value: string) => value.length > 0);

      const categories = Array.from(new Set<string>(category_list)).sort((a, b) => a.localeCompare(b));
      set_category_options(categories);
      
      // Create unique categories and types from the data
      const unique_cats = Array.from(new Set((payload.data || []).map((cat: any) => cat.category).filter(Boolean))) as string[];
      const unique_typs = Array.from(new Set((payload.data || []).map((cat: any) => cat.type).filter(Boolean))) as string[];
      
      // Create category-type mapping
      const categoryTypeMap = new Map<string, Set<string>>();
      (payload.data || []).forEach((cat: any) => {
        if (cat.category && cat.type) {
          if (!categoryTypeMap.has(cat.category)) {
            categoryTypeMap.set(cat.category, new Set());
          }
          categoryTypeMap.get(cat.category)?.add(cat.type);
        }
      });
      
      set_unique_categories(unique_cats.sort());
      set_unique_types(unique_typs.sort());
      
      set_category_type_map(categoryTypeMap);
    } catch (error) {
      console.error('failed to fetch categories', error);
    }
  };

  const fetch_departments = async () => {
    try {
      const response = await fetch('/api/departments?page=1&page_size=200');
      const payload = await response.json().catch(() => null);
      if (!response.ok || !payload?.success) return;

      const department_names = (payload.data || [])
        .map((department: { department_code?: string | null; name?: string | null }) => {
          const department_code = department?.department_code?.trim();
          const name = department?.name?.trim();
          if (!department_code || !name) return null;
          return { department_code, name };
        })
        .filter(Boolean) as DepartmentOption[];

      const unique_departments = Array.from(new Map(department_names.map((department) => [department.department_code, department])).values())
        .sort((a, b) => a.name.localeCompare(b.name));

      set_departments(unique_departments);
    } catch (error) {
      console.error('failed to fetch departments', error);
    }
  };

  const fetch_usage_plans = async () => {
    try {
      set_loading(true);
      const params = new URLSearchParams({
        page: String(page),
        page_size: String(page_size),
        order_by: sort_by,
        sort_order: sort_order,
      });

      if (product_code_filter.trim()) params.set('product_code', product_code_filter.trim());
      if (requesting_dept_code_filter.trim()) params.set('requesting_dept_code', requesting_dept_code_filter.trim());
      if (plan_flag_filter.trim()) params.set('plan_flag', plan_flag_filter.trim());
      if (budget_year_filter.trim()) params.set('budget_year', budget_year_filter.trim());
      if (category_filter.trim()) params.set('category', category_filter.trim());
      if (type_filter.trim()) params.set('type', type_filter.trim());

      const response = await fetch(`/api/usage-plans?${params.toString()}`);
      if (!response.ok) throw new Error('fetch usage plans failed');

      const data = await response.json();
      set_usage_plans(Array.isArray(data.usage_plans) ? data.usage_plans : []);
      set_total_count(typeof data.totalCount === 'number' ? data.totalCount : 0);
      set_total_value_amount(typeof data.total_approved_value === 'number' ? data.total_approved_value : 0);
    } catch (error) {
      console.error(error);
      set_usage_plans([]);
      set_total_count(0);
      set_total_value_amount(0);
    } finally {
      set_loading(false);
    }
  };

  const handleSort = (column: string) => {
    if (sort_by === column) {
      set_sort_order((prev) => (prev === 'asc' ? 'desc' : 'asc'));
    } else {
      set_sort_by(column);
      set_sort_order('asc');
    }
    set_page(1);
  };

  const getHeaderClass = (column: string) =>
    `px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500 cursor-pointer hover:bg-gray-100 ${column === sort_by ? 'bg-gray-100' : ''}`;

  const renderSortIcon = (column: string) => {
    if (sort_by !== column) {
      return null;
    }

    return <ArrowUpDown className="h-3 w-3 text-blue-600" aria-hidden="true" />;
  };

  const fetch_product_options = async (search: string, category: string) => {
    try {
      const params = new URLSearchParams({
        page: '1',
        page_size: '30',
        order_by: 'code',
        sort_order: 'asc',
      });

      if (search.trim()) params.set('search', search.trim());
      if (category.trim()) params.set('category', category.trim());

      const response = await fetch(`/api/products?${params.toString()}`);
      if (!response.ok) return;

      const data = await response.json();
      const items = Array.isArray(data.data) ? data.data : [];
      set_product_options(items.map((item: any) => ({
        code: item.code,
        name: item.name,
        category: item.category,
        type: item.type,
        subtype: item.subtype,
        unit: item.unit,
      })));
    } catch (error) {
      console.error('failed to fetch products', error);
    }
  };

  const open_create_form = () => {
    set_editing_usage_plan(null);
    set_form_state(default_form_state(effective_budget_year ? String(effective_budget_year) : ''));
    set_form_errors({});
    set_product_search('');
    set_selected_bulk_category('');
    set_active_bulk_product_suggestion_index(-1);
    set_bulk_items([]);
    set_show_form(true);
  };

  const select_bulk_product_suggestion = (option: ProductOption) => {
    set_product_search(option.code);
    set_active_bulk_product_suggestion_index(-1);
    set_is_bulk_product_search_focused(false);

    window.setTimeout(() => {
      bulk_product_input_ref.current?.focus();
    }, 0);
  };

  const add_bulk_item_from_suggestion = (option: ProductOption) => {
    add_product_to_bulk_items(option.code, option);
  };

  const add_product_to_bulk_items = (product_code_override?: string, product_option_override?: ProductOption) => {
    const product_code = (product_code_override ?? product_search).trim();
    if (!product_code) return;

    if (!form_state.requesting_dept_code.trim()) {
      set_form_errors((prev) => ({ ...prev, requesting_dept_code: 'กรุณาเลือกหน่วยงานก่อนเพิ่มสินค้า' }));
      return;
    }

    if (!selected_bulk_category.trim()) {
      set_form_errors((prev) => ({ ...prev, category: 'กรุณาเลือกหมวดก่อนเพิ่มสินค้า' }));
      return;
    }

    const has_same_code = bulk_items.some((item) => item.product_code === product_code);
    if (has_same_code) {
      void Swal.fire({
        icon: 'warning',
        title: 'มีรหัสสินค้านี้แล้ว',
        text: 'ในรายการที่กำลังเพิ่ม ไม่สามารถเพิ่มรหัสสินค้าซ้ำได้',
      });
      return;
    }

    const selected_product = product_option_override || product_option_by_code.get(product_code);

    set_bulk_items((prev) => [
      ...prev,
      {
        temp_id: `${Date.now()}-${Math.random()}`,
        product_code,
        product_name: selected_product?.name || '-',
        category: selected_product?.category || null,
        type: selected_product?.type || null,
        subtype: selected_product?.subtype || null,
        unit: selected_product?.unit || null,
        requested_amount: '1',
      },
    ]);

    set_product_search('');
    set_is_bulk_product_search_focused(false);
    set_active_bulk_product_suggestion_index(-1);
    set_form_errors((prev) => {
      const next = { ...prev };
      delete next.product_code;
      delete next.category;
      return next;
    });

    window.setTimeout(() => {
      bulk_product_input_ref.current?.focus();
    }, 0);
  };

  const update_bulk_item = (temp_id: string, field: 'requested_amount', value: string) => {
    set_bulk_items((prev) => prev.map((item) => (item.temp_id === temp_id ? { ...item, [field]: value } : item)));
  };

  const remove_bulk_item = (temp_id: string) => {
    set_bulk_items((prev) => prev.filter((item) => item.temp_id !== temp_id));
  };

  const start_cell_edit = (row: UsagePlanRow, field: EditableField) => {
    if (saving) return;

    const initial_value = field === 'requested_amount' ? String(row.requested_amount ?? 0) : String(row.approved_quota ?? 0);

    set_editing_cell({ row_id: row.id, field });
    set_editing_cell_value(initial_value);
  };

  const cancel_cell_edit = () => {
    set_editing_cell(null);
    set_editing_cell_value('');
  };

  const save_cell_edit = async (row: UsagePlanRow, field: EditableField, raw_value: string) => {
    const payload: Partial<Record<EditableField, string | number>> = {};

    const numeric = Number(raw_value);
    if (!Number.isFinite(numeric) || numeric < 0) {
      return false;
    }

    const current = field === 'requested_amount' ? Number(row.requested_amount ?? 0) : Number(row.approved_quota ?? 0);
    if (current === numeric) {
      cancel_cell_edit();
      return true;
    }

    payload[field] = numeric;

    try {
      set_saving(true);
      const response = await fetch(`/api/usage-plans/${row.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const error_data = await response.json().catch(() => null);
        throw new Error(error_data?.error || 'บันทึกข้อมูลไม่สำเร็จ');
      }

      const updated_row = (await response.json().catch(() => null)) as UsagePlanRow | null;

      if (updated_row?.id === row.id) {
        set_usage_plans((prev) => prev.map((item) => (item.id === updated_row.id ? { ...item, ...updated_row } : item)));

        if (field === 'approved_quota') {
          const previous_value = Number(row.approved_quota ?? 0) * Number(row.price_per_unit ?? 0);
          const next_value = Number(updated_row.approved_quota ?? 0) * Number(updated_row.price_per_unit ?? row.price_per_unit ?? 0);
          set_total_value_amount((prev) => prev - previous_value + next_value);
        }
      }

      cancel_cell_edit();
      return true;
    } catch (error) {
      console.error('inline save failed', error);
      return false;
    } finally {
      set_saving(false);
    }
  };

  const move_edit_focus = (row_id: number, field: EditableField, direction: 'ArrowLeft' | 'ArrowRight' | 'ArrowUp' | 'ArrowDown') => {
    const row_index = usage_plans.findIndex((item) => item.id === row_id);
    if (row_index < 0) return;

    const field_index = editable_fields.indexOf(field);
    if (field_index < 0) return;

    let next_row_index = row_index;
    let next_field_index = field_index;

    if (direction === 'ArrowLeft') {
      if (field_index > 0) {
        next_field_index = field_index - 1;
      } else if (row_index > 0) {
        next_row_index = row_index - 1;
        next_field_index = editable_fields.length - 1;
      } else {
        return;
      }
    }

    if (direction === 'ArrowRight') {
      if (field_index < editable_fields.length - 1) {
        next_field_index = field_index + 1;
      } else if (row_index < usage_plans.length - 1) {
        next_row_index = row_index + 1;
        next_field_index = 0;
      } else {
        return;
      }
    }

    if (direction === 'ArrowUp') {
      if (row_index === 0) return;
      next_row_index = row_index - 1;
    }

    if (direction === 'ArrowDown') {
      if (row_index >= usage_plans.length - 1) return;
      next_row_index = row_index + 1;
    }

    const next_row = usage_plans[next_row_index];
    const next_field = editable_fields[next_field_index];
    if (!next_row || !next_field) return;

    start_cell_edit(next_row, next_field);
  };

  const handle_editable_cell_key_down = (event: React.KeyboardEvent<HTMLInputElement>, row: UsagePlanRow, field: EditableField) => {
    const current_value = event.currentTarget.value;

    if (event.key === 'Escape') {
      event.preventDefault();
      skip_blur_save_ref.current = true;
      cancel_cell_edit();
      return;
    }

    if (event.key === 'Enter') {
      event.preventDefault();
      skip_blur_save_ref.current = true;
      void save_cell_edit(row, field, current_value);
      return;
    }

    if (['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'].includes(event.key)) {
      event.preventDefault();
      skip_blur_save_ref.current = true;

      void (async () => {
        const saved = await save_cell_edit(row, field, current_value);
        if (!saved) return;
        move_edit_focus(row.id, field, event.key as 'ArrowLeft' | 'ArrowRight' | 'ArrowUp' | 'ArrowDown');
      })();
    }
  };

  const open_edit_form = (row: UsagePlanRow) => {
    set_editing_usage_plan(row);
    set_form_state({
      product_code: row.product_code || '',
      requesting_dept_code: row.requesting_dept_code || '',
      requested_amount: row.requested_amount != null ? String(row.requested_amount) : '',
      approved_quota: row.approved_quota != null ? String(row.approved_quota) : '',
      budget_year: row.budget_year != null ? String(row.budget_year) : (effective_budget_year ? String(effective_budget_year) : ''),
      sequence_no: row.sequence_no != null ? String(row.sequence_no) : '1',
    });
    set_form_errors({});
    set_product_search(row.product_code || '');
    set_show_form(true);
  };

  const validate_form = () => {
    const errors: Record<string, string> = {};

    if (!form_state.product_code.trim()) errors.product_code = 'กรุณาระบุรหัสสินค้า';
    if (!form_state.requesting_dept_code.trim()) errors.requesting_dept_code = 'กรุณาระบุหน่วยงานที่ขอ';
    if (!form_state.requested_amount.trim()) errors.requested_amount = 'กรุณาระบุจำนวนที่ขอ';
    if (!form_state.approved_quota.trim()) errors.approved_quota = 'กรุณาระบุโควต้าที่ได้';

    const requested_amount = Number(form_state.requested_amount);
    const approved_quota = Number(form_state.approved_quota);
    const sequence_no = Number(form_state.sequence_no);
    const budget_year = Number(form_state.budget_year);

    if (!Number.isFinite(requested_amount) || requested_amount < 0) {
      errors.requested_amount = 'จำนวนที่ขอต้องเป็นตัวเลขตั้งแต่ 0 ขึ้นไป';
    }
    if (!Number.isFinite(approved_quota) || approved_quota < 0) {
      errors.approved_quota = 'โควต้าที่ได้ต้องเป็นตัวเลขตั้งแต่ 0 ขึ้นไป';
    }
    if (![1, 2].includes(sequence_no)) {
      errors.sequence_no = 'ครั้งที่ต้องเป็น 1 หรือ 2';
    }
    if (!Number.isFinite(budget_year) || budget_year <= 0) {
      errors.budget_year = 'ปีงบไม่ถูกต้อง';
    }

    set_form_errors(errors);
    return Object.keys(errors).length === 0;
  };

  const handle_submit = async (event: React.FormEvent) => {
    event.preventDefault();

    if (!editing_usage_plan) {
      const errors: Record<string, string> = {};

      if (!form_state.requesting_dept_code.trim()) {
        errors.requesting_dept_code = 'กรุณาเลือกหน่วยงานที่ต้องการใช้';
      }

      if (!selected_bulk_category.trim()) {
        errors.category = 'กรุณาเลือกหมวดก่อนเพิ่มรายการสินค้า';
      }

      const budget_year = Number(form_state.budget_year);
      if (!Number.isFinite(budget_year) || budget_year <= 0) {
        errors.budget_year = 'ปีงบไม่ถูกต้อง';
      }

      if (bulk_items.length === 0) {
        errors.product_code = 'กรุณาเพิ่มสินค้าอย่างน้อย 1 รายการ';
      }

      const duplicate_product_codes = bulk_items.filter((item, index, self) => self.findIndex((t) => t.product_code === item.product_code) !== index);
      if (duplicate_product_codes.length > 0) {
        errors.product_code = 'ไม่สามารถมีรหัสสินค้าซ้ำกันได้';
      }

      const invalid_item = bulk_items.find((item) => {
        const requested_amount = Number(item.requested_amount);
        return !item.product_code.trim()
          || !Number.isFinite(requested_amount)
          || requested_amount < 0;
      });

      if (invalid_item) {
        errors.requested_amount = 'กรุณาตรวจสอบจำนวนที่ขอให้เป็นตัวเลขตั้งแต่ 0 ขึ้นไป';
      }

      set_form_errors(errors);
      if (Object.keys(errors).length > 0) return;

      const payload = {
        requesting_dept_code: form_state.requesting_dept_code.trim(),
        budget_year,
        items: bulk_items.map((item) => ({
          product_code: item.product_code.trim(),
          requested_amount: Number(item.requested_amount),
          approved_quota: Number(item.requested_amount),
        })),
      };

      try {
        set_saving(true);
        const response = await fetch('/api/usage-plans/bulk', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        });

        if (!response.ok) {
          const error_data = await response.json().catch(() => null);
          throw new Error(error_data?.error || 'บันทึกข้อมูลไม่สำเร็จ');
        }

        const data = await response.json().catch(() => null);

        set_show_form(false);
        set_bulk_items([]);
        set_product_search('');
        await fetch_usage_plans();
        await Swal.fire({
          icon: 'success',
          title: 'บันทึกสำเร็จ',
          text: `เพิ่มแผนการใช้ ${data?.created_count ?? payload.items.length} รายการ`,
          timer: 1200,
          showConfirmButton: false,
        });
      } catch (error) {
        await Swal.fire({
          icon: 'error',
          title: 'บันทึกไม่สำเร็จ',
          text: error instanceof Error ? error.message : 'เกิดข้อผิดพลาด',
        });
      } finally {
        set_saving(false);
      }

      return;
    }

    if (!validate_form()) return;

    const payload = {
      product_code: form_state.product_code.trim(),
      requesting_dept_code: form_state.requesting_dept_code.trim(),
      requested_amount: Number(form_state.requested_amount),
      approved_quota: Number(form_state.approved_quota),
      budget_year: Number(form_state.budget_year),
      sequence_no: Number(form_state.sequence_no),
    };

    try {
      set_saving(true);
      const url = editing_usage_plan ? `/api/usage-plans/${editing_usage_plan.id}` : '/api/usage-plans';
      const method = editing_usage_plan ? 'PUT' : 'POST';
      const response = await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const error_data = await response.json().catch(() => null);
        throw new Error(error_data?.error || 'บันทึกข้อมูลไม่สำเร็จ');
      }

      set_show_form(false);
      await fetch_usage_plans();
      await Swal.fire({ icon: 'success', title: 'บันทึกสำเร็จ', timer: 1000, showConfirmButton: false });
    } catch (error) {
      await Swal.fire({
        icon: 'error',
        title: 'บันทึกไม่สำเร็จ',
        text: error instanceof Error ? error.message : 'เกิดข้อผิดพลาด',
      });
    } finally {
      set_saving(false);
    }
  };

  const handle_delete = async (row: UsagePlanRow) => {
    if (row.has_purchase_plan) {
      await Swal.fire({
        icon: 'error',
        title: 'ไม่สามารถลบได้',
        text: 'รายการนี้ถูกใช้สร้างแผนจัดซื้อแล้ว',
      });
      return;
    }

    const result = await Swal.fire({
      icon: 'warning',
      title: 'ยืนยันการลบ',
      text: `ต้องการลบรายการ ${row.product_code || '-'} ใช่หรือไม่`,
      showCancelButton: true,
      confirmButtonText: 'ลบ',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#dc2626',
    });

    if (!result.isConfirmed) return;

    try {
      const response = await fetch(`/api/usage-plans/${row.id}`, { method: 'DELETE' });
      if (!response.ok) throw new Error('ลบข้อมูลไม่สำเร็จ');
      await fetch_usage_plans();
    } catch (error) {
      await Swal.fire({ icon: 'error', title: 'ลบไม่สำเร็จ', text: error instanceof Error ? error.message : 'เกิดข้อผิดพลาด' });
    }
  };

  return (
    <div className="p-6 bg-gray-50 min-h-screen">
      <div className="mb-3 flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-gray-900">แผนการใช้</h1>
        <button
          type="button"
          onClick={open_create_form}
          className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700"
        >
          เพิ่มรายการ
        </button>
      </div>

      <div className="rounded-xl border border-gray-200 bg-white p-4">
        <div className="mb-4 flex flex-wrap gap-3">
          <select value={budget_year_filter} onChange={(event) => { set_budget_year_filter(event.target.value); set_page(1); }} className="flex-1 min-w-[100px] rounded-lg border border-gray-300 px-3 py-2 text-sm">
            <option value="">ทุกปีงบ</option>
            {Array.from(new Set([...(effective_budget_year ? [effective_budget_year] : []), ...budget_years])).sort((a, b) => b - a).map((year) => (<option key={year} value={String(year)}>{year}</option>))}
          </select>
          <select value={requesting_dept_code_filter} onChange={(event) => { set_requesting_dept_code_filter(event.target.value); set_page(1); }} className="flex-1 min-w-[140px] rounded-lg border border-gray-300 px-3 py-2 text-sm">
            <option value="">ทุกหน่วยงาน</option>
            {departments.map((department) => (<option key={department.department_code} value={department.department_code}>{department.name}</option>))}
          </select>
          <select value={plan_flag_filter} onChange={(event) => { set_plan_flag_filter(event.target.value); set_page(1); }} className="flex-1 min-w-[100px] rounded-lg border border-gray-300 px-3 py-2 text-sm">
            <option value="">ทุกแผน</option>
            <option value="ในแผน">ในแผน</option>
            <option value="นอกแผน">นอกแผน</option>
          </select>
          <select value={category_filter} onChange={(event) => { set_category_filter(event.target.value); set_page(1); }} className="flex-1 min-w-[120px] rounded-lg border border-gray-300 px-3 py-2 text-sm">
            <option value="">ทุกหมวด</option>
            {unique_categories.map((category) => (<option key={category} value={category}>{category}</option>))}
          </select>
          <select value={type_filter} onChange={(event) => { set_type_filter(event.target.value); set_page(1); }} disabled={!category_filter} className="flex-1 min-w-[120px] rounded-lg border border-gray-300 px-3 py-2 text-sm">
            <option value="">ทุกประเภท</option>
            {available_types_for_category.map((type) => (<option key={type} value={type}>{type}</option>))}
          </select>
          <input type="text" value={product_code_filter} onChange={(event) => { set_product_code_filter(event.target.value); set_page(1); }} placeholder="ค้นหารหัส/ชื่อสินค้า" className="flex-1 min-w-[180px] rounded-lg border border-gray-300 px-3 py-2 text-sm" />
        </div>

        <div className="mb-3 flex flex-col gap-2 rounded-lg border border-gray-100 bg-gray-50 px-3 py-2 text-sm text-gray-600 md:flex-row md:items-center md:justify-between">
          <div className="font-medium text-gray-700">หน้า {page} / {total_pages}</div>
          <div className="flex flex-wrap items-center gap-2">
            <div className="rounded border border-gray-200 bg-white px-2 py-1 text-xs text-gray-600">
              รวม {total_count.toLocaleString()} รายการ
            </div>
            <div className="rounded border border-gray-200 bg-white px-2 py-1 text-xs text-gray-600">
              รวมมูลค่า {total_value_amount.toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} บาท
            </div>
            <select
              aria-label="เลือกจำนวนรายการต่อหน้า"
              value={String(page_size)}
              onChange={(event) => {
                const next_size = Number(event.target.value);
                if (![20, 50, 100].includes(next_size)) return;
                set_page_size(next_size);
                set_page(1);
              }}
              className="rounded border border-gray-300 px-2 py-1 text-sm"
            >
              <option value="20">20</option>
              <option value="50">50</option>
              <option value="100">100</option>
            </select>
            <button
              type="button"
              disabled={page <= 1}
              onClick={() => set_page((prev) => Math.max(1, prev - 1))}
              className="rounded border border-gray-300 px-2 py-1 disabled:opacity-50"
            >
              ก่อนหน้า
            </button>
            <button
              type="button"
              disabled={page >= total_pages}
              onClick={() => set_page((prev) => Math.min(total_pages, prev + 1))}
              className="rounded border border-gray-300 px-2 py-1 disabled:opacity-50"
            >
              ถัดไป
            </button>
          </div>
        </div>

          <div className="overflow-x-auto">
            <table className="w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th onClick={() => handleSort('id')} className={getHeaderClass('id')} aria-sort={sort_by === 'id' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1"># {renderSortIcon('id')}</span></th>
                  <th onClick={() => handleSort('budget_year')} className={getHeaderClass('budget_year')} aria-sort={sort_by === 'budget_year' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1">ปีงบ {renderSortIcon('budget_year')}</span></th>
                  <th onClick={() => handleSort('sequence_no')} className={getHeaderClass('sequence_no')} aria-sort={sort_by === 'sequence_no' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1">ครั้งที่ {renderSortIcon('sequence_no')}</span></th>
                  <th onClick={() => handleSort('product_code')} className={getHeaderClass('product_code')} aria-sort={sort_by === 'product_code' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1">รหัสสินค้า {renderSortIcon('product_code')}</span></th>
                  <th onClick={() => handleSort('product_name')} className={`${getHeaderClass('product_name')} w-[300px]`} aria-sort={sort_by === 'product_name' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1">ชื่อสินค้า {renderSortIcon('product_name')}</span></th>
                  <th onClick={() => handleSort('requesting_dept')} className={`${getHeaderClass('requesting_dept')} pl-2`} aria-sort={sort_by === 'requesting_dept' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1">หน่วยงาน {renderSortIcon('requesting_dept')}</span></th>
                  <th onClick={() => handleSort('plan_flag')} className={getHeaderClass('plan_flag')} aria-sort={sort_by === 'plan_flag' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1">แผน {renderSortIcon('plan_flag')}</span></th>
                  <th onClick={() => handleSort('unit')} className={getHeaderClass('unit')} aria-sort={sort_by === 'unit' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1">หน่วยนับ {renderSortIcon('unit')}</span></th>
                  <th onClick={() => handleSort('requested_amount')} className={getHeaderClass('requested_amount')} aria-sort={sort_by === 'requested_amount' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1 justify-end">จำนวนขอ {renderSortIcon('requested_amount')}</span></th>
                  <th onClick={() => handleSort('approved_quota')} className={getHeaderClass('approved_quota')} aria-sort={sort_by === 'approved_quota' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1 justify-end">โควต้า {renderSortIcon('approved_quota')}</span></th>
                  <th onClick={() => handleSort('price_per_unit')} className={getHeaderClass('price_per_unit')} aria-sort={sort_by === 'price_per_unit' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1 justify-end">ราคา/หน่วย (บาท) {renderSortIcon('price_per_unit')}</span></th>
                  <th onClick={() => handleSort('total_value')} className={getHeaderClass('total_value')} aria-sort={sort_by === 'total_value' ? (sort_order === 'asc' ? 'ascending' : 'descending') : 'none'}><span className="inline-flex items-center gap-1 justify-end">รวมมูลค่า {renderSortIcon('total_value')}</span></th>
                  <th className="px-3 py-2 text-center text-xs font-semibold uppercase text-gray-500">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={14} className="px-3 py-6 text-center text-sm text-gray-500">กำลังโหลดข้อมูล...</td>
                  </tr>
                ) : usage_plans.length === 0 ? (
                  <tr>
                    <td colSpan={14} className="px-3 py-6 text-center text-sm text-gray-500">ไม่พบข้อมูล</td>
                  </tr>
                ) : (
                  usage_plans.map((row, index) => (
                    <tr key={`${row.id}-${row.product_code}-${row.requesting_dept_code}-${row.budget_year}-${row.sequence_no}`} className={`hover:bg-gray-50 ${editing_cell?.row_id === row.id ? 'bg-green-100' : ''}`}>
                      <td className="whitespace-nowrap px-3 py-2 text-xs text-gray-700">{(page - 1) * page_size + index + 1}</td>
                      <td className="whitespace-nowrap px-3 py-2 text-xs text-gray-700">{row.budget_year ?? '-'}</td>
                      <td className="whitespace-nowrap px-3 py-2 text-xs text-gray-700">{row.sequence_no ?? '-'}</td>
                      <td className="whitespace-nowrap px-3 py-2 text-xs text-gray-700">{row.product_code || '-'}</td>
                      <td className="w-[300px] pr-2 py-2 text-xs text-gray-700">
                        <div className="font-medium text-gray-800 text-xs break-words">{row.product_name || '-'}</div>
                        <div className="mt-0.5 text-[10px] text-yellow-600">
                          {[row.category, row.type, row.subtype].filter(Boolean).join(' - ') || '-'}
                        </div>
                      </td>
                      <td className="pl-2 py-2 text-xs text-gray-700 align-top">{row.requesting_dept || '-'}</td>
                      <td className="px-3 py-2 text-xs align-top">
                        <span
                          className={`inline-flex rounded-full px-2 py-0.5 text-[11px] font-medium ${
                            row.plan_flag === 'นอกแผน'
                              ? 'bg-red-100 text-red-700'
                              : 'bg-emerald-100 text-emerald-700'
                          }`}
                        >
                          {row.plan_flag === 'นอกแผน' ? 'นอกแผน' : 'ในแผน'}
                        </span>
                      </td>
                      <td className="px-3 py-2 text-xs text-gray-700 align-top">{row.unit || '-'}</td>
                      <td
                        className="px-3 py-2 text-right text-xs text-gray-700 align-top"
                        onClick={() => start_cell_edit(row, 'requested_amount')}
                      >
                        {editing_cell?.row_id === row.id && editing_cell.field === 'requested_amount' ? (
                          <input
                            autoFocus
                            type="number"
                            min={0}
                            value={editing_cell_value}
                            onChange={(event) => set_editing_cell_value(event.target.value)}
                            onFocus={(event) => event.target.select()}
                            onBlur={() => {
                              if (skip_blur_save_ref.current) {
                                skip_blur_save_ref.current = false;
                                return;
                              }
                              void save_cell_edit(row, 'requested_amount', editing_cell_value);
                            }}
                            onKeyDown={(event) => handle_editable_cell_key_down(event, row, 'requested_amount')}
                            className="w-24 rounded border border-gray-300 px-2 py-1 text-right text-xs"
                          />
                        ) : (
                          <span className="cursor-pointer text-xs">{row.requested_amount ?? 0}</span>
                        )}
                      </td>
                      <td
                        className="px-3 py-2 text-right text-xs text-gray-700 align-top"
                        onClick={() => start_cell_edit(row, 'approved_quota')}
                      >
                        {editing_cell?.row_id === row.id && editing_cell.field === 'approved_quota' ? (
                          <input
                            autoFocus
                            type="number"
                            min={0}
                            value={editing_cell_value}
                            onChange={(event) => set_editing_cell_value(event.target.value)}
                            onFocus={(event) => event.target.select()}
                            onBlur={() => {
                              if (skip_blur_save_ref.current) {
                                skip_blur_save_ref.current = false;
                                return;
                              }
                              void save_cell_edit(row, 'approved_quota', editing_cell_value);
                            }}
                            onKeyDown={(event) => handle_editable_cell_key_down(event, row, 'approved_quota')}
                            className="w-24 rounded border border-gray-300 px-2 py-1 text-right text-xs"
                          />
                        ) : (
                          <span className="cursor-pointer text-xs">{row.approved_quota ?? 0}</span>
                        )}
                      </td>
                      <td className="px-3 py-2 text-right text-xs text-gray-700 align-top">
                        {Number(row.price_per_unit ?? 0).toLocaleString('th-TH', {
                          minimumFractionDigits: 2,
                          maximumFractionDigits: 2,
                        })}
                      </td>
                      <td className="px-3 py-2 text-right text-xs text-gray-700 align-top">
                        {(Number(row.approved_quota ?? 0) * Number(row.price_per_unit ?? 0)).toLocaleString('th-TH', {
                          minimumFractionDigits: 2,
                          maximumFractionDigits: 2,
                        })}
                      </td>
                      <td className="px-3 py-2 text-center text-xs">
                        <div className="inline-flex items-center gap-2">
                          <button
                            type="button"
                            disabled={saving}
                            onClick={() => void handle_delete(row)}
                            className="inline-flex h-8 w-8 items-center justify-center rounded border border-red-300 text-red-700 hover:bg-red-50 disabled:opacity-50"
                            aria-label={`ลบ ${row.product_code || 'รายการ'}`}
                            title="ลบ"
                          >
                            <svg viewBox="0 0 24 24" className="h-4 w-4" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
                              <path d="M3 6h18" />
                              <path d="M8 6V4h8v2" />
                              <path d="M19 6l-1 14H6L5 6" />
                              <path d="M10 11v6" />
                              <path d="M14 11v6" />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

      {show_form && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-5xl rounded-xl bg-white shadow-lg">
            <form onSubmit={handle_submit}>
              <div className="border-b border-gray-100 px-5 py-4">
                <h2 className="text-lg font-semibold text-gray-900">
                  {editing_usage_plan ? 'แก้ไขแผนการใช้' : 'เพิ่มแผนการใช้'}
                </h2>
              </div>

              <div className="grid grid-cols-1 gap-4 px-5 py-4 md:grid-cols-2">
                <div>
                  <label className="mb-1 block text-sm font-medium text-gray-700">หน่วยงานที่ต้องการใช้</label>
                  <select
                    value={form_state.requesting_dept_code}
                    onChange={(event) => {
                      set_form_state((prev) => ({ ...prev, requesting_dept_code: event.target.value }));
                      set_form_errors((prev) => {
                        const next = { ...prev };
                        delete next.requesting_dept_code;
                        return next;
                      });
                    }}
                    className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.requesting_dept_code ? 'border-red-500' : 'border-gray-300'}`}
                  >
                    <option value="">เลือกหน่วยงาน</option>
                    {form_department_options.map((department) => (
                      <option key={department.department_code} value={department.department_code}>
                        {department.name}
                      </option>
                    ))}
                  </select>
                  {form_errors.requesting_dept_code && <p className="mt-1 text-xs text-red-600">{form_errors.requesting_dept_code}</p>}
                </div>

                <div>
                  <div className={`grid grid-cols-1 gap-4 ${!editing_usage_plan ? 'md:grid-cols-2' : ''}`}>
                    <div>
                      <label className="mb-1 block text-sm font-medium text-gray-700">ปีงบ</label>
                      <input
                        type="number"
                        value={form_state.budget_year}
                        onChange={(event) => set_form_state((prev) => ({ ...prev, budget_year: event.target.value }))}
                        className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.budget_year ? 'border-red-500' : 'border-gray-300'}`}
                      />
                      {form_errors.budget_year && <p className="mt-1 text-xs text-red-600">{form_errors.budget_year}</p>}
                    </div>

                    {!editing_usage_plan ? (
                      <div>
                        <label className="mb-1 block text-sm font-medium text-gray-700">หมวด</label>
                        <select
                          value={selected_bulk_category}
                          onChange={(event) => {
                            set_selected_bulk_category(event.target.value);
                            set_product_search('');
                            set_form_errors((prev) => {
                              const next = { ...prev };
                              delete next.category;
                              delete next.product_code;
                              return next;
                            });
                          }}
                          className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.category ? 'border-red-500' : 'border-gray-300'}`}
                        >
                          <option value="">เลือกหมวด</option>
                          {category_options.map((category) => (
                            <option key={category} value={category}>
                              {category}
                            </option>
                          ))}
                        </select>
                        {form_errors.category && <p className="mt-1 text-xs text-red-600">{form_errors.category}</p>}
                      </div>
                    ) : null}
                  </div>
                </div>

                {!editing_usage_plan ? (
                  <>
                    <div className="md:col-span-2 rounded-lg border border-gray-200 bg-gray-50 p-3">
                      <p className="text-xs text-gray-500">เลือกหน่วยงานและหมวดก่อน แล้วค้นหาด้วยรหัสหรือชื่อสินค้าเพื่อเพิ่มรายการแบบเร็ว</p>
                      <div className="mt-2 flex flex-col gap-2 md:flex-row md:items-start">
                        <div className="relative flex-1">
                          <input
                            ref={bulk_product_input_ref}
                            type="text"
                            autoComplete="off"
                            value={product_search}
                            onFocus={() => {
                              set_is_bulk_product_search_focused(true);
                              set_active_bulk_product_suggestion_index(-1);
                            }}
                            onBlur={() => {
                              window.setTimeout(() => {
                                set_is_bulk_product_search_focused(false);
                                set_active_bulk_product_suggestion_index(-1);
                              }, 120);
                            }}
                            onChange={(event) => {
                              set_product_search(event.target.value);
                              set_form_errors((prev) => {
                                const next = { ...prev };
                                delete next.product_code;
                                return next;
                              });
                            }}
                            onKeyDown={(event) => {
                              if (event.key === 'ArrowDown' && filtered_product_options.length > 0) {
                                event.preventDefault();
                                set_active_bulk_product_suggestion_index((prev) => {
                                  if (prev < filtered_product_options.length - 1) return prev + 1;
                                  return 0;
                                });
                                return;
                              }

                              if (event.key === 'ArrowUp' && filtered_product_options.length > 0) {
                                event.preventDefault();
                                set_active_bulk_product_suggestion_index((prev) => {
                                  if (prev > 0) return prev - 1;
                                  return filtered_product_options.length - 1;
                                });
                                return;
                              }

                              if (event.key === 'Enter') {
                                event.preventDefault();
                                if (show_bulk_product_suggestions && active_bulk_product_suggestion_index >= 0) {
                                  const selected_option = filtered_product_options[active_bulk_product_suggestion_index];
                                  if (selected_option) {
                                    add_bulk_item_from_suggestion(selected_option);
                                  }
                                  return;
                                }
                                add_product_to_bulk_items();
                              }

                              if (event.key === 'Escape') {
                                set_active_bulk_product_suggestion_index(-1);
                                set_is_bulk_product_search_focused(false);
                              }
                            }}
                            disabled={!form_state.requesting_dept_code.trim() || !selected_bulk_category.trim()}
                            className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.product_code ? 'border-red-500' : 'border-gray-300'} disabled:bg-gray-100`}
                            placeholder="ค้นหาชื่อ/รหัสสินค้า แล้วกด Enter"
                          />
                          {show_bulk_product_suggestions ? (
                            <div className="absolute left-0 right-0 z-20 mt-1 max-h-64 overflow-auto rounded-lg border border-gray-200 bg-white shadow-lg">
                              {filtered_product_options.map((option, index) => (
                                <button
                                  key={option.code}
                                  ref={(element) => {
                                    bulk_product_suggestion_item_refs.current[index] = element;
                                  }}
                                  type="button"
                                  aria-selected={active_bulk_product_suggestion_index === index}
                                  onMouseDown={(event) => {
                                    event.preventDefault();
                                    select_bulk_product_suggestion(option);
                                  }}
                                  className={`block w-full border-b border-gray-100 px-3 py-2 text-left text-sm text-gray-700 last:border-b-0 ${active_bulk_product_suggestion_index === index ? 'bg-blue-50' : 'hover:bg-blue-50'}`}
                                >
                                  <span className="font-medium text-gray-900">{option.code}</span>
                                  <span className="ml-2 text-gray-600">{option.name}</span>
                                </button>
                              ))}
                            </div>
                          ) : null}
                        </div>
                        <button
                          type="button"
                          disabled={!form_state.requesting_dept_code.trim() || !selected_bulk_category.trim()}
                          onClick={() => add_product_to_bulk_items()}
                          className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:cursor-not-allowed disabled:opacity-60"
                        >
                          เพิ่มเข้ารายการ
                        </button>
                      </div>
                      {form_errors.product_code && <p className="mt-1 text-xs text-red-600">{form_errors.product_code}</p>}
                    </div>

                    <div className="md:col-span-2 overflow-hidden rounded-lg border border-gray-200">
                      <div className="max-h-72 overflow-auto">
                        <table className="min-w-full divide-y divide-gray-200">
                          <thead className="bg-gray-50">
                            <tr>
                              <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">รหัสสินค้า</th>
                              <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">ชื่อสินค้า</th>
                              <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">จำนวนที่ขอ</th>
                              <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">หน่วย</th>
                              <th className="px-3 py-2 text-center text-xs font-semibold uppercase text-gray-500">ลบ</th>
                            </tr>
                          </thead>
                          <tbody className="divide-y divide-gray-100 bg-white">
                            {bulk_items.length === 0 ? (
                              <tr>
                                <td colSpan={5} className="px-3 py-6 text-center text-sm text-gray-500">ยังไม่มีรายการสินค้า</td>
                              </tr>
                            ) : (
                              bulk_items.map((item) => (
                                <tr key={item.temp_id}>
                                  <td className="whitespace-nowrap px-3 py-2 text-sm text-gray-700">{item.product_code}</td>
                                  <td className="px-3 py-2 text-sm text-gray-700">
                                    <div className="font-medium text-gray-800">{item.product_name}</div>
                                    <div className="mt-0.5 text-xs text-gray-400">{[item.category, item.type, item.subtype].filter(Boolean).join(' - ') || '-'}</div>
                                  </td>
                                  <td className="px-3 py-2">
                                    <input
                                      type="number"
                                      min={0}
                                      value={item.requested_amount}
                                      onChange={(event) => update_bulk_item(item.temp_id, 'requested_amount', event.target.value)}
                                      className="w-24 rounded border border-gray-300 px-2 py-1 text-right text-sm"
                                    />
                                  </td>
                                  <td className="whitespace-nowrap px-3 py-2 text-sm text-gray-700">{item.unit || '-'}</td>
                                  <td className="px-3 py-2 text-center">
                                    <button
                                      type="button"
                                      onClick={() => remove_bulk_item(item.temp_id)}
                                      className="inline-flex h-7 w-7 items-center justify-center rounded border border-red-300 text-red-700 hover:bg-red-50"
                                      aria-label={`ลบ ${item.product_code}`}
                                    >
                                      ×
                                    </button>
                                  </td>
                                </tr>
                              ))
                            )}
                          </tbody>
                        </table>
                      </div>
                      {form_errors.requested_amount && <p className="px-3 py-2 text-xs text-red-600">{form_errors.requested_amount}</p>}
                    </div>
                  </>
                ) : null}

                {editing_usage_plan ? (
                  <>
                    <div>
                      <label className="mb-1 block text-sm font-medium text-gray-700">รหัสสินค้า</label>
                      <input
                        type="text"
                        value={form_state.product_code}
                        onChange={(event) => {
                          const next = event.target.value;
                          set_form_state((prev) => ({ ...prev, product_code: next }));
                          set_product_search(next);
                        }}
                        list="usage-plan-product-options"
                        className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.product_code ? 'border-red-500' : 'border-gray-300'}`}
                        placeholder="เช่น P230-000001"
                      />
                      <datalist id="usage-plan-product-options">
                        {filtered_product_options.map((option) => (
                          <option key={option.code} value={option.code} label={`${option.code} - ${option.name}`} />
                        ))}
                      </datalist>
                      {form_errors.product_code && <p className="mt-1 text-xs text-red-600">{form_errors.product_code}</p>}
                    </div>

                    <div>
                      <label className="mb-1 block text-sm font-medium text-gray-700">ครั้งที่</label>
                      <select
                        value={form_state.sequence_no}
                        onChange={(event) => set_form_state((prev) => ({ ...prev, sequence_no: event.target.value }))}
                        className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.sequence_no ? 'border-red-500' : 'border-gray-300'}`}
                      >
                        <option value="1">1</option>
                        <option value="2">2</option>
                      </select>
                      {form_errors.sequence_no && <p className="mt-1 text-xs text-red-600">{form_errors.sequence_no}</p>}
                    </div>

                    <div>
                      <label className="mb-1 block text-sm font-medium text-gray-700">จำนวนที่ขอ</label>
                      <input
                        type="number"
                        min={0}
                        value={form_state.requested_amount}
                        onChange={(event) => set_form_state((prev) => ({ ...prev, requested_amount: event.target.value }))}
                        className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.requested_amount ? 'border-red-500' : 'border-gray-300'}`}
                      />
                      {form_errors.requested_amount && <p className="mt-1 text-xs text-red-600">{form_errors.requested_amount}</p>}
                    </div>

                    <div>
                      <label className="mb-1 block text-sm font-medium text-gray-700">โควต้าที่ได้</label>
                      <input
                        type="number"
                        min={0}
                        value={form_state.approved_quota}
                        onChange={(event) => set_form_state((prev) => ({ ...prev, approved_quota: event.target.value }))}
                        className={`w-full rounded-lg border px-3 py-2 text-sm ${form_errors.approved_quota ? 'border-red-500' : 'border-gray-300'}`}
                      />
                      {form_errors.approved_quota && <p className="mt-1 text-xs text-red-600">{form_errors.approved_quota}</p>}
                    </div>
                  </>
                ) : null}

                <div className="md:col-span-2 rounded-lg bg-blue-50 px-3 py-2 text-xs text-blue-800">
                  เงื่อนไข: หน่วยงานเดียวกัน ในปีงบเดียวกัน ขอสินค้ารหัสเดียวกันได้ไม่เกิน 2 ครั้ง
                </div>
              </div>

              <div className="flex items-center justify-end gap-3 border-t border-gray-100 px-5 py-4">
                <button
                  type="button"
                  onClick={() => set_show_form(false)}
                  className="rounded-lg border border-gray-300 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                >
                  ยกเลิก
                </button>
                <button
                  type="submit"
                  disabled={saving}
                  className="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 disabled:opacity-60"
                >
                  {saving ? 'กำลังบันทึก...' : 'บันทึก'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default function UsagePlansMinimalPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gray-50" />}>
      <UsagePlansPageContent />
    </Suspense>
  );
}
