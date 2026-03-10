'use client';

import { useState, useEffect, useMemo } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { Check, X, Pencil, Trash2, ChevronUp, ChevronDown, ArrowUpDown } from 'lucide-react';

type Product = {
  id: number;
  code: string;
  category: string;
  name: string;
  type: string;
  subtype: string;
  unit: string;
  cost_price?: number | null;
  sell_price?: number | null;
  stock_balance?: number | null;
  stock_value?: number | null;
  seller_code?: string | null;
  image?: string | null;
  flag_activate?: boolean;
  admin_note?: string | null;
};

interface CategoryOption {
  category: string;
  type: string;
  subtype: string | null;
}

interface SellerOption {
  code: string;
  name: string;
}

interface ProductFormData {
  code: string;
  category: string;
  name: string;
  type: string;
  subtype: string;
  unit: string;
  cost_price?: number;
  sell_price?: number;
  stock_balance?: number;
  stock_value?: number;
  seller_code?: string;
  image?: string;
  admin_note?: string;
}

const PAGE_SIZE_OPTIONS = [10, 20, 50];

export default function ProductsPage() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const initialCodeFilter = searchParams.get('code') || '';
  const initialNameFilter = searchParams.get('name') || '';
  const initialCategoryFilter = searchParams.get('category') || '';
  const initialTypeFilter = searchParams.get('type') || '';
  const initialSubtypeFilter = searchParams.get('subtype') || '';
  const initialSortBy = searchParams.get('order_by') || 'code';
  const initialSortOrder = (searchParams.get('sort_order') === 'desc' ? 'desc' : 'asc') as 'asc' | 'desc';
  const initialPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
  const initialPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);
  const [products, setProducts] = useState<Product[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [formData, setFormData] = useState<ProductFormData>({
    code: '',
    category: '',
    name: '',
    type: '',
    subtype: '',
    unit: '',
    cost_price: undefined,
    sell_price: undefined,
    stock_balance: undefined,
    stock_value: undefined,
    seller_code: '',
    image: '',
    admin_note: ''
  });
  
  // Validation state
  const [errors, setErrors] = useState<Record<string, string>>({});
  
  // Filter states
  const [codeFilter, setCodeFilter] = useState(initialCodeFilter);
  const [nameFilter, setNameFilter] = useState(initialNameFilter);
  const [categoryFilter, setCategoryFilter] = useState(initialCategoryFilter);
  const [typeFilter, setTypeFilter] = useState(initialTypeFilter);
  const [subtypeFilter, setSubtypeFilter] = useState(initialSubtypeFilter);
  
  // Sorting states
  const [sortBy, setSortBy] = useState(initialSortBy);
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>(initialSortOrder);
  const [page, setPage] = useState(initialPage);
  const [pageSize, setPageSize] = useState(initialPageSize);

  // Toast state for notifications
  const [toast, setToast] = useState<{
    message: string;
    type: 'success' | 'error';
    visible: boolean;
  }>({
    message: '',
    type: 'success',
    visible: false
  });

  // Inline editing state
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editData, setEditData] = useState<ProductFormData>({
    code: '',
    category: '',
    name: '',
    type: '',
    subtype: '',
    unit: '',
    cost_price: undefined,
    sell_price: undefined,
    stock_balance: undefined,
    stock_value: undefined,
    seller_code: '',
    image: '',
    admin_note: ''
  });

  // Bulk add state
  const [showBulkForm, setShowBulkForm] = useState(false);
  const [bulkRecords, setBulkRecords] = useState<any[]>([]);

  // Dynamic filter options (fetched from API)
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [units, setUnits] = useState<string[]>([]);
  const [sellerCodes, setSellerCodes] = useState<string[]>([]);
  const [sellerOptions, setSellerOptions] = useState<SellerOption[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<CategoryOption[]>([]);

  useEffect(() => {
    fetchFilterOptions();
  }, []);

  // Fetch products when filters or sorting change
  useEffect(() => {
    fetchProducts();
  }, [codeFilter, nameFilter, categoryFilter, typeFilter, subtypeFilter, sortBy, sortOrder, page, pageSize]);

  useEffect(() => {
    setPage(1);
  }, [codeFilter, nameFilter, categoryFilter, typeFilter, subtypeFilter, sortBy, sortOrder]);

  useEffect(() => {
    const nextCode = searchParams.get('code') || '';
    const nextName = searchParams.get('name') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('type') || '';
    const nextSubtype = searchParams.get('subtype') || '';
    const nextSortBy = searchParams.get('order_by') || 'code';
    const nextSortOrder = (searchParams.get('sort_order') === 'desc' ? 'desc' : 'asc') as 'asc' | 'desc';
    const nextPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const nextPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);

    setCodeFilter((prev) => (prev === nextCode ? prev : nextCode));
    setNameFilter((prev) => (prev === nextName ? prev : nextName));
    setCategoryFilter((prev) => (prev === nextCategory ? prev : nextCategory));
    setTypeFilter((prev) => (prev === nextType ? prev : nextType));
    setSubtypeFilter((prev) => (prev === nextSubtype ? prev : nextSubtype));
    setSortBy((prev) => (prev === nextSortBy ? prev : nextSortBy));
    setSortOrder((prev) => (prev === nextSortOrder ? prev : nextSortOrder));
    setPage((prev) => (prev === nextPage ? prev : nextPage));
    setPageSize((prev) => (prev === nextPageSize ? prev : nextPageSize));
  }, [searchParams]);

  useEffect(() => {
    const params = new URLSearchParams();

    if (codeFilter) params.set('code', codeFilter);
    if (nameFilter) params.set('name', nameFilter);
    if (categoryFilter) params.set('category', categoryFilter);
    if (typeFilter) params.set('type', typeFilter);
    if (subtypeFilter) params.set('subtype', subtypeFilter);
    if (sortBy !== 'code') params.set('order_by', sortBy);
    if (sortOrder !== 'asc') params.set('sort_order', sortOrder);
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('page_size', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    const currentUrl = searchParams.toString() ? `${pathname}?${searchParams.toString()}` : pathname;

    if (nextUrl !== currentUrl) {
      router.replace(nextUrl, { scroll: false });
    }
  }, [pathname, router, searchParams, codeFilter, nameFilter, categoryFilter, typeFilter, subtypeFilter, sortBy, sortOrder, page, pageSize]);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name.includes('price') || name.includes('value') ? (value ? parseFloat(value) : undefined) :
               name === 'stock_balance' ? (value ? parseInt(value) : undefined) : value
    }));

    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => {
        const newErrors = { ...prev };
        delete newErrors[name];
        return newErrors;
      });
    }
  };

  const fetchFilterOptions = async () => {
    try {
      const response = await fetch('/api/products/filters');
      if (response.ok) {
        const data = await response.json();
        setCategories(data.categories || []);
        setTypes(data.types || []);
        setSubtypes(data.subtypes || []);
        setUnits(data.units || []);
        setSellerCodes(data.seller_codes || []);
        setSellerOptions(data.seller_options || []);
        setCategoryOptions(data.category_options || []);
      }
    } catch (error) {
      console.error('Error fetching filter options:', error);
    }
  };

  const availableFilterTypes = useMemo(() => {
    if (!categoryFilter) {
      return types;
    }

    return Array.from(
      new Set(
        categoryOptions
          .filter((option) => option.category === categoryFilter)
          .map((option) => option.type)
          .filter(Boolean)
      )
    );
  }, [categoryFilter, categoryOptions, types]);

  const availableFilterSubtypes = useMemo(() => {
    return Array.from(
      new Set(
        categoryOptions
          .filter((option) => {
            const categoryMatched = categoryFilter ? option.category === categoryFilter : true;
            const typeMatched = typeFilter ? option.type === typeFilter : true;
            return categoryMatched && typeMatched;
          })
          .map((option) => option.subtype)
          .filter(Boolean)
      )
    ) as string[];
  }, [categoryFilter, typeFilter, categoryOptions]);

  useEffect(() => {
    if (typeFilter && !availableFilterTypes.includes(typeFilter)) {
      setTypeFilter('');
      setSubtypeFilter('');
    }
  }, [availableFilterTypes, typeFilter]);

  useEffect(() => {
    if (subtypeFilter && !availableFilterSubtypes.includes(subtypeFilter)) {
      setSubtypeFilter('');
    }
  }, [availableFilterSubtypes, subtypeFilter]);

  const filteredTypeOptions = formData.category
    ? Array.from(
        new Set(
          categoryOptions
            .filter((option) => option.category === formData.category)
            .map((option) => option.type)
            .filter(Boolean)
        )
      )
    : types;

  const filteredSubtypeOptions = formData.type
    ? Array.from(
        new Set(
          categoryOptions
            .filter((option) => {
              const categoryMatched = formData.category ? option.category === formData.category : true;
              return categoryMatched && option.type === formData.type;
            })
            .map((option) => option.subtype)
            .filter(Boolean)
        )
      ) as string[]
    : subtypes;

  const handleLookupChange = (name: 'category' | 'type' | 'subtype', value: string) => {
    setFormData((prev) => {
      if (name === 'category') {
        return {
          ...prev,
          category: value,
          type: '',
          subtype: '',
        };
      }

      if (name === 'type') {
        return {
          ...prev,
          type: value,
          subtype: '',
        };
      }

      return {
        ...prev,
        subtype: value,
      };
    });

    if (errors[name]) {
      setErrors((prev) => {
        const newErrors = { ...prev };
        delete newErrors[name];
        return newErrors;
      });
    }
  };

  const fetchProducts = async () => {
    try {
      setLoading(true);
      
      // Build query string with filters and sorting
      const params = new URLSearchParams();
      
      if (codeFilter) params.append('code', codeFilter);
      if (nameFilter) params.append('name', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('subtype', subtypeFilter);
      
      // Add sorting parameters
      params.append('order_by', sortBy);
      params.append('sort_order', sortOrder);
      params.append('page', page.toString());
      params.append('page_size', pageSize.toString());
      
      const response = await fetch(`/api/products?${params.toString()}`);
      if (!response.ok) throw new Error('Failed to fetch products');
      const data = await response.json();
      setProducts(data.data || []);
      setTotalCount(data.totalCount);
      if (data.page && data.page !== page) {
        setPage(data.page);
      }
      if (data.page_size && data.page_size !== pageSize) {
        setPageSize(data.page_size);
      }
    } catch (err) {
      console.error('Error fetching products:', err);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + (products.length || 0) - 1);

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
  };

  const handlePageSizeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPageSize(parseInt(e.target.value, 10));
    setPage(1);
  };

  // Sorting function
  const handleSort = (column: string) => {
    if (sortBy === column) {
      // Toggle sort order if clicking the same column
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      // Set new column and default to ascending order
      setSortBy(column);
      setSortOrder('asc');
    }
  };
  
  // Function to get sort indicator
  const getSortIndicator = (column: string) => {
    if (sortBy === column) {
      return sortOrder === 'asc' ? ' ↑' : ' ↓';
    }
    return '';
  };
  
  // Function to get sort icon
  const getSortIcon = (column: string) => {
    if (sortBy === column) {
      return sortOrder === 'asc' ? (
        <ChevronUp className="w-4 h-4 inline-block ml-1" />
      ) : (
        <ChevronDown className="w-4 h-4 inline-block ml-1" />
      );
    }
    return <ArrowUpDown className="w-4 h-4 inline-block ml-1 text-gray-400" />;
  };
  
  // Function to get header class
  const getHeaderClass = (field: string) => {
    return `px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${
      sortBy === field ? 'bg-gray-100' : ''
    }`;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate required fields
    const newErrors: Record<string, string> = {};
    
    if (!formData.code.trim()) {
      newErrors.code = 'กรุณาระบุรหัสสินค้า';
    }
    
    if (!formData.category.trim()) {
      newErrors.category = 'กรุณาระบุหมวดหมู่';
    }
    
    if (!formData.name.trim()) {
      newErrors.name = 'กรุณาระบุชื่อสินค้า';
    }
    
    if (!formData.type.trim()) {
      newErrors.type = 'กรุณาระบุประเภท';
    }
    
    if (!formData.subtype.trim()) {
      newErrors.subtype = 'กรุณาระบุชนิดย่อย';
    }
    
    if (!formData.unit.trim()) {
      newErrors.unit = 'กรุณาระบุหน่วย';
    }
    
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }
    
    try {
      const url = editingProduct ? `/api/products/${editingProduct.id}` : '/api/products';
      const method = editingProduct ? 'PUT' : 'POST';
      
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        fetchProducts();
        resetForm();
      } else {
        const error = await response.json();
        await Swal.fire('เกิดข้อผิดพลาด', error.error || 'เกิดข้อผิดพลาดในการบันทึกข้อมูล', 'error');
      }
    } catch (error) {
      console.error('Error saving product:', error);
      await Swal.fire('เกิดข้อผิดพลาด', 'เกิดข้อผิดพลาดในการบันทึกข้อมูล', 'error');
    }
  };

  const handleEdit = (product: Product) => {
    setEditingProduct(product);
    setFormData({
      code: product.code,
      category: product.category,
      name: product.name,
      type: product.type || '',
      subtype: product.subtype || '',
      unit: product.unit || '',
      cost_price: product.cost_price ? Number(product.cost_price) : undefined,
      sell_price: product.sell_price ? Number(product.sell_price) : undefined,
      stock_balance: product.stock_balance || undefined,
      stock_value: product.stock_value ? Number(product.stock_value) : undefined,
      seller_code: product.seller_code || '',
      image: product.image || '',
      admin_note: product.admin_note || ''
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    const result = await Swal.fire({
      title: 'คุณแน่ใจหรือไม่?',
      text: 'คุณจะไม่สามารถกู้คืนสินค้านี้ได้!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'ใช่, ลบเลย!',
      cancelButtonText: 'ยกเลิก'
    });

    if (result.isConfirmed) {
      try {
        const response = await fetch(`/api/products/${id}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          await Swal.fire({
            title: 'ลบแล้ว!',
            text: 'สินค้าของคุณถูกลบแล้ว',
            icon: 'success',
            confirmButtonColor: '#3085d6'
          });
          fetchProducts();
        } else {
          await Swal.fire({
            title: 'เกิดข้อผิดพลาด!',
            text: 'เกิดข้อผิดพลาดในการลบสินค้า',
            icon: 'error',
            confirmButtonColor: '#3085d6'
          });
        }
      } catch (error) {
        console.error('Error deleting product:', error);
        await Swal.fire({
          title: 'เกิดข้อผิดพลาด!',
          text: 'เกิดข้อผิดพลาดในการลบสินค้า',
          icon: 'error',
          confirmButtonColor: '#3085d6'
        });
      }
    }
  };

  const resetForm = () => {
    setEditingProduct(null);
    setFormData({
      code: '',
      category: '',
      name: '',
      type: '',
      subtype: '',
      unit: '',
      cost_price: undefined,
      sell_price: undefined,
      stock_balance: undefined,
      stock_value: undefined,
      seller_code: '',
      image: '',
      admin_note: ''
    });
    setErrors({});
    setShowForm(false);
  };

  const modalInputClassName = 'mt-2 block w-full rounded-xl border border-gray-200 bg-white px-4 py-3 text-sm text-gray-900 shadow-sm outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100';
  const modalErrorInputClassName = 'border-red-500 focus:border-red-500 focus:ring-red-100';
  const modalCardClassName = 'rounded-2xl border border-gray-100 bg-gray-50/80 p-4';

  // Inline editing functions
  const startInlineEdit = (product: Product) => {
    setEditingId(product.id);
    setEditData({
      code: product.code,
      category: product.category,
      name: product.name,
      type: product.type || '',
      subtype: product.subtype || '',
      unit: product.unit || '',
      cost_price: product.cost_price ? Number(product.cost_price) : undefined,
      sell_price: product.sell_price ? Number(product.sell_price) : undefined,
      stock_balance: product.stock_balance || undefined,
      stock_value: product.stock_value ? Number(product.stock_value) : undefined,
      seller_code: product.seller_code || '',
      image: product.image || '',
      admin_note: product.admin_note || ''
    });
  };

  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/products/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editData)
      });

      if (response.ok) {
        setEditingId(null);
        setEditData({
          code: '', category: '', name: '', type: '', subtype: '', unit: '',
          cost_price: undefined, sell_price: undefined, stock_balance: undefined,
          stock_value: undefined, seller_code: '', image: '', admin_note: ''
        });
        fetchProducts();

        setToast({
          message: 'บันทึกข้อมูลสำเร็จ!',
          type: 'success',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      } else {
        setToast({
          message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
          type: 'error',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }
    } catch (error) {
      console.error('Error updating product:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    }
  };

  const cancelInlineEdit = () => {
    setEditingId(null);
    setEditData({
      code: '', category: '', name: '', type: '', subtype: '', unit: '',
      cost_price: undefined, sell_price: undefined, stock_balance: undefined,
      stock_value: undefined, seller_code: '', image: '', admin_note: ''
    });
  };

  // Save bulk products
  const saveBulkProducts = async () => {
    try {
      // Filter out empty records (require at least code, name, category, type, subtype, unit)
      const validRecords = bulkRecords.filter(record =>
        record.code?.trim() !== '' &&
        record.name?.trim() !== '' &&
        record.category?.trim() !== '' &&
        record.type?.trim() !== '' &&
        record.subtype?.trim() !== '' &&
        record.unit?.trim() !== ''
      );

      if (validRecords.length === 0) {
        setToast({
          message: 'กรุณากรอกข้อมูลให้ครบถ้วนอย่างน้อย 1 รายการ',
          type: 'error',
          visible: true
        });
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
        return;
      }

      // Send all valid records to the API
      const promises = validRecords.map(record =>
        fetch('/api/products', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            code: record.code.trim(),
            name: record.name.trim(),
            category: record.category.trim(),
            type: record.type.trim(),
            subtype: record.subtype.trim(),
            unit: record.unit.trim(),
            cost_price: record.cost_price,
            sell_price: record.sell_price,
            stock_balance: record.stock_balance,
            stock_value: record.stock_value,
            seller_code: record.seller_code || '',
            image: record.image || '',
            admin_note: record.admin_note || ''
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        fetchProducts();

        setToast({
          message: `บันทึกสำเร็จ ${successful} รายการ${failed > 0 ? `, ไม่สำเร็จ ${failed} รายการ` : ''}`,
          type: 'success',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }

      if (failed > 0 && successful === 0) {
        setToast({
          message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูลทั้งหมด',
          type: 'error',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }
    } catch (error) {
      console.error('Error saving bulk products:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-500"></div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Toast Notification */}
      {toast.visible && (
        <div className={`fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transition-all duration-300 ${
          toast.type === 'success'
            ? 'bg-green-500 text-white'
            : 'bg-red-500 text-white'
        }`}>
          <div className="flex items-center gap-2">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              {toast.type === 'success' ? (
                <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
              ) : (
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              )}
            </svg>
            <span>{toast.message}</span>
            <button
              onClick={() => setToast({ ...toast, visible: false })}
              className="ml-2 hover:opacity-75"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
              </svg>
            </button>
          </div>
        </div>
      )}

      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">รายการสินค้า</h1>
        <button
          onClick={() => setShowForm(true)}
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          เพิ่มสินค้าใหม่
        </button>
      </div>

      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-10 mx-auto w-11/12 max-w-5xl rounded-3xl bg-white shadow-2xl ring-1 ring-black/5">
            <div className="flex items-start justify-between border-b border-gray-100 px-6 py-5 md:px-8">
              <div>
                <h3 className="text-xl font-semibold text-gray-900">
                  {editingProduct ? 'แก้ไขสินค้า' : 'เพิ่มสินค้าใหม่'}
                </h3>
              </div>
              <button
                onClick={resetForm}
                className="rounded-full p-2 text-gray-400 transition hover:bg-gray-100 hover:text-gray-600"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-6 px-6 py-6 md:px-8 md:py-8">
              <div className="grid grid-cols-1 gap-6 xl:grid-cols-[1.3fr_0.9fr]">
                <div className="space-y-6">
                  <div className={modalCardClassName}>
                    <div className="mb-4">
                      <h4 className="text-sm font-semibold text-gray-900">ข้อมูลหลัก</h4>
                      <p className="text-xs text-gray-500">กำหนดรหัส ชื่อ หมวด ประเภท และหน่วยของสินค้า</p>
                    </div>
                    <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                      <div>
                        <label className="block text-sm font-medium text-gray-700">รหัสสินค้า *</label>
                        <input
                          type="text"
                          name="code"
                          value={formData.code}
                          onChange={handleInputChange}
                          required
                          className={`${modalInputClassName} ${errors.code ? modalErrorInputClassName : ''}`}
                        />
                        {errors.code && <p className="mt-1 text-sm text-red-600">{errors.code}</p>}
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">ชื่อสินค้า *</label>
                        <input
                          type="text"
                          name="name"
                          value={formData.name}
                          onChange={handleInputChange}
                          required
                          className={`${modalInputClassName} ${errors.name ? modalErrorInputClassName : ''}`}
                        />
                        {errors.name && <p className="mt-1 text-sm text-red-600">{errors.name}</p>}
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">หมวดหมู่ *</label>
                        <input
                          list="product-categories"
                          name="category"
                          value={formData.category}
                          onChange={(e) => handleLookupChange('category', e.target.value)}
                          required
                          className={`${modalInputClassName} ${errors.category ? modalErrorInputClassName : ''}`}
                        />
                        <datalist id="product-categories">
                          {categories.map((category) => (
                            <option key={category} value={category} />
                          ))}
                        </datalist>
                        {errors.category && <p className="mt-1 text-sm text-red-600">{errors.category}</p>}
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">ประเภท *</label>
                        <input
                          list="product-types"
                          name="type"
                          value={formData.type}
                          onChange={(e) => handleLookupChange('type', e.target.value)}
                          required
                          className={`${modalInputClassName} ${errors.type ? modalErrorInputClassName : ''}`}
                        />
                        <datalist id="product-types">
                          {filteredTypeOptions.map((type) => (
                            <option key={type} value={type} />
                          ))}
                        </datalist>
                        {errors.type && <p className="mt-1 text-sm text-red-600">{errors.type}</p>}
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">ชนิดย่อย *</label>
                        <input
                          list="product-subtypes"
                          name="subtype"
                          value={formData.subtype}
                          onChange={(e) => handleLookupChange('subtype', e.target.value)}
                          required
                          className={`${modalInputClassName} ${errors.subtype ? modalErrorInputClassName : ''}`}
                        />
                        <datalist id="product-subtypes">
                          {filteredSubtypeOptions.map((subtype) => (
                            <option key={subtype} value={subtype} />
                          ))}
                        </datalist>
                        {errors.subtype && <p className="mt-1 text-sm text-red-600">{errors.subtype}</p>}
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">หน่วย *</label>
                        <input
                          list="product-units"
                          type="text"
                          name="unit"
                          value={formData.unit}
                          onChange={handleInputChange}
                          required
                          className={`${modalInputClassName} ${errors.unit ? modalErrorInputClassName : ''}`}
                        />
                        <datalist id="product-units">
                          {units.map((unit) => (
                            <option key={unit} value={unit} />
                          ))}
                        </datalist>
                        {errors.unit && <p className="mt-1 text-sm text-red-600">{errors.unit}</p>}
                      </div>
                    </div>
                  </div>

                  <div className={modalCardClassName}>
                    <div className="mb-4">
                      <h4 className="text-sm font-semibold text-gray-900">ราคาและคงคลัง</h4>
                      <p className="text-xs text-gray-500">บันทึกราคาทุน ราคาขาย และข้อมูลสต็อกให้ครบถ้วน</p>
                    </div>
                    <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
                      <div>
                        <label className="block text-sm font-medium text-gray-700">ราคาทุน</label>
                        <input
                          type="number"
                          step="0.01"
                          name="cost_price"
                          value={formData.cost_price || ''}
                          onChange={handleInputChange}
                          className={modalInputClassName}
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">ราคาขาย</label>
                        <input
                          type="number"
                          step="0.01"
                          name="sell_price"
                          value={formData.sell_price || ''}
                          onChange={handleInputChange}
                          className={modalInputClassName}
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">จำนวนคงคลัง</label>
                        <input
                          type="number"
                          name="stock_balance"
                          value={formData.stock_balance || ''}
                          onChange={handleInputChange}
                          className={modalInputClassName}
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">มูลค่าสต็อก</label>
                        <input
                          type="number"
                          step="0.01"
                          name="stock_value"
                          value={formData.stock_value || ''}
                          onChange={handleInputChange}
                          className={modalInputClassName}
                        />
                      </div>
                    </div>
                  </div>
                </div>

                <div className="space-y-6">
                  <div className={modalCardClassName}>
                    <div className="mb-4">
                      <h4 className="text-sm font-semibold text-gray-900">ข้อมูลเพิ่มเติม</h4>
                      <p className="text-xs text-gray-500">ข้อมูลผู้ขาย รูปภาพ และหมายเหตุการดูแลสินค้า</p>
                    </div>
                    <div className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700">รหัสผู้ขาย</label>
                        <input
                          list="product-seller-codes"
                          type="text"
                          name="seller_code"
                          value={formData.seller_code}
                          onChange={handleInputChange}
                          className={modalInputClassName}
                        />
                        <datalist id="product-seller-codes">
                          {sellerOptions.length > 0
                            ? sellerOptions.map((seller) => (
                                <option key={seller.code} value={seller.code}>
                                  {seller.name}
                                </option>
                              ))
                            : sellerCodes.map((sellerCode) => (
                                <option key={sellerCode} value={sellerCode} />
                              ))}
                        </datalist>
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">รูปภาพ</label>
                        <input
                          type="text"
                          name="image"
                          value={formData.image}
                          onChange={handleInputChange}
                          placeholder="URL หรือ path ของรูปภาพ"
                          className={modalInputClassName}
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">หมายเหตุ</label>
                        <textarea
                          name="admin_note"
                          value={formData.admin_note}
                          onChange={handleInputChange}
                          rows={8}
                          className={`${modalInputClassName} min-h-[220px] resize-y`}
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div className="flex flex-col-reverse gap-3 border-t border-gray-100 pt-5 sm:flex-row sm:justify-end">
                <button
                  type="button"
                  onClick={resetForm}
                  className="inline-flex items-center justify-center rounded-xl border border-gray-300 px-5 py-3 text-sm font-medium text-gray-700 transition hover:bg-gray-50"
                >
                  ยกเลิก
                </button>
                <button
                  type="submit"
                  className="inline-flex items-center justify-center rounded-xl bg-blue-600 px-5 py-3 text-sm font-medium text-white shadow-sm transition hover:bg-blue-700"
                >
                  {editingProduct ? 'บันทึกการแก้ไข' : 'เพิ่มสินค้า'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Bulk Add Products Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-6xl max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold">เพิ่มสินค้าใหม่ (5 รายการพร้อมแก้ไข)</h2>
              <button
                onClick={() => {
                  setShowBulkForm(false);
                  setBulkRecords([]);
                }}
                className="text-gray-500 hover:text-gray-700"
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                </svg>
              </button>
            </div>

            <div className="mb-4">
              <div className="bg-gray-50 rounded-lg overflow-hidden">
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-gray-100">
                      <tr>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ลำดับ</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">รหัสสินค้า</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ชื่อสินค้า</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">หมวดหมู่</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ประเภท</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ชนิดย่อย</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">หน่วย</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ราคาทุน</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ราคาขาย</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">คงคลัง</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">มูลค่า</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">จัดการ</th>
                      </tr>
                    </thead>
                    <tbody>
                      {bulkRecords.map((record, index) => (
                        <tr key={record.id} className="border-b border-gray-200">
                          <td className="px-2 py-3 text-xs text-gray-900">{index + 1}</td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.code || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].code = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="รหัสสินค้า"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.name || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].name = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ชื่อสินค้า"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.category || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].category = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="หมวดหมู่"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.type || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].type = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ประเภท"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.subtype || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].subtype = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ชนิดย่อย"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.unit || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].unit = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="หน่วย"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="number"
                              step="0.01"
                              value={record.cost_price || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].cost_price = e.target.value ? parseFloat(e.target.value) : undefined;
                                setBulkRecords(updated);
                              }}
                              placeholder="ราคาทุน"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="number"
                              step="0.01"
                              value={record.sell_price || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].sell_price = e.target.value ? parseFloat(e.target.value) : undefined;
                                setBulkRecords(updated);
                              }}
                              placeholder="ราคาขาย"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="number"
                              value={record.stock_balance || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].stock_balance = e.target.value ? parseInt(e.target.value) : undefined;
                                setBulkRecords(updated);
                              }}
                              placeholder="คงคลัง"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="number"
                              step="0.01"
                              value={record.stock_value || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].stock_value = e.target.value ? parseFloat(e.target.value) : undefined;
                                setBulkRecords(updated);
                              }}
                              placeholder="มูลค่า"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <div className="flex gap-1">
                              {bulkRecords.length < 5 && (
                                <button
                                  onClick={() => {
                                    const newRecord = {
                                      id: Math.max(...bulkRecords.map(r => r.id)) + 1,
                                      code: '', name: '', category: '', type: '', subtype: '', unit: '',
                                      cost_price: undefined, sell_price: undefined, stock_balance: undefined,
                                      stock_value: undefined, seller_code: '', image: '', admin_note: ''
                                    };
                                    setBulkRecords([...bulkRecords, newRecord]);
                                  }}
                                  className="text-green-600 hover:text-green-900 p-1"
                                  title="เพิ่มแถวใหม่"
                                >
                                  <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                    <path fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clipRule="evenodd" />
                                  </svg>
                                </button>
                              )}
                              {bulkRecords.length > 1 && (
                                <button
                                  onClick={() => {
                                    setBulkRecords(bulkRecords.filter(r => r.id !== record.id));
                                  }}
                                  className="text-red-600 hover:text-red-900 p-1"
                                  title="ลบแถวนี้"
                                >
                                  <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                    <path fillRule="evenodd" d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" clipRule="evenodd" />
                                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                                  </svg>
                                </button>
                              )}
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            <div className="flex gap-3">
              <button
                onClick={saveBulkProducts}
                className="flex-1 bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700 transition-colors"
              >
                บันทึกทั้งหมด ({bulkRecords.length} รายการ)
              </button>
              <button
                onClick={() => {
                  setShowBulkForm(false);
                  setBulkRecords([]);
                }}
                className="flex-1 bg-gray-500 text-white py-2 rounded-md hover:bg-gray-600 transition-colors"
              >
                ยกเลิก
              </button>
            </div>
          </div>
        </div>
      )}

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        {/* Filter Section */}
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-4 mb-4">
            <div className="lg:col-span-2">
              <input
                type="text"
                value={codeFilter}
                onChange={(e) => {
                  setCodeFilter(e.target.value);
                  setPage(1);
                }}
                placeholder="ค้นหารหัสสินค้า..."
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
              />
            </div>
            <div className="lg:col-span-2">
              <input
                type="text"
                value={nameFilter}
                onChange={(e) => {
                  setNameFilter(e.target.value);
                  setPage(1);
                }}
                placeholder="ค้นหาชื่อสินค้า..."
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
              />
            </div>
            <div className="lg:col-span-2">
              <select
                value={categoryFilter}
                onChange={(e) => {
                  setCategoryFilter(e.target.value);
                  setTypeFilter('');
                  setSubtypeFilter('');
                }}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
              >
                <option value="">หมวด</option>
                {categories.map((cat) => (
                  <option key={cat} value={cat}>{cat}</option>
                ))}
              </select>
            </div>
            <div className="lg:col-span-2">
              <select
                value={typeFilter}
                onChange={(e) => {
                  setTypeFilter(e.target.value);
                  setSubtypeFilter('');
                }}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
              >
                <option value="">ประเภทสินค้า</option>
                {availableFilterTypes.map((type) => (
                  <option key={type} value={type}>{type}</option>
                ))}
              </select>
            </div>
            <div className="lg:col-span-2">
              <select
                value={subtypeFilter}
                onChange={(e) => setSubtypeFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
              >
                <option value="">ประเภทย่อย</option>
                {availableFilterSubtypes.map((subtype) => (
                  <option key={subtype} value={subtype}>{subtype}</option>
                ))}
              </select>
            </div>
            <div className="lg:col-span-2 flex items-end">
              <button
                onClick={() => {
                  setCodeFilter('');
                  setNameFilter('');
                  setCategoryFilter('');
                  setTypeFilter('');
                  setSubtypeFilter('');
                  setPage(1);
                  setSortBy('code');
                  setSortOrder('asc');
                }}
                className="w-full px-3 py-2 text-sm border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
              >
                ล้าง
              </button>
            </div>
          </div>
        </div>
        
        {/* Summary Section */}
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex justify-between items-center">
            <h3 className="text-lg font-medium text-gray-900">สรุปข้อมูล</h3>
            <div className="flex items-center space-x-6">
              <div className="text-sm">
                <span className="text-gray-500">จำนวนทั้งสิ้น: </span>
                <span className="font-semibold text-gray-900">{(products || []).length.toLocaleString()} รายการ</span>
              </div>
              <div className="text-sm">
                <span className="text-gray-500">มูลค่ายกมาทั้งหมด: </span>
                <span className="font-semibold text-gray-900">
                  ฿{(products || []).reduce((total, product) => total + (product.stock_value ? Number(product.stock_value) : 0), 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Pagination Controls (survey-style) */}
      <div className="mt-4 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="text-sm text-gray-600">
          แสดง {pageStart}-{pageEnd} จาก {totalCount} รายการ
        </div>
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="flex items-center gap-2">
            <span className="text-sm text-gray-600">แสดงต่อหน้า</span>
            <select
              value={pageSize}
              onChange={handlePageSizeChange}
              className="rounded border border-gray-300 px-2 py-1 text-sm"
            >
              {PAGE_SIZE_OPTIONS.map((size) => (
                <option key={size} value={size}>{size}</option>
              ))}
            </select>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => goToPage(page - 1)}
              disabled={page === 1}
              className={`px-3 py-1 rounded border text-sm ${page === 1 ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-100'}`}
            >
              ก่อนหน้า
            </button>
            <span className="text-sm text-gray-700">
              หน้า {page} / {totalPages}
            </span>
            <button
              onClick={() => goToPage(page + 1)}
              disabled={page >= totalPages}
              className={`px-3 py-1 rounded border text-sm ${page >= totalPages ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-100'}`}
            >
              ถัดไป
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th onClick={() => handleSort('code')} className={getHeaderClass('code')}>
                รหัสสินค้า {getSortIcon('code')}
              </th>
              <th onClick={() => handleSort('name')} className={getHeaderClass('name')}>
                ชื่อสินค้า {getSortIcon('name')}
              </th>
              <th onClick={() => handleSort('category')} className={getHeaderClass('category')}>
                หมวด {getSortIcon('category')}
              </th>
              <th onClick={() => handleSort('type')} className={getHeaderClass('type')}>
                ประเภท {getSortIcon('type')}
              </th>
              <th onClick={() => handleSort('subtype')} className={getHeaderClass('subtype')}>
                ประเภทย่อย {getSortIcon('subtype')}
              </th>
              <th onClick={() => handleSort('unit')} className={getHeaderClass('unit')}>
                หน่วยนับ {getSortIcon('unit')}
              </th>
              <th onClick={() => handleSort('cost_price')} className={getHeaderClass('cost_price')}>
                ราคาทุนต่อหน่วย {getSortIcon('cost_price')}
              </th>
              <th onClick={() => handleSort('sell_price')} className={getHeaderClass('sell_price')}>
                ราคาขายต่อหน่วย {getSortIcon('sell_price')}
              </th>
              <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-20">
                สถานะ
              </th>
              <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-24">
                Action
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {(products || []).map((product) => (
              <tr key={product.id}>
                <td className="px-3 py-4 whitespace-nowrap text-xs font-medium text-gray-900 w-24">
                  {product.code}
                </td>
                <td className="px-3 py-4 text-xs text-gray-900 max-w-xs break-words">{product.name}</td>
                <td className="px-3 py-4 whitespace-nowrap text-xs text-gray-900">{product.category}</td>
                <td className="px-3 py-4 whitespace-nowrap text-xs text-gray-500 w-28">
                  {product.type || '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-xs text-gray-500 w-28">
                  {product.subtype || '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-xs text-gray-500 w-20">
                  {product.unit || '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-xs text-gray-500 w-24">
                  {product.cost_price ? `฿${Number(product.cost_price).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-xs text-gray-500 w-24">
                  {product.sell_price ? `฿${Number(product.sell_price).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap w-20">
                  <span className={`px-2 inline-flex text-[10px] leading-4 font-semibold rounded-full ${
                    product.flag_activate ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                  }`}>
                    {product.flag_activate ? (
                      <Check className="h-4 w-4" />
                    ) : (
                      <X className="h-4 w-4" />
                    )}
                  </span>
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-xs font-medium w-24">
                  <button
                    onClick={() => handleEdit(product)}
                    className="text-indigo-600 hover:text-indigo-900 mr-2 cursor-pointer"
                    title="แก้ไข"
                  >
                    <Pencil className="h-5 w-5" />
                  </button>
                  <button
                    onClick={() => handleDelete(product.id)}
                    className="text-red-600 hover:text-red-900 cursor-pointer"
                    title="ลบ"
                  >
                    <Trash2 className="h-5 w-5" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {(products || []).length === 0 && (
        <div className="text-center py-8">
          <p className="text-gray-500 text-lg">ไม่มีข้อมูลสินค้า</p>
          <button
            onClick={() => setShowForm(true)}
            className="mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            เพิ่มสินค้าใหม่
          </button>
        </div>
      )}
    </div>
  );
}
