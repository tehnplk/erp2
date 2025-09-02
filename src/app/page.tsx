import Link from 'next/link';

export default function Home() {
  const modules = [
    {
      title: 'หมวดหมู่สินค้า',
      description: 'จัดการหมวดหมู่และประเภทสินค้า',
      href: '/categories',
      icon: '💊',
      color: 'bg-blue-500'
    },
    {
      title: 'แผนก',
      description: 'จัดการข้อมูลแผนกต่างๆ ในโรงพยาบาล',
      href: '/departments',
      icon: '🏥',
      color: 'bg-green-500'
    },
    {
      title: 'เวชภัณฑ์',
      description: 'จัดการข้อมูลเวชภัณฑ์และอุปกรณ์การแพทย์',
      href: '/products',
      icon: '🩺',
      color: 'bg-purple-500'
    },
    {
      title: 'ผู้จำหน่าย',
      description: 'จัดการข้อมูลผู้จำหน่ายเวชภัณฑ์',
      href: '/sellers',
      icon: '🏪',
      color: 'bg-orange-500'
    },
    {
      title: 'แบบสำรวจ',
      description: 'จัดการแบบสำรวจและการประเมินคุณภาพ',
      href: '/surveys',
      icon: '📋',
      color: 'bg-teal-500'
    },
    {
      title: 'แผนจัดซื้อ',
      description: 'จัดการแผนการจัดซื้อเวชภัณฑ์และงบประมาณ',
      href: '/purchase-plans',
      icon: '📊',
      color: 'bg-indigo-500'
    },
    {
      title: 'อนุมัติจัดซื้อ',
      description: 'จัดการการอนุมัติและขออนุมัติจัดซื้อเวชภัณฑ์',
      href: '/purchase-approvals',
      icon: '✅',
      color: 'bg-emerald-500'
    },
    {
      title: 'คลังเวชภัณฑ์',
      description: 'จัดการสต็อกและการเคลื่อนไหวเวชภัณฑ์',
      href: '/warehouse',
      icon: '🏥',
      color: 'bg-red-500'
    },
    {
      title: 'AI Assistant',
      description: 'ผู้ช่วย AI สำหรับการวิเคราะห์และแนะนำ',
      href: '/ai',
      icon: '🤖',
      color: 'bg-gradient-to-r from-purple-500 to-pink-500'
    }
  ];

  return (
    <div className="min-h-screen">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent mb-4">
            Hospital Resource Planning System
          </h1>
        </div>

        {/* Module Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {modules.map((module) => (
          <Link
            key={module.href}
            href={module.href}
            className="group block"
          >
            <div className="bg-white/80 backdrop-blur-sm rounded-lg shadow-md hover:shadow-xl transition-all duration-300 p-6 h-full border border-white/20">
              <div className="flex items-center mb-4">
                <div className={`${module.color} rounded-lg p-3 mr-4`}>
                  <span className="text-2xl">{module.icon}</span>
                </div>
                <h3 className="text-lg font-semibold text-gray-800 group-hover:text-blue-600 transition-colors">
                  {module.title}
                </h3>
              </div>
              <p className="text-gray-600 text-sm">
                {module.description}
              </p>
            </div>
          </Link>
        ))}
        </div>

       
      </div>
    </div>
  );
}
