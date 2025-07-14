import React, { useEffect, useState } from 'react';
import {
  Calendar,
  Users,
  Hourglass,
  CheckCircle2,
  XCircle,
  Timer,
} from 'lucide-react';

const EventOverview = () => {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('http://localhost:9999/events')
      .then(res => res.json())
      .then(data => {
        setEvents(data);
        setLoading(false);
      })
      .catch(error => {
        console.error('❌ Error fetching events:', error);
        setLoading(false);
      });
  }, []);

  // Tính toán thống kê
  const calculateStats = () => {
    if (!events || events.length === 0) {
      return {
        totalEvents: 0,
        totalGuests: 0,
        totalBudget: 0,
        preparing: 0,
        upcoming: 0,
        completed: 0,
        cancelled: 0,
      };
    }

    const stats = events.reduce(
      (acc, event) => {
        acc.totalEvents += 1;
        acc.totalGuests += event.estimatedAttendees || 0;
        acc.totalBudget += event.budget || 0;

        // Đếm theo status
        const status = event.status?.toLowerCase();
        if (status === 'preparing') acc.preparing += 1;
        else if (status === 'upcoming') acc.upcoming += 1;
        else if (status === 'completed') acc.completed += 1;
        else if (status === 'cancelled') acc.cancelled += 1;

        return acc;
      },
      {
        totalEvents: 0,
        totalGuests: 0,
        totalBudget: 0,
        preparing: 0,
        upcoming: 0,
        completed: 0,
        cancelled: 0,
      }
    );

    return stats;
  };

  const formatCurrency = amount => {
    if (!amount) return '0';

    // Chuyển đổi thành tỷ nếu >= 1 tỷ
    if (amount >= 1000000000) {
      const billions = (amount / 1000000000).toFixed(1);
      return `${billions}B`;
    }

    // Chuyển đổi thành triệu nếu >= 1 triệu
    if (amount >= 1000000) {
      const millions = (amount / 1000000).toFixed(1);
      return `${millions}M`;
    }

    // Định dạng số thường
    return new Intl.NumberFormat('vi-VN').format(amount);
  };

  const formatNumber = number => {
    if (!number) return '0';
    return new Intl.NumberFormat('vi-VN').format(number);
  };

  const stats = calculateStats();

  // Định nghĩa các thẻ thống kê
  const statCards = [
    {
      title: 'Tổng sự kiện',
      value: formatNumber(stats.totalEvents),
      icon: Calendar,
      bgColor: 'bg-blue-50',
      iconColor: 'text-blue-600',
    },
    {
      title: 'Tổng khách mời',
      value: formatNumber(stats.totalGuests),
      icon: Users,
      bgColor: 'bg-green-50',
      iconColor: 'text-green-600',
    },

    {
      title: 'Đang chuẩn bị',
      value: formatNumber(stats.preparing),
      icon: Hourglass,
      bgColor: 'bg-orange-50',
      iconColor: 'text-orange-600',
    },
    {
      title: 'Sắp diễn ra',
      value: formatCurrency(stats.upcoming),
      icon: Timer,
      bgColor: 'bg-purple-50',
      iconColor: 'text-purple-600',
    },
    {
      title: 'Đã hoàn thành',
      value: formatNumber(stats.completed),
      icon: CheckCircle2,
      bgColor: 'bg-emerald-50',
      iconColor: 'text-emerald-600',
    },
    {
      title: 'Đã hủy',
      value: formatNumber(stats.cancelled),
      icon: XCircle,
      bgColor: 'bg-red-50',
      iconColor: 'text-red-600',
    },
  ];

  if (loading) {
    return (
      <div>
        <div className="mb-4">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            Tổng quan sự kiện
          </h2>
          <p className="text-gray-600">Thống kê tổng quan về các sự kiện</p>
        </div>

        {/* 2 hàng x 3 cột */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {[1, 2, 3, 4, 5, 6].map(i => (
            <div
              key={i}
              className="bg-white rounded-lg p-4 shadow-sm border border-gray-100 animate-pulse"
            >
              <div className="flex items-center justify-between">
                <div className="flex flex-col space-y-1">
                  <div className="h-3 bg-gray-200 rounded w-20"></div>
                  <div className="h-6 bg-gray-200 rounded w-12"></div>
                </div>
                <div className="w-12 h-12 bg-gray-200 rounded-lg"></div>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div>
      {/* Header */}
      <div className="mb-4 mt-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Tổng quan sự kiện
        </h2>
        <p className="text-gray-600">Thống kê tổng quan về các sự kiện</p>
      </div>

      {/* Stats Grid - 2 hàng x 3 cột - Compact Style */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {statCards.map((card, index) => {
          const IconComponent = card.icon;
          return (
            <div
              key={index}
              className="bg-white rounded-lg p-4 shadow-sm border border-gray-100 hover:shadow-md transition-all duration-200 hover:-translate-y-1"
            >
              <div className="flex items-center justify-between">
                {/* Left side: Title + Value */}
                <div className="flex flex-col">
                  <span className="text-sm font-medium text-gray-600 mb-1">
                    {card.title}
                  </span>
                  <div className="text-xl font-bold text-gray-900">
                    {card.value}
                  </div>
                </div>

                {/* Right side: Icon - Size to match 2 lines */}
                <div
                  className={`w-12 h-12 ${card.bgColor} rounded-lg flex items-center justify-center flex-shrink-0`}
                >
                  <IconComponent className={`h-6 w-6 ${card.iconColor}`} />
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default EventOverview;
