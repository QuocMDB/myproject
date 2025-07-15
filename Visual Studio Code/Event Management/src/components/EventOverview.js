import React, { useEffect, useState } from 'react';
import {
  Calendar,
  Users,
  DollarSign,
  TrendingUp,
  Activity,
  Star,
} from 'lucide-react';

// ✅ THÊM currentUser prop
const EventOverview = ({ currentUser }) => {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);

  // ✅ SỬA useEffect ĐỂ FETCH TỪ ACCOUNT
  useEffect(() => {
    const fetchEvents = async () => {
      // ✅ CHỈ LOAD KHI CÓ CURRENT USER
      if (!currentUser?.id) {
        console.log('⏳ [EventOverview] Waiting for currentUser...');
        setLoading(false);
        setEvents([]);
        return;
      }

      try {
        setLoading(true);
        const response = await fetch(
          `http://localhost:9999/accounts/${currentUser.id}`
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const accountData = await response.json();
        console.log('✅ [EventOverview] Account data fetched:', accountData);

        // ✅ Chỉ lấy events có active = true
        const activeEvents =
          accountData.events?.filter(event => event.active === true) || [];
        setEvents(activeEvents);
      } catch (error) {
        console.error('❌ [EventOverview] Error fetching events:', error);
        setEvents([]);
      } finally {
        setLoading(false);
      }
    };

    fetchEvents();
  }, [currentUser]); // ✅ THÊM currentUser VÀO DEPENDENCY

  // Tính toán thống kê - CHỈ 3 THÔNG TIN CHÍNH
  const calculateStats = () => {
    if (!events || events.length === 0) {
      return {
        totalEvents: 0,
        totalAttendees: 0,
        totalBudget: 0,
        avgBudgetPerEvent: 0,
        upcomingEvents: 0,
        completedEvents: 0,
      };
    }

    const stats = events.reduce(
      (acc, event) => {
        acc.totalEvents += 1;
        acc.totalAttendees += event.estimatedAttendees || 0;
        acc.totalBudget += event.budget || 0;

        // Đếm theo status
        if (event.status === 'upcoming' || event.status === 'ongoing') {
          acc.upcomingEvents += 1;
        }
        if (event.status === 'completed') {
          acc.completedEvents += 1;
        }

        return acc;
      },
      {
        totalEvents: 0,
        totalAttendees: 0,
        totalBudget: 0,
        upcomingEvents: 0,
        completedEvents: 0,
      }
    );

    // Tính trung bình ngân sách
    stats.avgBudgetPerEvent =
      stats.totalEvents > 0 ? stats.totalBudget / stats.totalEvents : 0;

    return stats;
  };

  const formatCurrency = amount => {
    if (!amount) return '0 VNĐ';

    // Chuyển đổi thành tỷ nếu >= 1 tỷ
    if (amount >= 1000000000) {
      const billions = (amount / 1000000000).toFixed(1);
      return `${billions} tỷ VNĐ`;
    }

    // Chuyển đổi thành triệu nếu >= 1 triệu
    if (amount >= 1000000) {
      const millions = (amount / 1000000).toFixed(1);
      return `${millions} triệu VNĐ`;
    }

    // Định dạng số thường
    return `${new Intl.NumberFormat('vi-VN').format(amount)} VNĐ`;
  };

  const formatNumber = number => {
    if (!number) return '0';
    return new Intl.NumberFormat('vi-VN').format(number);
  };

  const stats = calculateStats();

  // ✅ THÊM HÀM TÍNH SỰ KIỆN HOẠT ĐỘNG
  const getActiveEventsCount = () => {
    // Đếm sự kiện không bị hủy (status !== 'cancelled')
    return events.filter(event => event.status !== 'cancelled').length;
  };

  // ✅ CHỈ 3 THẺ THỐNG KÊ CHÍNH VỚI DECORATION MỚI
  const statCards = [
    {
      title: 'Tổng sự kiện',
      value: formatNumber(stats.totalEvents),
      icon: Calendar,
      bgColor: 'bg-blue-50',
      iconColor: 'text-blue-600',
      description: 'Tổng số sự kiện trong hệ thống',
      // ✅ THÊM DECORATION
      decorationIcon: Activity,
      decorationText: `${getActiveEventsCount()} sự kiện hoạt động`,
      decorationColor: 'text-blue-500',
    },
    {
      title: 'Người tham dự',
      value: formatNumber(stats.totalAttendees),
      icon: Users,
      bgColor: 'bg-green-50',
      iconColor: 'text-green-600',
      description: 'Tổng số người dự kiến tham dự',
      // ✅ THÊM DECORATION
      decorationIcon: TrendingUp,
      decorationText: `TB: ${formatNumber(
        Math.round(stats.totalAttendees / (stats.totalEvents || 1))
      )} người/sự kiện`,
      decorationColor: 'text-green-500',
    },
    {
      title: 'Ngân sách',
      value: formatCurrency(stats.totalBudget),
      icon: DollarSign,
      bgColor: 'bg-purple-50',
      iconColor: 'text-purple-600',
      description: 'Tổng ngân sách các sự kiện',
      // ✅ THÊM DECORATION
      decorationIcon: Star,
      decorationText: `TB: ${formatCurrency(stats.avgBudgetPerEvent)}`,
      decorationColor: 'text-purple-500',
    },
  ];

  // ✅ HIỂN THỊ KHI CHƯA CÓ USER
  if (!currentUser) {
    return (
      <div className="text-center py-12">
        <div className="w-24 h-24 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
          <Calendar className="h-12 w-12 text-gray-400" />
        </div>
        <h3 className="text-lg font-semibold text-gray-900 mb-2">
          Đang chờ thông tin đăng nhập
        </h3>
        <p className="text-gray-600">
          Vui lòng đăng nhập để xem tổng quan sự kiện
        </p>
      </div>
    );
  }

  if (loading) {
    return (
      <div>
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            Tổng quan sự kiện
          </h2>
          <p className="text-gray-600">Đang tải thống kê...</p>
        </div>

        {/* 1 hàng x 3 cột */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {[1, 2, 3].map(i => (
            <div
              key={i}
              className="bg-white rounded-xl p-6 shadow-sm border border-gray-100 animate-pulse"
            >
              <div className="flex items-center justify-between mb-4">
                <div className="flex flex-col space-y-2">
                  <div className="h-4 bg-gray-200 rounded w-24"></div>
                  <div className="h-8 bg-gray-200 rounded w-16"></div>
                </div>
                <div className="w-14 h-14 bg-gray-200 rounded-xl"></div>
              </div>
              <div className="h-3 bg-gray-200 rounded w-full"></div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div>
      {/* Header */}
      <div className="mb-6 mt-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          Tổng quan sự kiện
        </h2>
      </div>

      {/* Stats Grid - 1 hàng x 3 cột - Larger Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {statCards.map((card, index) => {
          const IconComponent = card.icon;
          const DecorationIcon = card.decorationIcon;

          return (
            <div
              key={index}
              className="bg-white rounded-xl p-6 shadow-sm border border-gray-100 hover:shadow-lg transition-all duration-300 hover:-translate-y-1 group"
            >
              <div className="flex items-center justify-between mb-4">
                {/* Left side: Title + Value */}
                <div className="flex flex-col">
                  <span className="text-sm font-medium text-gray-600 mb-2">
                    {card.title}
                  </span>
                  <div className="text-2xl font-bold text-gray-900 group-hover:text-gray-700 transition-colors">
                    {card.value}
                  </div>
                </div>

                {/* Right side: Icon - Larger */}
                <div
                  className={`w-14 h-14 ${card.bgColor} rounded-xl flex items-center justify-center flex-shrink-0 group-hover:scale-110 transition-transform duration-300`}
                >
                  <IconComponent className={`h-7 w-7 ${card.iconColor}`} />
                </div>
              </div>

              {/* Description */}
              <p className="text-xs text-gray-500 leading-relaxed mb-3">
                {card.description}
              </p>

              {/* ✅ THAY THẾ THANH BẰNG DECORATION ĐẸP */}
              <div className="flex items-center justify-between">
                <div
                  className={`flex items-center gap-2 ${card.decorationColor}`}
                >
                  <DecorationIcon className="h-4 w-4" />
                  <span className="text-sm font-medium">
                    {card.decorationText}
                  </span>
                </div>

                {/* Thêm một chấm tròn nhỏ để trang trí */}
                <div
                  className={`w-2 h-2 rounded-full ${
                    index === 0
                      ? 'bg-blue-400'
                      : index === 1
                      ? 'bg-green-400'
                      : 'bg-purple-400'
                  } opacity-60`}
                ></div>
              </div>
            </div>
          );
        })}
      </div>

      {/* ✅ THÊM THÔNG TIN TRẠNG THÁI SỰ KIỆN */}
      {stats.totalEvents > 0 && (
        <div className="mt-6 grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="bg-amber-50 rounded-lg p-4 text-center border border-amber-100">
            <div className="text-lg font-bold text-amber-600">
              {events.filter(e => e.status === 'preparing').length}
            </div>
            <div className="text-xs text-amber-700">Đang chuẩn bị</div>
          </div>

          <div className="bg-purple-50 rounded-lg p-4 text-center border border-purple-100">
            <div className="text-lg font-bold text-purple-600">
              {events.filter(e => e.status === 'upcoming').length}
            </div>
            <div className="text-xs text-purple-700">Sắp diễn ra</div>
          </div>

          <div className="bg-blue-50 rounded-lg p-4 text-center border border-blue-100">
            <div className="text-lg font-bold text-blue-600">
              {events.filter(e => e.status === 'ongoing').length}
            </div>
            <div className="text-xs text-blue-700">Đang diễn ra</div>
          </div>

          <div className="bg-emerald-50 rounded-lg p-4 text-center border border-emerald-100">
            <div className="text-lg font-bold text-emerald-600">
              {events.filter(e => e.status === 'completed').length}
            </div>
            <div className="text-xs text-emerald-700">Hoàn thành</div>
          </div>
        </div>
      )}
    </div>
  );
};

export default EventOverview;
