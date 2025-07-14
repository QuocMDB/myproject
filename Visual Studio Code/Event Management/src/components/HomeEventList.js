import React, { useEffect, useState, useCallback } from 'react';
import {
  Calendar,
  MapPin,
  Users,
  Edit,
  Trash2,
  Eye,
  CheckCircle2,
  UserCheck,
  DollarSign,
  Clock,
} from 'lucide-react';

const HomeEventList = ({ viewMode = 'grid' }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  // AUTO-UPDATE STATUS THEO THỜI GIAN
  const updateEventStatuses = useCallback(() => {
    const now = new Date();
    let hasChanges = false;

    setData(prevData => {
      const newData = prevData.map(event => {
        if (!event.active || event.status === 'cancelled' || !event.startDate) {
          return event;
        }

        const startTime = new Date(event.startDate);
        const endTime = new Date(event.endDate || event.startDate);

        // Tính thời gian còn lại đến khi bắt đầu
        const timeUntilStart = startTime - now;
        const hoursUntilStart = timeUntilStart / (1000 * 60 * 60);

        let newStatus;

        if (now > endTime) {
          // Đã kết thúc
          newStatus = 'completed';
        } else if (now >= startTime && now <= endTime) {
          // Đang diễn ra
          newStatus = 'ongoing';
        } else if (hoursUntilStart <= 12 && hoursUntilStart > 0) {
          // Sắp đến giờ (trong vòng 12h)
          newStatus = 'upcoming';
        } else {
          // Còn lâu mới diễn ra
          newStatus = 'preparing';
        }

        // CHỈ UPDATE KHI STATUS THỰC SỰ THAY ĐỔI
        if (event.status !== newStatus) {
          hasChanges = true;
          console.log(
            `🔄 Event "${event.title}" status: ${
              event.status
            } → ${newStatus} (${Math.round(hoursUntilStart)}h until start)`
          );
          return { ...event, status: newStatus };
        }

        return event;
      });

      // CHỈ RETURN DATA MỚI KHI CÓ THAY ĐỔI
      return hasChanges ? newData : prevData;
    });
  }, []);

  // useEffect cho auto-update
  useEffect(() => {
    // Cập nhật ngay khi component mount
    updateEventStatuses();

    // Thiết lập interval để cập nhật mỗi 10 giây
    const interval = setInterval(() => {
      updateEventStatuses();
    }, 500); // 0.5s

    // Cleanup khi component unmount
    return () => clearInterval(interval);
  }, [updateEventStatuses]);

  useEffect(() => {
    fetch('http://localhost:9999/events')
      .then(res => res.json())
      .then(data => {
        // ✅ Chỉ lấy events có active = true, khác status = hủy và có estimatedAttendees
        const activeEvents = data
          .filter(
            event =>
              event.active === true &&
              event.status !== 'cancelled' &&
              event.estimatedAttendees
          )
          .sort((a, b) => {
            const attendeesA = parseInt(a.estimatedAttendees) || 0;
            const attendeesB = parseInt(b.estimatedAttendees) || 0;
            return attendeesB - attendeesA; // Sắp xếp giảm dần
          })
          .slice(0, 3); // Lấy 3 sự kiện đầu

        console.log(
          '📊 Top 3 events by attendees:',
          activeEvents.map(e => ({
            title: e.title,
            attendees: e.estimatedAttendees,
          }))
        );

        setData(activeEvents);
        setLoading(false);
      })
      .catch(error => {
        console.error('❌ Error fetching events:', error);
        setLoading(false);
      });
  }, []);

  const formatDateTime = dateString => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return `${date.toLocaleDateString('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    })} ${date.toLocaleTimeString('vi-VN', {
      hour: '2-digit',
      minute: '2-digit',
    })}`;
  };

  const formatLocation = location => {
    if (!location) return '';
    if (typeof location === 'string') return location;
    return location.venue || location.address || 'Chưa xác định';
  };

  const formatCurrency = amount => {
    if (!amount) return '0 ₫';
    return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
  };

  const getCategoryImage = (categories, category) => {
    const images = {
      technology: '/image/technology.jpg',
      business: '/image/business.jpg',
      education: '/image/education.jpg',
      entertainment: '/image/entertainment.png',
      sports: '/image/sports.jpg',
      health: '/image/health.jpg',
      internal: '/image/internal.jpg',
      marketing: '/image/marketing.jpg',
      training: '/image/training.png',
    };
    // Ưu tiên lấy category đầu tiên từ mảng categories
    let targetCategory = null;

    if (categories && Array.isArray(categories) && categories.length > 0) {
      targetCategory = categories[0];
    } else if (category) {
      targetCategory = category;
    }
    return (
      images[targetCategory?.toLowerCase()] ||
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=200&fit=crop&crop=center'
    );
  };

  // CÂP NHẬT getStatusBadge với status "upcoming"
  const getStatusBadge = status => {
    const statusConfig = {
      completed: {
        text: 'Hoàn thành',
        class:
          'bg-emerald-500 text-white shadow-lg hover:shadow-xl border border-emerald-400 hover:scale-105',
        icon: <CheckCircle2 className="h-3 w-3" />,
      },
      preparing: {
        text: 'Chuẩn bị',
        class:
          'bg-amber-500 text-white shadow-lg hover:shadow-xl border border-amber-400 hover:scale-105',
        icon: <span className="text-xs">⏳</span>,
      },
      // THÊM: Status mới - Sắp đến giờ
      upcoming: {
        text: 'Sắp đến giờ',
        class:
          'bg-purple-500 text-white shadow-lg hover:shadow-xl border border-purple-400 hover:scale-105',
        icon: <Clock className="h-3 w-3 animate-spin" />, // Icon đồng hồ xoay
      },
      ongoing: {
        text: 'Đang diễn ra',
        class:
          'bg-blue-500 text-white shadow-lg hover:shadow-xl border border-blue-400 hover:scale-105',
        icon: <span className="text-xs">▶</span>,
      },
      cancelled: {
        text: 'Đã hủy',
        class:
          'bg-red-500 text-white shadow-lg hover:shadow-xl border border-red-400 hover:scale-105',
        icon: <span className="text-xs">✕</span>,
      },
    };

    const config = statusConfig[status?.toLowerCase()];
    if (!config) return null;

    return (
      <span
        className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold transition-all duration-300 ${config.class}`}
      >
        {config.icon}
        {config.text}
      </span>
    );
  };

  // Hàm lấy class cho card với hiệu ứng đặc biệt cho upcoming
  const getEventCardClass = event => {
    let baseClass =
      'group bg-white rounded-xl shadow-sm border border-gray-100 hover:shadow-xl hover:border-gray-200 transition-all duration-300 overflow-hidden cursor-pointer transform hover:-translate-y-1 flex flex-col h-full';

    if (event.status === 'cancelled') {
      return baseClass + ' opacity-60 grayscale hover:grayscale-0';
    }

    // Hiệu ứng đặc biệt cho upcoming events
    if (event.status === 'upcoming') {
      return (
        baseClass + ' ring-2 ring-purple-200 ring-opacity-50 animate-pulse'
      );
    }

    return baseClass;
  };

  // GRID LAYOUT COMPONENT với chiều cao đồng nhất
  const GridLayout = () => (
    <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
      {data.map((event, index) => {
        const eventId = event.id || index;
        const locationText = formatLocation(event.location);
        const categoryImage = getCategoryImage(
          event.categories,
          event.category
        );

        return (
          <div key={eventId} className={getEventCardClass(event)}>
            {/* Header with Category Image - Cố định chiều cao */}
            <div
              className="h-44 relative bg-cover bg-center bg-no-repeat flex-shrink-0"
              style={{ backgroundImage: `url(${categoryImage})` }}
            >
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"></div>

              {/* Category Badge */}
              <div className="absolute top-4 left-4 z-10">
                {event.category && (
                  <span className="px-3 py-1.5 bg-white/95 backdrop-blur-sm text-gray-800 rounded-full text-xs font-semibold capitalize shadow-lg border border-white/20">
                    {event.category}
                  </span>
                )}
              </div>

              {/* Status Badge */}
              <div className="absolute top-3 right-4 z-10">
                {getStatusBadge(event.status)}
              </div>

              <div className="absolute inset-0 bg-blue-600/0 group-hover:bg-blue-600/10 transition-all duration-300"></div>
            </div>

            {/* Card Content - Flex grow để chiếm hết không gian còn lại */}
            <div className="p-6 flex flex-col flex-grow">
              {/* Title - Cố định chiều cao */}
              <div className="h-6 mb-3 flex items-start">
                <h3 className="text-xl font-bold text-gray-900 line-clamp-2 group-hover:text-blue-600 transition-colors leading-tight">
                  {event.title || `Event ${index + 1}`}
                </h3>
              </div>

              {/* Description - Cố định chiều cao */}
              <div className="h-8 mb-10">
                {event.description && (
                  <p className="text-gray-600 text-sm line-clamp-2 leading-relaxed">
                    {event.description}
                  </p>
                )}
              </div>

              {/* Event Details - Cố định chiều cao cho từng item */}
              <div className="space-y-3 mb-5 flex-grow">
                {/* Date - Luôn hiển thị, cố định chiều cao */}
                <div className="h-8 flex items-center">
                  {event.startDate ? (
                    <div className="flex items-center gap-3 text-sm text-gray-700">
                      <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <Calendar className="h-4 w-4 text-blue-600" />
                      </div>
                      <span className="font-medium">
                        {formatDateTime(event.startDate)}
                      </span>
                    </div>
                  ) : (
                    <div className="flex items-center gap-3 text-sm text-gray-400">
                      <div className="w-8 h-8 bg-gray-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <Calendar className="h-4 w-4 text-gray-400" />
                      </div>
                      <span className="font-medium">
                        Chưa xác định thời gian
                      </span>
                    </div>
                  )}
                </div>

                {/* Location - Luôn hiển thị, cố định chiều cao */}
                <div className="h-8 flex items-center">
                  {locationText ? (
                    <div className="flex items-center gap-3 text-sm text-gray-700">
                      <div className="w-8 h-8 bg-red-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <MapPin className="h-4 w-4 text-red-600" />
                      </div>
                      <span className="truncate font-medium">
                        {locationText}
                      </span>
                    </div>
                  ) : (
                    <div className="flex items-center gap-3 text-sm text-gray-400">
                      <div className="w-8 h-8 bg-gray-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <MapPin className="h-4 w-4 text-gray-400" />
                      </div>
                      <span className="font-medium">
                        Chưa xác định địa điểm
                      </span>
                    </div>
                  )}
                </div>

                {/* Attendees - Luôn hiển thị, cố định chiều cao */}
                <div className="h-8 flex items-center">
                  {event.estimatedAttendees ? (
                    <div className="flex items-center gap-3 text-sm text-gray-700">
                      <div className="w-8 h-8 bg-orange-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <UserCheck className="h-4 w-4 text-orange-600" />
                      </div>
                      <span className="font-medium">
                        Dự kiến: {event.estimatedAttendees} người
                      </span>
                    </div>
                  ) : (
                    <div className="flex items-center gap-3 text-sm text-gray-400">
                      <div className="w-8 h-8 bg-gray-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <UserCheck className="h-4 w-4 text-gray-400" />
                      </div>
                      <span className="font-medium">
                        Chưa ước tính số người
                      </span>
                    </div>
                  )}
                </div>

                {/* Budget - Luôn hiển thị, cố định chiều cao */}
                <div className="h-8 flex items-center">
                  {event.budget ? (
                    <div className="flex items-center gap-3 text-sm text-gray-700">
                      <div className="w-8 h-8 bg-green-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <DollarSign className="h-4 w-4 text-green-600" />
                      </div>
                      <span className="font-medium">
                        Budget: {formatCurrency(event.budget)}
                      </span>
                    </div>
                  ) : (
                    <div className="flex items-center gap-3 text-sm text-gray-400">
                      <div className="w-8 h-8 bg-gray-50 rounded-lg flex items-center justify-center flex-shrink-0">
                        <DollarSign className="h-4 w-4 text-gray-400" />
                      </div>
                      <span className="font-medium">
                        Chưa xác định ngân sách
                      </span>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );

  // LIST LAYOUT COMPONENT với chiều cao đồng nhất
  const ListLayout = () => (
    <div className="space-y-4">
      {data.map((event, index) => {
        const eventId = event.id || index;
        const locationText = formatLocation(event.location);
        const categoryImage = getCategoryImage(
          event.categories,
          event.category
        );

        return (
          <div
            key={eventId}
            className={`group bg-white rounded-xl shadow-sm border border-gray-100 hover:shadow-lg hover:border-gray-200 transition-all duration-300 overflow-hidden ${
              event.status === 'upcoming'
                ? 'ring-2 ring-purple-200 ring-opacity-50'
                : ''
            }`}
          >
            <div className="flex items-center p-6 gap-6 min-h-[140px]">
              {/* Event Image - Cố định kích thước */}
              <div
                className="w-32 h-24 rounded-lg bg-cover bg-center bg-no-repeat flex-shrink-0 relative overflow-hidden"
                style={{ backgroundImage: `url(${categoryImage})` }}
              >
                <div className="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent"></div>
                {event.category && (
                  <div className="absolute bottom-1 left-1">
                    <span className="px-2 py-1 bg-white/90 text-gray-800 rounded text-xs font-medium capitalize">
                      {event.category}
                    </span>
                  </div>
                )}
              </div>

              {/* Event Content - Flex grow */}
              <div className="flex-1 min-w-0 h-full flex flex-col justify-between">
                <div className="flex items-start justify-between mb-3">
                  <h3 className="text-lg font-bold text-gray-900 group-hover:text-blue-600 transition-colors line-clamp-1">
                    {event.title || `Event ${index + 1}`}
                  </h3>
                  <div className="flex-shrink-0 ml-4">
                    {getStatusBadge(event.status)}
                  </div>
                </div>

                {/* Description - Cố định chiều cao */}
                <div className="h-10 mb-4">
                  {event.description && (
                    <p className="text-gray-600 text-sm line-clamp-2">
                      {event.description}
                    </p>
                  )}
                </div>

                {/* Event Details Row */}
                <div className="flex flex-wrap gap-6 text-sm text-gray-600 mb-4">
                  {event.startDate && (
                    <div className="flex items-center gap-2">
                      <Calendar className="h-4 w-4 text-blue-600" />
                      <span>{formatDateTime(event.startDate)}</span>
                    </div>
                  )}

                  {locationText && (
                    <div className="flex items-center gap-2">
                      <MapPin className="h-4 w-4 text-red-600" />
                      <span className="truncate max-w-48">{locationText}</span>
                    </div>
                  )}

                  {event.estimatedAttendees && (
                    <div className="flex items-center gap-2">
                      <UserCheck className="h-4 w-4 text-orange-600" />
                      <span>{event.estimatedAttendees} người</span>
                    </div>
                  )}

                  {event.budget && (
                    <div className="flex items-center gap-2">
                      <DollarSign className="h-4 w-4 text-green-600" />
                      <span>{formatCurrency(event.budget)}</span>
                    </div>
                  )}
                </div>
              </div>

              {/* Action Buttons - Cố định vị trí */}
              <div className="flex items-center gap-2 flex-shrink-0">
                <button
                  className="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all duration-200 group/btn"
                  title="Xem chi tiết"
                >
                  <Eye className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
                <button
                  className="p-2 text-gray-500 hover:text-green-600 hover:bg-green-50 rounded-lg transition-all duration-200 group/btn"
                  title="Chỉnh sửa"
                >
                  <Edit className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
                <button
                  className="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all duration-200 group/btn"
                  title="Xóa"
                >
                  <Trash2 className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );

  if (loading) {
    return (
      <div>
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            Sự kiện nổi bật nhất
          </h2>
          <p className="text-gray-600">Đang tải dữ liệu...</p>
        </div>
        <div
          className={
            viewMode === 'grid'
              ? 'grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6'
              : 'space-y-4'
          }
        >
          {[1, 2, 3].map(i => (
            <div
              key={i}
              className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden animate-pulse"
            >
              {viewMode === 'grid' ? (
                <>
                  <div className="h-44 bg-gradient-to-r from-gray-200 to-gray-300"></div>
                  <div className="p-6 space-y-4">
                    <div className="h-5 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-3/4"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-full"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-1/2"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-2/3"></div>
                    <div className="h-10 bg-gradient-to-r from-gray-200 to-gray-300 rounded"></div>
                  </div>
                </>
              ) : (
                <div className="flex items-center p-6 gap-6 min-h-[140px]">
                  <div className="w-32 h-24 bg-gradient-to-r from-gray-200 to-gray-300 rounded-lg"></div>
                  <div className="flex-1 space-y-3">
                    <div className="h-5 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-2/3"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-full"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-3/4"></div>
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    );
  }

  if (data.length === 0) {
    return (
      <div className="text-center py-12">
        <div className="w-24 h-24 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
          <Calendar className="h-12 w-12 text-gray-400" />
        </div>
        <h3 className="text-lg font-semibold text-gray-900 mb-2">
          Chưa có sự kiện nổi bật nào
        </h3>
        <p className="text-gray-600">
          Hãy tạo sự kiện với nhiều người tham gia để hiển thị ở đây!
        </p>
      </div>
    );
  }

  return (
    <div>
      {/* Header */}
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">
          🌟 Sự kiện nổi bật nhất
        </h2>
        <p className="text-gray-600">
          Top {data.length} sự kiện có nhiều người tham gia nhất
        </p>
      </div>

      {/* Render layout based on viewMode */}
      {viewMode === 'grid' ? <GridLayout /> : <ListLayout />}
    </div>
  );
};

export default HomeEventList;
