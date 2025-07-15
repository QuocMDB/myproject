import React, { useEffect, useState, useCallback, useRef } from 'react';
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
import { useNavigate } from 'react-router-dom';

const EventList = ({ viewMode = 'grid', filters = {}, currentUser }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filteredData, setFilteredData] = useState([]);
  const [accountData, setAccountData] = useState(null);
  const navigate = useNavigate();

  // ✅ REF ĐỂ TRACK STATUS ĐÃ ĐƯỢC XỬ LÝ
  const processedStatusRef = useRef(new Map()); // eventId -> status
  const isUpdatingRef = useRef(false);

  // ✅ HÀM TÍNH STATUS DỰA TRÊN THỜI GIAN
  const calculateEventStatus = useCallback(event => {
    if (!event.active || event.status === 'cancelled' || !event.startDate) {
      return event.status || 'preparing';
    }

    const now = new Date();
    const startTime = new Date(event.startDate);
    const endTime = new Date(event.endDate || event.startDate);
    const timeUntilStart = startTime - now;
    const hoursUntilStart = timeUntilStart / (1000 * 60 * 60);

    if (now > endTime) {
      return 'completed';
    } else if (now >= startTime && now <= endTime) {
      return 'ongoing';
    } else if (hoursUntilStart <= 12 && hoursUntilStart > 0) {
      return 'upcoming';
    } else {
      return 'preparing';
    }
  }, []);

  // ✅ HÀM UPDATE DATABASE - IMMEDIATE SYNC
  const updateEventInDatabase = async (eventId, newStatus, eventTitle) => {
    if (!accountData || isUpdatingRef.current) return;

    try {
      isUpdatingRef.current = true;
      console.log(`🔄 [DB] IMMEDIATE sync: "${eventTitle}" → ${newStatus}`);

      const eventIndex = accountData.events.findIndex(
        event => event.id === eventId
      );
      if (eventIndex === -1) {
        throw new Error(`Event ${eventId} not found`);
      }

      const updatedEvents = [...accountData.events];
      updatedEvents[eventIndex] = {
        ...updatedEvents[eventIndex],
        status: newStatus,
        lastStatusUpdate: new Date().toISOString(),
      };

      const updatedAccount = {
        ...accountData,
        events: updatedEvents,
      };

      // ✅ SYNC NGAY LẬP TỨC - KHÔNG ASYNC
      const response = await fetch(
        `http://localhost:9999/accounts/${accountData.id}`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(updatedAccount),
        }
      );

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      setAccountData(result);

      console.log(`✅ [DB] SYNCED: "${eventTitle}" → ${newStatus}`);
      return true;
    } catch (error) {
      console.error(`❌ [DB] FAILED: "${eventTitle}":`, error.message);
      return false;
    } finally {
      isUpdatingRef.current = false;
    }
  };

  // ✅ HÀM CHECK VÀ UPDATE STATUS - CHỈ KHI CÓ THAY ĐỔI
  const checkAndUpdateStatuses = useCallback(async () => {
    if (!data.length || isUpdatingRef.current) return;

    const statusChanges = [];

    // ✅ CHỈ CHECK EVENTS CÓ TIỀM NĂNG THAY ĐỔI STATUS
    const eventsToCheck = data.filter(event => {
      const currentStatus = event.status;
      const calculatedStatus = calculateEventStatus(event);
      const lastProcessedStatus = processedStatusRef.current.get(event.id);

      // Chỉ check nếu:
      // 1. Status hiện tại khác với status tính toán
      // 2. Chưa được xử lý lần nào
      // 3. Status đã thay đổi từ lần xử lý trước
      return (
        currentStatus !== calculatedStatus ||
        lastProcessedStatus === undefined ||
        lastProcessedStatus !== calculatedStatus
      );
    });

    if (eventsToCheck.length === 0) {
      return; // Không có gì để update
    }

    console.log(
      `🔍 [Status Check] Checking ${eventsToCheck.length}/${data.length} events...`
    );

    // ✅ XỬ LÝ TỪNG EVENT CÓ THAY ĐỔI
    for (const event of eventsToCheck) {
      const newStatus = calculateEventStatus(event);
      const oldStatus = event.status;

      if (oldStatus !== newStatus) {
        console.log(
          `📝 [Status Change] "${event.title}": ${oldStatus} → ${newStatus}`
        );

        statusChanges.push({
          id: event.id,
          title: event.title,
          oldStatus,
          newStatus,
        });

        // ✅ UPDATE DATABASE NGAY LẬP TỨC
        await updateEventInDatabase(event.id, newStatus, event.title);
      }

      // ✅ MARK AS PROCESSED
      processedStatusRef.current.set(event.id, newStatus);
    }

    // ✅ UPDATE UI CHỈ KHI CÓ THAY ĐỔI
    if (statusChanges.length > 0) {
      console.log(
        `🎯 [UI Update] Updating ${statusChanges.length} events in UI...`
      );

      setData(prevData =>
        prevData.map(event => {
          const change = statusChanges.find(c => c.id === event.id);
          return change ? { ...event, status: change.newStatus } : event;
        })
      );
    }
  }, [data, calculateEventStatus, accountData]);

  // ✅ REALTIME STATUS MONITORING - CHỈ KHI CẦN THIẾT
  useEffect(() => {
    if (!currentUser || !accountData || !data.length) return;

    console.log('🚀 [Realtime] Starting smart status monitoring...');

    // ✅ CHECK NGAY KHI MOUNT
    checkAndUpdateStatuses();

    // ✅ INTERVAL THÔNG MINH - CHỈ CHECK KHI CẦN
    const interval = setInterval(() => {
      checkAndUpdateStatuses();
    }, 5000); // 5 giây - đủ nhanh cho realtime

    return () => {
      console.log('🛑 [Realtime] Stopping status monitoring...');
      clearInterval(interval);
    };
  }, [checkAndUpdateStatuses, currentUser, accountData, data.length]);

  // ✅ FETCH ACCOUNT DATA
  const fetchAccountData = async () => {
    if (!currentUser?.id) return null;

    try {
      console.log(
        `🔍 [Fetch] Loading account data for user ${currentUser.id}...`
      );

      const response = await fetch(
        `http://localhost:9999/accounts/${currentUser.id}`
      );
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const accountData = await response.json();
      console.log(
        `✅ [Fetch] Account data loaded: ${
          accountData.events?.length || 0
        } events`
      );

      setAccountData(accountData);
      return accountData.events || [];
    } catch (error) {
      console.error('❌ [Fetch] Error loading account data:', error);
      return [];
    }
  };

  // ✅ LOAD EVENTS KHI CÓ USER
  useEffect(() => {
    const loadEvents = async () => {
      if (!currentUser) {
        setLoading(false);
        setData([]);
        return;
      }

      try {
        setLoading(true);
        const events = await fetchAccountData();

        const activeEvents = events.filter(event => event.active === true);
        console.log(`📊 [Load] ${activeEvents.length} active events loaded`);

        const sortedEvents = activeEvents.slice().reverse();
        setData(sortedEvents);

        // ✅ RESET PROCESSED STATUS TRACKING
        processedStatusRef.current.clear();
      } catch (error) {
        console.error('❌ [Load] Error loading events:', error);
        setData([]);
      } finally {
        setLoading(false);
      }
    };

    loadEvents();
  }, [currentUser]);

  // ✅ HÀM UPDATE EVENT TRONG ACCOUNT
  const updateEventInAccount = async (eventId, updatedEventData) => {
    try {
      if (!accountData) {
        throw new Error('Account data not available');
      }

      const eventIndex = accountData.events.findIndex(
        event => event.id === eventId
      );
      if (eventIndex === -1) {
        throw new Error('Event not found in account');
      }

      const updatedEvents = [...accountData.events];
      updatedEvents[eventIndex] = {
        ...updatedEvents[eventIndex],
        ...updatedEventData,
        lastModified: new Date().toISOString(),
      };

      const updatedAccount = {
        ...accountData,
        events: updatedEvents,
      };

      console.log(`🔄 [Update] Updating event ${eventId}...`);

      const response = await fetch(
        `http://localhost:9999/accounts/${accountData.id}`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(updatedAccount),
        }
      );

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      setAccountData(result);

      console.log(`✅ [Update] Event ${eventId} updated successfully`);
      return result;
    } catch (error) {
      console.error(`❌ [Update] Failed to update event ${eventId}:`, error);
      throw error;
    }
  };

  // ✅ HÀM HỦY SỰ KIỆN
  const handleCancelEvent = async eventId => {
    const isConfirmed = window.confirm(
      'Bạn có chắc chắn muốn hủy sự kiện này không? Sự kiện sẽ được đánh dấu là "Đã hủy" và không thể hoàn tác.'
    );
    if (!isConfirmed) return;

    try {
      const eventToUpdate = data.find(event => event.id === eventId);
      if (!eventToUpdate) {
        throw new Error('Event not found');
      }

      console.log(`🚫 [Cancel] Cancelling event: ${eventToUpdate.title}`);

      // ✅ UPDATE UI NGAY LẬP TỨC
      setData(prevData =>
        prevData.map(event =>
          event.id === eventId
            ? {
                ...event,
                status: 'cancelled',
                cancelledAt: new Date().toISOString(),
              }
            : event
        )
      );

      // ✅ UPDATE DATABASE
      await updateEventInAccount(eventId, {
        status: 'cancelled',
        cancelledAt: new Date().toISOString(),
      });

      // ✅ UPDATE PROCESSED STATUS
      processedStatusRef.current.set(eventId, 'cancelled');

      alert('Hủy sự kiện thành công!');
    } catch (error) {
      console.error('❌ Error cancelling event:', error);
      alert(`Có lỗi xảy ra khi hủy sự kiện: ${error.message}`);
    }
  };

  // ✅ HÀM XÓA MỀM
  const handleSoftDelete = async eventId => {
    const isConfirmed = window.confirm(
      'Bạn có chắc chắn muốn xóa sự kiện này không?'
    );
    if (!isConfirmed) return;

    try {
      const eventToUpdate = data.find(event => event.id === eventId);
      if (!eventToUpdate) {
        throw new Error('Event not found');
      }

      console.log(`🗑️ [Delete] Soft deleting event: ${eventToUpdate.title}`);

      // ✅ UPDATE UI NGAY LẬP TỨC
      setData(prevData => prevData.filter(event => event.id !== eventId));

      // ✅ UPDATE DATABASE
      await updateEventInAccount(eventId, {
        active: false,
        deletedAt: new Date().toISOString(),
      });

      // ✅ REMOVE FROM PROCESSED STATUS
      processedStatusRef.current.delete(eventId);

      alert('Xóa sự kiện thành công!');
    } catch (error) {
      console.error('❌ Error soft deleting event:', error);
      alert(`Có lỗi xảy ra khi xóa sự kiện: ${error.message}`);
    }
  };

  // ✅ FILTER DATA
  useEffect(() => {
    let filtered = [...data];

    if (filters.search) {
      filtered = filtered.filter(
        event =>
          event.title?.toLowerCase().includes(filters.search.toLowerCase()) ||
          event.description
            ?.toLowerCase()
            .includes(filters.search.toLowerCase())
      );
    }

    if (filters.categories && filters.categories.length > 0) {
      filtered = filtered.filter(event => {
        return filters.categories.some(
          filterCat =>
            event.category?.toLowerCase() === filterCat.toLowerCase() ||
            (event.categories &&
              event.categories.some(
                eventCat => eventCat.toLowerCase() === filterCat.toLowerCase()
              ))
        );
      });
    }

    if (filters.status) {
      filtered = filtered.filter(
        event => event.status?.toLowerCase() === filters.status.toLowerCase()
      );
    }

    if (filters.startDate) {
      filtered = filtered.filter(event => {
        if (!event.startDate) return false;
        const eventDate = new Date(event.startDate).toISOString().split('T')[0];
        return eventDate >= filters.startDate;
      });
    }

    if (filters.endDate) {
      filtered = filtered.filter(event => {
        if (!event.startDate) return false;
        const eventDate = new Date(event.startDate).toISOString().split('T')[0];
        return eventDate <= filters.endDate;
      });
    }

    setFilteredData(filtered);
  }, [data, filters]);

  // ✅ UTILITY FUNCTIONS
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

  // ✅ GRID LAYOUT
  const GridLayout = () => (
    <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
      {filteredData.map((event, index) => {
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
            <div
              className="h-44 relative bg-cover bg-center bg-no-repeat flex-shrink-0"
              style={{ backgroundImage: `url(${categoryImage})` }}
            >
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"></div>

              <div className="absolute top-4 left-4 z-10">
                {event.category && (
                  <span className="px-3 py-1.5 bg-white/95 backdrop-blur-sm text-gray-800 rounded-full text-xs font-semibold capitalize shadow-lg border border-white/20">
                    {event.category}
                  </span>
                )}
              </div>

              <div className="absolute top-3 right-4 z-10">
                {getStatusBadge(event.status)}
              </div>

              <div className="absolute inset-0 bg-blue-600/0 group-hover:bg-blue-600/10 transition-all duration-300"></div>
            </div>

            <div className="p-6 flex flex-col flex-grow">
              <div className="h-6 mb-3 flex items-start">
                <h3 className="text-xl font-bold text-gray-900 line-clamp-2 group-hover:text-blue-600 transition-colors leading-tight">
                  {event.title || `Event ${index + 1}`}
                </h3>
              </div>

              <div className="h-8 mb-10">
                {event.description && (
                  <p className="text-gray-600 text-sm line-clamp-2 leading-relaxed">
                    {event.description}
                  </p>
                )}
              </div>

              <div className="space-y-3 mb-5 flex-grow">
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

                <div className="h-8 flex items-center">
                  <div className="flex items-center gap-3 text-sm text-gray-700">
                    <div className="w-8 h-8 bg-orange-50 rounded-lg flex items-center justify-center flex-shrink-0">
                      <UserCheck className="h-4 w-4 text-orange-600" />
                    </div>
                    <span className="font-medium">
                      Dự kiến: {formatCurrency(event.estimatedAttendees)} người
                    </span>
                  </div>
                </div>

                <div className="h-8 flex items-center">
                  <div className="flex items-center gap-3 text-sm text-gray-700">
                    <div className="w-8 h-8 bg-green-50 rounded-lg flex items-center justify-center flex-shrink-0">
                      <DollarSign className="h-4 w-4 text-green-600" />
                    </div>
                    <span className="font-medium">
                      Budget: {formatCurrency(event.budget) + ' ₫'}
                    </span>
                  </div>
                </div>
              </div>

              <div className="flex justify-center gap-1 pt-4 border-t border-gray-100 mt-auto">
                <button
                  onClick={() => navigate(`/read/${event.id}`)}
                  className="flex-1 p-3 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Xem chi tiết"
                >
                  <Eye className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                  <span className="text-sm font-medium">Xem</span>
                </button>
                <button
                  onClick={() => navigate(`/update/${event.id}`)}
                  className="flex-1 p-3 text-gray-500 hover:text-green-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Chỉnh sửa sự kiện"
                >
                  <Edit className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                  <span className="text-sm font-medium">Sửa</span>
                </button>
                <button
                  onClick={() => handleCancelEvent(event.id)}
                  className="flex-1 p-3 text-gray-500 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Hủy sự kiện"
                >
                  <span className="text-xs font-bold group-hover/btn:scale-110 transition-transform">
                    ✕
                  </span>
                  <span className="text-sm font-medium">Hủy</span>
                </button>
                <button
                  onClick={() => handleSoftDelete(event.id)}
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

  // ✅ LIST LAYOUT
  const ListLayout = () => (
    <div className="space-y-4">
      {filteredData.map((event, index) => {
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
                      <span>
                        {formatCurrency(event.estimatedAttendees)} người
                      </span>
                    </div>
                  )}

                  {event.budget && (
                    <div className="flex items-center gap-2">
                      <DollarSign className="h-4 w-4 text-green-600" />
                      <span>{formatCurrency(event.budget) + ' ₫'}</span>
                    </div>
                  )}
                </div>
              </div>

              <div className="flex items-center gap-2 flex-shrink-0">
                <button
                  onClick={() => navigate(`/read/${event.id}`)}
                  className="p-3 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Xem chi tiết"
                >
                  <Eye className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
                <button
                  onClick={() => navigate(`/update/${event.id}`)}
                  className="p-3 text-gray-500 hover:text-green-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Chỉnh sửa sự kiện"
                >
                  <Edit className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
                <button
                  onClick={() => handleCancelEvent(event.id)}
                  className="p-2 text-gray-500 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition-all duration-200 group/btn"
                  title="Hủy sự kiện"
                >
                  <span className="text-sm font-bold group-hover/btn:scale-110 transition-transform">
                    ✕
                  </span>
                </button>
                <button
                  onClick={() => handleSoftDelete(event.id)}
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

  // ✅ LOADING STATE
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
          Vui lòng đăng nhập để xem danh sách sự kiện của bạn
        </p>
      </div>
    );
  }

  if (loading) {
    return (
      <div>
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">
            Danh sách sự kiện
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
          {[1, 2, 3, 4, 5, 6].map(i => (
            <div
              key={i}
              className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden animate-pulse"
            >
              {viewMode === 'grid' ? (
                <>
                  <div className="h-40 bg-gradient-to-r from-gray-200 to-gray-300"></div>
                  <div className="p-6 space-y-4">
                    <div className="h-5 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-3/4"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-full"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-1/2"></div>
                    <div className="h-4 bg-gradient-to-r from-gray-200 to-gray-300 rounded w-2/3"></div>
                    <div className="h-10 bg-gradient-to-r from-gray-200 to-gray-300 rounded"></div>
                  </div>
                </>
              ) : (
                <div className="flex items-center p-6 gap-6">
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

  if (filteredData.length === 0 && !loading) {
    return (
      <div className="text-center py-12">
        <div className="w-24 h-24 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
          <Calendar className="h-12 w-12 text-gray-400" />
        </div>
        <h3 className="text-lg font-semibold text-gray-900 mb-2">
          {data.length === 0
            ? 'Bạn chưa có sự kiện nào'
            : 'Không tìm thấy sự kiện phù hợp'}
        </h3>
        <p className="text-gray-600">
          {data.length === 0
            ? 'Hãy tạo sự kiện đầu tiên của bạn!'
            : 'Thử thay đổi bộ lọc để xem thêm sự kiện'}
        </p>
      </div>
    );
  }

  // ✅ MAIN RENDER
  return (
    <div>
      {/* Header với smart monitoring status */}
      <div className="mb-4">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">
              Danh sách sự kiện
            </h2>
            <p className="text-gray-600">
              {filteredData.length} sự kiện{' '}
              {data.length !== filteredData.length &&
                `(từ ${data.length} sự kiện)`}
            </p>
          </div>

          {/* ✅ SMART MONITORING INDICATORS */}
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 text-sm text-green-600">
              <div className="w-2 h-2 bg-green-500 rounded-full"></div>
              <span>Smart Monitor</span>
            </div>

            {isUpdatingRef.current && (
              <div className="flex items-center gap-2 text-sm text-blue-600">
                <div className="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></div>
                <span>Syncing DB...</span>
              </div>
            )}

            <div className="text-xs text-gray-500">
              Tracked: {processedStatusRef.current.size}/{data.length}
            </div>
          </div>
        </div>

        {/* ✅ STATUS SUMMARY BAR */}
        <div className="mt-4 flex flex-wrap gap-3 items-center">
          {['preparing', 'upcoming', 'ongoing', 'completed', 'cancelled'].map(
            status => {
              const count = filteredData.filter(
                e => e.status === status
              ).length;
              if (count === 0) return null;

              return (
                <div key={status} className="flex items-center gap-2">
                  {getStatusBadge(status)}
                  <span className="text-sm font-medium text-gray-600">
                    {count}
                  </span>
                </div>
              );
            }
          )}
        </div>
      </div>

      {/* ✅ RENDER LAYOUT */}
      {viewMode === 'grid' ? <GridLayout /> : <ListLayout />}
    </div>
  );
};

export default EventList;
