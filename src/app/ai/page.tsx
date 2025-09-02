'use client';

import { useState, useEffect, useRef } from 'react';

interface Message {
  id: number;
  text: string;
  isUser: boolean;
  timestamp: string;
  isChart?: boolean;
}

export default function AIPage() {
  const messagesEndRef = useRef<HTMLDivElement>(null);
  
  const [messages, setMessages] = useState<Message[]>([
    {
      id: 1,
      text: 'สวัสดีครับ! ผมเป็น AI Assistant สำหรับระบบ Hospital ERP ผมสามารถช่วยคุณในการจัดการข้อมูลต่างๆ ได้ครับ',
      isUser: false,
      timestamp: '10:30'
    },
    {
      id: 2,
      text: 'สวัสดีครับ ช่วยแสดงข้อมูลหมวดหมู่สินค้าทั้งหมดได้ไหม',
      isUser: true,
      timestamp: '10:31'
    },
    {
      id: 3,
      text: 'ได้เลยครับ! ตอนนี้ระบบมีหมวดหมู่สินค้าทั้งหมด 15 หมวดหมู่ ประกอบด้วย:\n\n• เวชภัณฑ์ - 8 รายการ\n• อุปกรณ์การแพทย์ - 5 รายการ\n• เครื่องมือผ่าตัด - 2 รายการ\n\nต้องการดูรายละเอียดเพิ่มเติมหรือไม่ครับ?',
      isUser: false,
      timestamp: '10:31'
    },
    {
      id: 4,
      text: 'ช่วยแนะนำการจัดซื้อเวชภัณฑ์สำหรับเดือนหน้าหน่อย',
      isUser: true,
      timestamp: '10:33'
    },
    {
      id: 5,
      text: 'จากการวิเคราะห์ข้อมูลการใช้งานและสต็อกปัจจุบัน ผมแนะนำการจัดซื้อดังนี้:\n\n🔴 **ต้องจัดซื้อด่วน:**\n• ยาแก้ปวด - เหลือ 15%\n• เข็มฉีดยา - เหลือ 8%\n\n🟡 **ควรจัดซื้อ:**\n• ผ้าพันแผล - เหลือ 35%\n• แอลกอฮอล์ - เหลือ 28%\n\n💰 **งบประมาณที่แนะนำ:** ฿125,000\n\nต้องการให้สร้างใบสั่งซื้อให้ไหมครับ?',
      isUser: false,
      timestamp: '10:34'
    }
  ]);

  const [inputText, setInputText] = useState('');

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSendMessage = () => {
    if (!inputText.trim()) return;

    const newMessage: Message = {
      id: messages.length + 1,
      text: inputText,
      isUser: true,
      timestamp: new Date().toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit' })
    };

    setMessages([...messages, newMessage]);
    setInputText('');

    // Simulate AI response
    setTimeout(() => {
      let responseText = 'ขอบคุณสำหรับคำถามครับ ผมกำลังประมวลผลข้อมูลให้คุณ... 🤖';
      
      // Check if user asked for chart
      if (inputText.includes('กราฟ') || inputText.includes('chart')) {
        const aiResponse: Message = {
          id: messages.length + 2,
          text: 'นี่คือกราฟแสดงข้อมูลการจัดซื้อเวชภัณฑ์ประจำเดือน:',
          isUser: false,
          timestamp: new Date().toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit' }),
          isChart: true
        };
        setMessages(prev => [...prev, aiResponse]);
        return;
      }
      
      const aiResponse: Message = {
        id: messages.length + 2,
        text: responseText,
        isUser: false,
        timestamp: new Date().toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit' })
      };
      setMessages(prev => [...prev, aiResponse]);
    }, 1000);
  };

  return (
    <div className="container mx-auto px-4 py-8 max-h-screen flex flex-col">

      {/* Chat Container */}
      <div className="flex-1 bg-white/90 backdrop-blur-sm rounded-lg shadow-lg border border-white/20 flex flex-col min-h-0">
        {/* Messages Area */}
        <div className="flex-1 p-6 overflow-y-auto space-y-4 min-h-0">
          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.isUser ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-xs lg:max-w-md px-4 py-3 rounded-lg ${
                  message.isUser
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-100 text-gray-800'
                }`}
              >
                {message.isChart ? (
                  <div>
                    <div className="mb-4">{message.text}</div>
                    <div className="bg-gray-50 p-4 rounded-lg">
                      <h4 className="font-bold mb-3 text-gray-700">📊 กราฟแท่งการจัดซื้อ</h4>
                      <div className="space-y-2">
                        <div className="flex items-center">
                          <span className="w-20 text-xs text-gray-600">ยาแก้ปวด</span>
                          <div className="flex-1 bg-gray-200 rounded-full h-4 mx-2">
                            <div className="bg-red-500 h-4 rounded-full" style={{width: '85%'}}></div>
                          </div>
                          <span className="text-xs text-gray-600">85%</span>
                        </div>
                        <div className="flex items-center">
                          <span className="w-20 text-xs text-gray-600">เข็มฉีดยา</span>
                          <div className="flex-1 bg-gray-200 rounded-full h-4 mx-2">
                            <div className="bg-blue-500 h-4 rounded-full" style={{width: '70%'}}></div>
                          </div>
                          <span className="text-xs text-gray-600">70%</span>
                        </div>
                        <div className="flex items-center">
                          <span className="w-20 text-xs text-gray-600">ผ้าพันแผล</span>
                          <div className="flex-1 bg-gray-200 rounded-full h-4 mx-2">
                            <div className="bg-green-500 h-4 rounded-full" style={{width: '60%'}}></div>
                          </div>
                          <span className="text-xs text-gray-600">60%</span>
                        </div>
                        <div className="flex items-center">
                          <span className="w-20 text-xs text-gray-600">แอลกอฮอล์</span>
                          <div className="flex-1 bg-gray-200 rounded-full h-4 mx-2">
                            <div className="bg-yellow-500 h-4 rounded-full" style={{width: '50%'}}></div>
                          </div>
                          <span className="text-xs text-gray-600">50%</span>
                        </div>
                        <div className="flex items-center">
                          <span className="w-20 text-xs text-gray-600">ถุงมือ</span>
                          <div className="flex-1 bg-gray-200 rounded-full h-4 mx-2">
                            <div className="bg-purple-500 h-4 rounded-full" style={{width: '40%'}}></div>
                          </div>
                          <span className="text-xs text-gray-600">40%</span>
                        </div>
                        <div className="flex items-center">
                          <span className="w-20 text-xs text-gray-600">หน้ากาก</span>
                          <div className="flex-1 bg-gray-200 rounded-full h-4 mx-2">
                            <div className="bg-orange-500 h-4 rounded-full" style={{width: '30%'}}></div>
                          </div>
                          <span className="text-xs text-gray-600">30%</span>
                        </div>
                      </div>
                      <div className="mt-4 pt-3 border-t border-gray-200 text-xs text-gray-600">
                        <div className="grid grid-cols-2 gap-2">
                          <div>💰 งบประมาณ: ฿125,000</div>
                          <div>📈 เพิ่มขึ้น: 15%</div>
                        </div>
                        <div className="mt-2">🎯 แนะนำ: ควรเพิ่มสต็อกยาแก้ปวดและเข็มฉีดยา</div>
                      </div>
                    </div>
                  </div>
                ) : (
                  <div className="whitespace-pre-wrap">{message.text}</div>
                )}
                <div
                  className={`text-xs mt-2 ${
                    message.isUser ? 'text-blue-100' : 'text-gray-500'
                  }`}
                >
                  {message.timestamp}
                </div>
              </div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>

        {/* Input Area */}
        <div className="border-t border-gray-200 p-4">
          <div className="flex space-x-4">
            <input
              type="text"
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
              placeholder="พิมพ์ข้อความของคุณ..."
              className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <button
              onClick={handleSendMessage}
              disabled={!inputText.trim()}
              className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              ส่ง 📤
            </button>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="mt-4 grid grid-cols-2 md:grid-cols-5 gap-3 flex-shrink-0">
        <button
          onClick={() => setInputText('แสดงข้อมูลสต็อกที่เหลือน้อย')}
          className="bg-white/80 backdrop-blur-sm border border-white/20 rounded-lg p-3 text-sm hover:bg-white/90 transition-colors"
        >
          📊 สต็อกเหลือน้อย
        </button>
        <button
          onClick={() => setInputText('สรุปการจัดซื้อเดือนนี้')}
          className="bg-white/80 backdrop-blur-sm border border-white/20 rounded-lg p-3 text-sm hover:bg-white/90 transition-colors"
        >
          💰 สรุปจัดซื้อ
        </button>
        <button
          onClick={() => setInputText('แนะนำการจัดซื้อเดือนหน้า')}
          className="bg-white/80 backdrop-blur-sm border border-white/20 rounded-lg p-3 text-sm hover:bg-white/90 transition-colors"
        >
          🎯 แนะนำจัดซื้อ
        </button>
        <button
          onClick={() => setInputText('รายงานการใช้งานระบบ')}
          className="bg-white/80 backdrop-blur-sm border border-white/20 rounded-lg p-3 text-sm hover:bg-white/90 transition-colors"
        >
          📈 รายงานระบบ
        </button>
        <button
          onClick={() => setInputText('สร้างกราฟแสดงข้อมูลการจัดซื้อ')}
          className="bg-white/80 backdrop-blur-sm border border-white/20 rounded-lg p-3 text-sm hover:bg-white/90 transition-colors"
        >
          📊 สร้างกราฟ
        </button>
      </div>
    </div>
  );
}
