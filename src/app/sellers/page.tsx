'use client';

import { useState, useEffect } from 'react';

interface Seller {
  id: number;
  code: string;
  prefix?: string;
  name: string;
  business?: string;
  address?: string;
  phone?: string;
  fax?: string;
  mobile?: string;
}

export default function SellersPage() {
  const [sellers, setSellers] = useState<Seller[]>([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingSeller, setEditingSeller] = useState<Seller | null>(null);
  const [formData, setFormData] = useState({
    code: '',
    prefix: '',
    name: '',
    business: '',
    address: '',
    phone: '',
    fax: '',
    mobile: ''
  });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editData, setEditData] = useState({
    code: '',
    prefix: '',
    name: '',
    business: '',
    address: '',
    phone: '',
    fax: '',
    mobile: ''
  });
  const [showBulkForm, setShowBulkForm] = useState(false);
  const [bulkRecords, setBulkRecords] = useState<any[]>([]);
  const [toast, setToast] = useState<{
    message: string;
    type: 'success' | 'error';
    visible: boolean;
  }>({
    message: '',
    type: 'success',
    visible: false
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  useEffect(() => {
    fetchSellers();
  }, []);

  const fetchSellers = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/sellers');
      const result = await response.json();
      
      if (result.success) {
        setSellers(result.data);
        setError(null);
      } else {
        setError(result.error || 'Failed to fetch sellers');
      }
    } catch (err) {
      setError('Failed to connect to server');
      console.error('Error fetching sellers:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    try {
      if (editingSeller) {
        // Update existing seller
        const response = await fetch(`/api/sellers/${editingSeller.id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(formData),
        });
        
        const result = await response.json();
        
        if (result.success) {
          await fetchSellers(); // Refresh the list
        } else {
          alert(result.error || 'Failed to update seller');
          return;
        }
      } else {
        // Add new seller
        const response = await fetch('/api/sellers', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(formData),
        });
        
        const result = await response.json();
        
        if (result.success) {
          await fetchSellers(); // Refresh the list
        } else {
          alert(result.error || 'Failed to create seller');
          return;
        }
      }
      
      resetForm();
    } catch (err) {
      console.error('Error saving seller:', err);
      alert('Failed to save seller');
    }
  };

  const handleEdit = (seller: Seller) => {
    setEditingSeller(seller);
    setFormData({
      code: seller.code,
      prefix: seller.prefix || '',
      name: seller.name,
      business: seller.business || '',
      address: seller.address || '',
      phone: seller.phone || '',
      fax: seller.fax || '',
      mobile: seller.mobile || ''
    });
    setIsModalOpen(true);
  };

  const handleDelete = async (id: number) => {
    if (confirm('คุณต้องการลบผู้จำหน่ายนี้หรือไม่?')) {
      try {
        const response = await fetch(`/api/sellers/${id}`, {
          method: 'DELETE',
        });
        
        const result = await response.json();
        
        if (result.success) {
          await fetchSellers(); // Refresh the list
        } else {
          alert(result.error || 'Failed to delete seller');
        }
      } catch (err) {
        console.error('Error deleting seller:', err);
        alert('Failed to delete seller');
      }
    }
  };

  const resetForm = () => {
    setFormData({
      code: '',
      prefix: '',
      name: '',
      business: '',
      address: '',
      phone: '',
      fax: '',
      mobile: ''
    });
    setEditingSeller(null);
    setIsModalOpen(false);
  };

  // Start inline editing
  const startInlineEdit = (seller: Seller) => {
    setEditingId(seller.id);
    setEditData({
      code: seller.code,
      prefix: seller.prefix || '',
      name: seller.name,
      business: seller.business || '',
      address: seller.address || '',
      phone: seller.phone || '',
      fax: seller.fax || '',
      mobile: seller.mobile || ''
    });
  };

  // Save inline edit
  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/sellers/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editData)
      });

      if (response.ok) {
        setEditingId(null);
        setEditData({
          code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: ''
        });
        fetchSellers();

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
      console.error('Error updating seller:', error);

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

  // Cancel inline edit
  const cancelInlineEdit = () => {
    setEditingId(null);
    setEditData({
      code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: ''
    });
  };

  // Save bulk sellers
  const saveBulkSellers = async () => {
    try {
      const validRecords = bulkRecords.filter(record =>
        record.code.trim() !== '' && record.name.trim() !== ''
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

      const promises = validRecords.map(record =>
        fetch('/api/sellers', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            code: record.code.trim(),
            prefix: record.prefix || '',
            name: record.name.trim(),
            business: record.business || '',
            address: record.address || '',
            phone: record.phone || '',
            fax: record.fax || '',
            mobile: record.mobile || ''
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        fetchSellers();

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
      console.error('Error saving bulk sellers:', error);

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
  return (
    <div className="min-h-screen pt-[52px]">
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

        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-800">🏪 จัดการผู้จำหน่าย</h1>
            <p className="text-gray-600 mt-2">จัดการข้อมูลผู้จำหน่ายเวชภัณฑ์และอุปกรณ์การแพทย์</p>
          </div>
        </div>

        {/* Results Counter */}
        <div className="mt-4 text-sm text-gray-600">
          แสดง {sellers.length} จาก {sellers.length} รายการ
        </div>

        {/* Add New Record Button */}
        <div className="flex justify-end mb-4">
          <button
            onClick={() => {
              setShowBulkForm(true);
              setBulkRecords([
                { id: 1, code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: '' },
                { id: 2, code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: '' },
                { id: 3, code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: '' },
                { id: 4, code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: '' },
                { id: 5, code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: '' }
              ]);
            }}
            className="bg-blue-600 text-white p-3 rounded-full hover:bg-blue-700 transition-colors shadow-lg"
            title="เพิ่มผู้จำหน่ายใหม่"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
              <path fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clipRule="evenodd" />
            </svg>
          </button>
        </div>

        <div className="bg-white/80 backdrop-blur-sm rounded-lg shadow-md border border-white/20 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">รหัส</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ชื่อผู้จำหน่าย</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ประเภทธุรกิจ</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">เบอร์โทร</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">มือถือ</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ACTION</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {sellers.map((seller) => (
                  <tr key={seller.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {seller.code}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div>
                        <div className="text-sm font-medium text-gray-900">
                          {editingId === seller.id ? (
                            <input
                              type="text"
                              value={editData.name}
                              onChange={(e) => setEditData({ ...editData, name: e.target.value })}
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                          ) : (
                            `${seller.prefix || ''} ${seller.name}`.trim()
                          )}
                        </div>
                        <div className="text-sm text-gray-500">
                          {editingId === seller.id ? (
                            <textarea
                              value={editData.address || ''}
                              onChange={(e) => setEditData({ ...editData, address: e.target.value })}
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm resize-none"
                              rows={2}
                            />
                          ) : (
                            seller.address
                          )}
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {editingId === seller.id ? (
                        <input
                          type="text"
                          value={editData.business || ''}
                          onChange={(e) => setEditData({ ...editData, business: e.target.value })}
                          className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      ) : (
                        seller.business
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {editingId === seller.id ? (
                        <input
                          type="tel"
                          value={editData.phone || ''}
                          onChange={(e) => setEditData({ ...editData, phone: e.target.value })}
                          className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      ) : (
                        seller.phone
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {editingId === seller.id ? (
                        <input
                          type="tel"
                          value={editData.mobile || ''}
                          onChange={(e) => setEditData({ ...editData, mobile: e.target.value })}
                          className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      ) : (
                        seller.mobile
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium w-32">
                      {editingId === seller.id ? (
                        <div className="flex gap-1">
                          <button
                            onClick={() => saveInlineEdit(seller.id)}
                            className="text-green-600 hover:text-green-900 cursor-pointer"
                            title="บันทึก"
                          >
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                              <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                            </svg>
                          </button>
                          <button
                            onClick={() => cancelInlineEdit()}
                            className="text-red-600 hover:text-red-900 cursor-pointer"
                            title="ยกเลิก"
                          >
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                              <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                            </svg>
                          </button>
                        </div>
                      ) : (
                        <div className="flex gap-2">
                          <button
                            onClick={() => startInlineEdit(seller)}
                            className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                            title="แก้ไข"
                          >
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                              <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                            </svg>
                          </button>
                          <button
                            onClick={() => handleDelete(seller.id)}
                            className="text-red-600 hover:text-red-900 cursor-pointer"
                            title="ลบ"
                          >
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                              <path fillRule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clipRule="evenodd" />
                            </svg>
                          </button>
                        </div>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Stats */}
        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white/80 backdrop-blur-sm rounded-lg shadow-md p-6 border border-white/20">
            <div className="flex items-center">
              <div className="bg-blue-500 rounded-lg p-3 mr-4">
                <span className="text-2xl text-white">🏪</span>
              </div>
              <div>
                <h3 className="text-lg font-semibold text-gray-800">ผู้จำหน่ายทั้งหมด</h3>
                <p className="text-3xl font-bold text-blue-600">{sellers.length}</p>
              </div>
            </div>
          </div>
          <div className="bg-white/80 backdrop-blur-sm rounded-lg shadow-md p-6 border border-white/20">
            <div className="flex items-center">
              <div className="bg-green-500 rounded-lg p-3 mr-4">
                <span className="text-2xl text-white">✅</span>
              </div>
              <div>
                <h3 className="text-lg font-semibold text-gray-800">ผู้จำหน่ายใช้งาน</h3>
                <p className="text-3xl font-bold text-green-600">{sellers.length}</p>
              </div>
            </div>
          </div>
          <div className="bg-white/80 backdrop-blur-sm rounded-lg shadow-md p-6 border border-white/20">
            <div className="flex items-center">
              <div className="bg-purple-500 rounded-lg p-3 mr-4">
                <span className="text-2xl text-white">📞</span>
              </div>
              <div>
                <h3 className="text-lg font-semibold text-gray-800">มีข้อมูลติดต่อ</h3>
                <p className="text-3xl font-bold text-purple-600">{sellers.filter(s => s.phone || s.mobile).length}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-xl font-bold text-gray-800">
                {editingSeller ? '✏️ แก้ไขผู้จำหน่าย' : '➕ เพิ่มผู้จำหน่าย'}
              </h2>
              <button
                onClick={resetForm}
                className="text-gray-400 hover:text-gray-600"
              >
                ✖️
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    รหัสผู้จำหน่าย *
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.code}
                    onChange={(e) => setFormData({...formData, code: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="เช่น S001"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    คำนำหน้า
                  </label>
                  <input
                    type="text"
                    value={formData.prefix}
                    onChange={(e) => setFormData({...formData, prefix: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="เช่น บริษัท, ห้างหุ้นส่วน"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  ชื่อผู้จำหน่าย *
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({...formData, name: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="ชื่อบริษัทหรือร้านค้า"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  ประเภทธุรกิจ
                </label>
                <input
                  type="text"
                  value={formData.business}
                  onChange={(e) => setFormData({...formData, business: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="เช่น จำหน่ายเวชภัณฑ์"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  ที่อยู่
                </label>
                <textarea
                  value={formData.address}
                  onChange={(e) => setFormData({...formData, address: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  rows={3}
                  placeholder="ที่อยู่ผู้จำหน่าย"
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    เบอร์โทรศัพท์
                  </label>
                  <input
                    type="tel"
                    value={formData.phone}
                    onChange={(e) => setFormData({...formData, phone: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="02-xxx-xxxx"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    แฟกซ์
                  </label>
                  <input
                    type="tel"
                    value={formData.fax}
                    onChange={(e) => setFormData({...formData, fax: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="02-xxx-xxxx"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    มือถือ
                  </label>
                  <input
                    type="tel"
                    value={formData.mobile}
                    onChange={(e) => setFormData({...formData, mobile: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="08x-xxx-xxxx"
                  />
                </div>
              </div>

              <div className="flex justify-end space-x-3 pt-6">
                <button
                  type="button"
                  onClick={resetForm}
                  className="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors"
                >
                  ยกเลิก
                </button>
                <button
                  type="submit"
                  className="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
                >
                  {editingSeller ? 'บันทึกการแก้ไข' : 'เพิ่มผู้จำหน่าย'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Bulk Add Sellers Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-6xl max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold">เพิ่มผู้จำหน่ายใหม่ (5 รายการพร้อมแก้ไข)</h2>
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
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ลำดับ</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">รหัส</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">คำนำหน้า</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ชื่อผู้จำหน่าย</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ประเภทธุรกิจ</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ที่อยู่</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">เบอร์โทร</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">มือถือ</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จัดการ</th>
                      </tr>
                    </thead>
                    <tbody>
                      {bulkRecords.map((record, index) => (
                        <tr key={record.id} className="border-b border-gray-200">
                          <td className="px-2 py-3 text-sm text-gray-900">{index + 1}</td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.code || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].code = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="รหัส"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.prefix || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].prefix = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="คำนำหน้า"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
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
                              placeholder="ชื่อผู้จำหน่าย"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.business || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].business = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ประเภทธุรกิจ"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <textarea
                              value={record.address || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].address = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ที่อยู่"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm resize-none"
                              rows={2}
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="tel"
                              value={record.phone || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].phone = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="เบอร์โทร"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="tel"
                              value={record.mobile || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].mobile = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="มือถือ"
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
                                      code: '', prefix: '', name: '', business: '', address: '', phone: '', fax: '', mobile: ''
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
                onClick={saveBulkSellers}
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

    </div>
  );
}
