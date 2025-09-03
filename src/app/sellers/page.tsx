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
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Fetch sellers from API
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

  return (
    <div className="min-h-screen pt-[52px]">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-800">🏪 จัดการผู้จำหน่าย</h1>
            <p className="text-gray-600 mt-2">จัดการข้อมูลผู้จำหน่ายเวชภัณฑ์และอุปกรณ์การแพทย์</p>
          </div>
          <button
            onClick={() => setIsModalOpen(true)}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2"
          >
            <span>➕</span>
            <span>เพิ่มผู้จำหน่าย</span>
          </button>
        </div>

        {/* Sellers Table */}
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
                          {seller.prefix} {seller.name}
                        </div>
                        <div className="text-sm text-gray-500">{seller.address}</div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {seller.business}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {seller.phone}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {seller.mobile}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium w-24">
                      <button
                        onClick={() => handleEdit(seller)}
                        className="text-indigo-600 hover:text-indigo-900 mr-2 cursor-pointer"
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
    </div>
  );
}
