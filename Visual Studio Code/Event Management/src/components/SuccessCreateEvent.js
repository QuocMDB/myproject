import React, { useState, useEffect } from 'react';
import { RotateCcw, Plus } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const SuccessCreateEvent = () => {
  const [showCircle, setShowCircle] = useState(false);
  const [showCheckmark, setShowCheckmark] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    // Hiển thị vòng tròn trước
    setTimeout(() => setShowCircle(true), 300);
    // Sau đó hiển thị dấu tích
    setTimeout(() => setShowCheckmark(true), 800);
  }, []);

  const handleGoBack = () => {
    navigate('/eventlist');
  };

  const handleContinue = () => {
    navigate('/create');
  };

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl p-8 max-w-sm w-full text-center shadow-2xl">
        {/* Custom Animated Check Circle */}
        <div className="relative mb-6 flex justify-center">
          <div className="relative w-20 h-20">
            {/* Animated Circle */}
            <svg className="w-20 h-20 transform -rotate-90" viewBox="0 0 80 80">
              <circle
                cx="40"
                cy="40"
                r="36"
                fill="none"
                stroke="#e5e7eb"
                strokeWidth="4"
              />
              <circle
                cx="40"
                cy="40"
                r="36"
                fill="none"
                stroke="#10b981"
                strokeWidth="4"
                strokeLinecap="round"
                strokeDasharray="226"
                strokeDashoffset={showCircle ? '0' : '226'}
                className="transition-all duration-1000 ease-out"
              />
            </svg>

            {/* Animated Checkmark */}
            <svg className="absolute inset-0 w-20 h-20" viewBox="0 0 80 80">
              <path
                d="M25 42 L35 52 L55 32"
                fill="none"
                stroke="#10b981"
                strokeWidth="4"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeDasharray="40"
                strokeDashoffset={showCheckmark ? '0' : '40'}
                className="transition-all duration-700 ease-out delay-200"
              />
            </svg>

            {/* Pulse Effect */}
            <div
              className={`absolute inset-0 w-20 h-20 rounded-full border-4 border-green-300 transition-opacity duration-500 ${
                showCheckmark ? 'animate-ping opacity-75' : 'opacity-0'
              }`}
            />
          </div>
        </div>

        {/* Text with fade in animation */}
        <div
          className={`transition-all duration-500 delay-700 ${
            showCheckmark
              ? 'opacity-100 translate-y-0'
              : 'opacity-0 translate-y-4'
          }`}
        >
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Thành Công!</h2>
          <p className="text-gray-600 mb-8">Bạn đã thêm mới sự kiện</p>
        </div>

        {/* Action Buttons with slide up animation */}
        <div
          className={`flex space-x-3 transition-all duration-500 delay-1000 ${
            showCheckmark
              ? 'opacity-100 translate-y-0'
              : 'opacity-0 translate-y-4'
          }`}
        >
          <button
            onClick={handleGoBack}
            className="flex-1 flex items-center justify-center space-x-2 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors hover:scale-105 active:scale-95"
          >
            <RotateCcw size={16} />
            <span>Quay về</span>
          </button>

          <button
            onClick={handleContinue}
            className="flex-1 flex items-center justify-center space-x-2 px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors hover:scale-105 active:scale-95"
          >
            <Plus size={16} />
            <span>Tiếp tục</span>
          </button>
        </div>
      </div>

      {/* Background particles effect (optional) */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden">
        {[...Array(6)].map((_, i) => (
          <div
            key={i}
            className={`absolute w-2 h-2 bg-green-400 rounded-full transition-all duration-1000 delay-${
              i * 200
            } ${showCheckmark ? 'opacity-100' : 'opacity-0'}`}
            style={{
              left: `${20 + i * 15}%`,
              top: `${30 + (i % 2) * 40}%`,
              animation: showCheckmark
                ? `float ${2 + i * 0.5}s ease-in-out infinite`
                : 'none',
            }}
          />
        ))}
      </div>

      <style jsx>{`
        @keyframes float {
          0%,
          100% {
            transform: translateY(0px) rotate(0deg);
          }
          50% {
            transform: translateY(-10px) rotate(180deg);
          }
        }
      `}</style>
    </div>
  );
};

export default SuccessCreateEvent;
