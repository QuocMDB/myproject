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
  TrendingUp,
  Crown,
} from 'lucide-react';

// ✅ THÊM currentUser prop
const HomeEventList = ({ viewMode = 'grid', currentUser }) => {
  const [topAttendeeEvents, setTopAttendeeEvents] = useState([]);
  const [topBudgetEvents, setTopBudgetEvents] = useState([]);
  const [loading, setLoading] = useState(true);

  // AUTO-UPDATE STATUS THEO THỜI GIAN
  const updateEventStatuses = useCallback(events => {
    const now = new Date();
    let hasChanges = false;

    const updatedEvents = events.map(event => {
      if (!event.active || event.status === 'cancelled' || !event.startDate) {
        return event;
      }

      const startTime = new Date(event.startDate);
      const endTime = new Date(event.endDate || event.startDate);
      const timeUntilStart = startTime - now;
      const hoursUntilStart = timeUntilStart / (1000 * 60 * 60);

      let newStatus;

      if (now > endTime) {
        newStatus = 'completed';
      } else if (now >= startTime && now <= endTime) {
        newStatus = 'ongoing';
      } else if (hoursUntilStart <= 12 && hoursUntilStart > 0) {
        newStatus = 'upcoming';
      } else {
        newStatus = 'preparing';
      }

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

    return hasChanges ? updatedEvents : events;
  }, []);

  // useEffect cho auto-update
  useEffect(() => {
    const interval = setInterval(() => {
      setTopAttendeeEvents(prev => updateEventStatuses(prev));
      setTopBudgetEvents(prev => updateEventStatuses(prev));
    }, 500);

    return () => clearInterval(interval);
  }, [updateEventStatuses]);

  // FETCH EVENTS
  useEffect(() => {
    const fetchEvents = async () => {
      if (!currentUser?.id) {
        console.log('⏳ [HomeEventList] Waiting for currentUser...');
        setLoading(false);
        setTopAttendeeEvents([]);
        setTopBudgetEvents([]);
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
        console.log('✅ [HomeEventList] Account data fetched:', accountData);

        const allEvents = accountData.events || [];
        const activeEvents = allEvents.filter(
          event => event.active === true && event.status !== 'cancelled'
        );

        console.log('📊 Active events:', activeEvents.length);

        const topByAttendees = activeEvents
          .filter(event => event.estimatedAttendees)
          .sort((a, b) => {
            const attendeesA = parseInt(a.estimatedAttendees) || 0;
            const attendeesB = parseInt(b.estimatedAttendees) || 0;
            return attendeesB - attendeesA;
          })
          .slice(0, 3);

        const topByBudget = activeEvents
          .filter(event => event.budget && event.budget > 0)
          .sort((a, b) => {
            const budgetA = parseInt(a.budget) || 0;
            const budgetB = parseInt(b.budget) || 0;
            return budgetB - budgetA;
          })
          .slice(0, 3);

        setTopAttendeeEvents(topByAttendees);
        setTopBudgetEvents(topByBudget);
      } catch (error) {
        console.error('❌ [HomeEventList] Error fetching events:', error);
        setTopAttendeeEvents([]);
        setTopBudgetEvents([]);
      } finally {
        setLoading(false);
      }
    };

    fetchEvents();
  }, [currentUser]);

  // ✅ UTILITY FUNCTIONS - GIỐNG EVENTLIST
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
    if (!amount) return '0';
    return new Intl.NumberFormat('vi-VN').format(amount);
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
        icon: <Clock className="h-3 w-3" />,
      },
      upcoming: {
        text: 'Sắp diễn ra',
        class:
          'bg-purple-500 text-white shadow-lg hover:shadow-xl border border-purple-400 hover:scale-105',
        icon: <Clock className="h-3 w-3 animate-spin" />,
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

  // ✅ GRID LAYOUT - GIỐNG EVENTLIST
  const GridLayout = ({
    events,
    showBudgetHighlight = false,
    showAttendeeHighlight = false,
  }) => (
    <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
      {events.map((event, index) => {
        const eventId = event.id || index;
        const locationText = formatLocation(event.location);
        const categoryImage = getCategoryImage(
          event.categories,
          event.category
        );

        return (
          <div
            key={eventId}
            className="group bg-white rounded-xl shadow-sm border border-gray-100 hover:shadow-xl hover:border-gray-200 transition-all duration-300 overflow-hidden cursor-pointer transform hover:-translate-y-1 flex flex-col h-full"
          >
            {/* Header Image */}
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

              {/* Highlight Badges */}
              {showAttendeeHighlight && (
                <div className="absolute bottom-3 left-4 z-10">
                  <span className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-gradient-to-r from-blue-500 to-purple-600 text-white rounded-full text-xs font-bold shadow-lg">
                    <Crown className="h-3 w-3" />
                    Top Popular
                  </span>
                </div>
              )}

              {showBudgetHighlight && (
                <div className="absolute bottom-3 left-4 z-10">
                  <span className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-gradient-to-r from-yellow-400 to-orange-500 text-white rounded-full text-xs font-bold shadow-lg">
                    <TrendingUp className="h-3 w-3" />
                    Top Budget
                  </span>
                </div>
              )}

              <div className="absolute inset-0 bg-blue-600/0 group-hover:bg-blue-600/10 transition-all duration-300"></div>
            </div>

            {/* Content */}
            <div className="p-6 flex flex-col flex-grow">
              {/* Title */}
              <div className="h-6 mb-3 flex items-start">
                <h3 className="text-xl font-bold text-gray-900 line-clamp-2 group-hover:text-blue-600 transition-colors leading-tight">
                  {event.title || `Event ${index + 1}`}
                </h3>
              </div>

              {/* Description */}
              <div className="h-8 mb-10">
                {event.description && (
                  <p className="text-gray-600 text-sm line-clamp-2 leading-relaxed">
                    {event.description}
                  </p>
                )}
              </div>

              {/* Event Details - GIỐNG EVENTLIST */}
              <div className="space-y-3 mb-5 flex-grow">
                {/* Date */}
                <div className="h-8 flex items-center">
                  <div className="flex items-center gap-3 text-sm text-gray-700">
                    <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                      <Calendar className="h-4 w-4 text-blue-600" />
                    </div>
                    <span className="font-medium">
                      {formatDateTime(event.startDate)}
                    </span>
                  </div>
                </div>

                {/* Location */}
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

                {/* Attendees */}
                <div className="h-8 flex items-center">
                  <div className="flex items-center gap-3 text-sm text-gray-700">
                    <div className="w-8 h-8 bg-orange-50 rounded-lg flex items-center justify-center flex-shrink-0">
                      <UserCheck className="h-4 w-4 text-orange-600" />
                    </div>
                    <span
                      className={`font-medium ${
                        showAttendeeHighlight ? 'text-purple-700 font-bold' : ''
                      }`}
                    >
                      Dự kiến: {formatCurrency(event.estimatedAttendees)} người
                    </span>
                  </div>
                </div>

                {/* Budget */}
                <div className="h-8 flex items-center">
                  <div className="flex items-center gap-3 text-sm text-gray-700">
                    <div
                      className={`w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 ${
                        showBudgetHighlight ? 'bg-orange-50' : 'bg-green-50'
                      }`}
                    >
                      <DollarSign
                        className={`h-4 w-4 ${
                          showBudgetHighlight
                            ? 'text-orange-600'
                            : 'text-green-600'
                        }`}
                      />
                    </div>
                    <span
                      className={`font-medium ${
                        showBudgetHighlight ? 'text-orange-700 font-bold' : ''
                      }`}
                    >
                      Budget: {formatCurrency(event.budget)} ₫
                    </span>
                  </div>
                </div>
              </div>

              {/* Action Buttons - GIỐNG EVENTLIST */}
              <div className="flex justify-center gap-1 pt-4 border-t border-gray-100 mt-auto">
                <button
                  className="flex-1 p-3 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Xem chi tiết"
                >
                  <Eye className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                  <span className="text-sm font-medium">Xem</span>
                </button>
                <button
                  className="flex-1 p-3 text-gray-500 hover:text-green-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Chỉnh sửa sự kiện"
                >
                  <Edit className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                  <span className="text-sm font-medium">Sửa</span>
                </button>
                <button
                  className="flex-1 p-3 text-gray-500 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Hủy sự kiện"
                >
                  <span className="text-xs font-bold group-hover/btn:scale-110 transition-transform">
                    ✕
                  </span>
                  <span className="text-sm font-medium">Hủy</span>
                </button>
                <button
                  className="flex-1 p-3 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Xóa"
                >
                  <Trash2 className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                  <span className="text-sm font-medium">Xóa</span>
                </button>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );

  // ✅ LIST LAYOUT - GIỐNG EVENTLIST
  const ListLayout = ({
    events,
    showBudgetHighlight = false,
    showAttendeeHighlight = false,
  }) => (
    <div className="space-y-4">
      {events.map((event, index) => {
        const eventId = event.id || index;
        const locationText = formatLocation(event.location);
        const categoryImage = getCategoryImage(
          event.categories,
          event.category
        );

        return (
          <div
            key={eventId}
            className="group bg-white rounded-xl shadow-sm border border-gray-100 hover:shadow-lg hover:border-gray-200 transition-all duration-300 overflow-hidden"
          >
            <div className="flex items-center p-6 gap-6">
              {/* Image */}
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

                {/* Highlight badges */}
                {(showAttendeeHighlight || showBudgetHighlight) && (
                  <div className="absolute top-1 right-1">
                    <span
                      className={`inline-flex items-center gap-1 px-2 py-1 text-white rounded-md text-xs font-bold ${
                        showAttendeeHighlight
                          ? 'bg-gradient-to-r from-blue-500 to-purple-600'
                          : 'bg-gradient-to-r from-yellow-400 to-orange-500'
                      }`}
                    >
                      {showAttendeeHighlight ? (
                        <Crown className="h-3 w-3" />
                      ) : (
                        <TrendingUp className="h-3 w-3" />
                      )}
                    </span>
                  </div>
                )}
              </div>

              {/* Content */}
              <div className="flex-1 min-w-0">
                <div className="flex items-start justify-between mb-3">
                  <h3 className="text-lg font-bold text-gray-900 group-hover:text-blue-600 transition-colors line-clamp-1">
                    {event.title || `Event ${index + 1}`}
                  </h3>
                  <div className="flex-shrink-0 ml-4">
                    {getStatusBadge(event.status)}
                  </div>
                </div>

                {event.description && (
                  <p className="text-gray-600 text-sm mb-4 line-clamp-2">
                    {event.description}
                  </p>
                )}

                {/* Event details - GIỐNG EVENTLIST */}
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
                      <span
                        className={
                          showAttendeeHighlight
                            ? 'font-bold text-purple-700'
                            : ''
                        }
                      >
                        {formatCurrency(event.estimatedAttendees)} người
                      </span>
                    </div>
                  )}

                  {event.budget && (
                    <div className="flex items-center gap-2">
                      <DollarSign
                        className={`h-4 w-4 ${
                          showBudgetHighlight
                            ? 'text-orange-600'
                            : 'text-green-600'
                        }`}
                      />
                      <span
                        className={
                          showBudgetHighlight ? 'text-orange-700 font-bold' : ''
                        }
                      >
                        {formatCurrency(event.budget)} ₫
                      </span>
                    </div>
                  )}
                </div>
              </div>

              {/* Action buttons - GIỐNG EVENTLIST */}
              <div className="flex items-center gap-2 flex-shrink-0">
                <button
                  className="p-3 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Xem chi tiết"
                >
                  <Eye className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
                <button
                  className="p-3 text-gray-500 hover:text-green-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Chỉnh sửa sự kiện"
                >
                  <Edit className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
                <button
                  className="p-2 text-gray-500 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition-all duration-200 group/btn"
                  title="Hủy sự kiện"
                >
                  <span className="text-sm font-bold group-hover/btn:scale-110 transition-transform">
                    ✕
                  </span>
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

  // LOADING COMPONENT
  const LoadingSection = ({ title, subtitle }) => (
    <div>
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900 mb-2">{title}</h2>
        <p className="text-gray-600">{subtitle}</p>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
        {[1, 2, 3].map(i => (
          <div
            key={i}
            className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden animate-pulse"
          >
            <div className="h-44 bg-gradient-to-r from-gray-200 to-gray-300"></div>
            <div className="p-6 space-y-4">
              <div className="h-5 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-3/4"></div>
              <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-full"></div>
              <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-1/2"></div>
              <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-2/3"></div>
              <div className="h-10 bg-gradient-to-r from-gray-200 to-gray-300 rounded"></div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // EMPTY STATE COMPONENT
  const EmptyState = ({ title, subtitle, icon: Icon }) => (
    <div className="text-center py-12">
      <div className="w-24 h-24 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
        <Icon className="h-12 w-12 text-gray-400" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600">{subtitle}</p>
    </div>
  );

  // MAIN RENDER
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
          Vui lòng đăng nhập để xem danh sách sự kiện
        </p>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="space-y-12">
        <LoadingSection
          title="Sự kiện nổi bật nhất"
          subtitle="Đang tải dữ liệu..."
        />
        <LoadingSection
          title="Sự kiện ngân sách cao nhất"
          subtitle="Đang tải dữ liệu..."
        />
      </div>
    );
  }

  return (
    <div className="space-y-12">
      {/* TOP ATTENDEE EVENTS */}
      <div>
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            🌟 Sự kiện nổi bật nhất của {currentUser.name || currentUser.email}
          </h2>
          <p className="text-gray-600">
            Top {topAttendeeEvents.length} sự kiện có nhiều người tham gia nhất
          </p>
        </div>

        {topAttendeeEvents.length === 0 ? (
          <EmptyState
            title="Chưa có sự kiện nổi bật nào"
            subtitle="Hãy tạo sự kiện với nhiều người tham gia để hiển thị ở đây!"
            icon={Users}
          />
        ) : viewMode === 'grid' ? (
          <GridLayout
            events={topAttendeeEvents}
            showBudgetHighlight={false}
            showAttendeeHighlight={true}
          />
        ) : (
          <ListLayout
            events={topAttendeeEvents}
            showBudgetHighlight={false}
            showAttendeeHighlight={true}
          />
        )}
      </div>

      {/* TOP BUDGET EVENTS */}
      <div>
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            💰 Sự kiện ngân sách cao nhất của{' '}
            {currentUser.name || currentUser.email}
          </h2>
          <p className="text-gray-600">
            Top {topBudgetEvents.length} sự kiện có ngân sách lớn nhất từng được
            diễn ra
          </p>
        </div>

        {topBudgetEvents.length === 0 ? (
          <EmptyState
            title="Chưa có sự kiện với ngân sách cao"
            subtitle="Hãy thêm ngân sách cho các sự kiện để hiển thị ở đây!"
            icon={DollarSign}
          />
        ) : viewMode === 'grid' ? (
          <GridLayout
            events={topBudgetEvents}
            showBudgetHighlight={true}
            showAttendeeHighlight={false}
          />
        ) : (
          <ListLayout
            events={topBudgetEvents}
            showBudgetHighlight={true}
            showAttendeeHighlight={false}
          />
        )}
      </div>
    </div>
  );
};

export default HomeEventList;
