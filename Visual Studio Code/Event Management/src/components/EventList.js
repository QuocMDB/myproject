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
import { useNavigate } from 'react-router-dom';

const EventList = ({ viewMode = 'grid', filters = {} }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filteredData, setFilteredData] = useState([]);
  const navigate = useNavigate();

  // ✅ HÀM UPDATE STATUS VÀO DATABASE
  const updateEventStatusInDB = async (eventId, newStatus) => {
    try {
      const response = await fetch(`http://localhost:9999/events/${eventId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          status: newStatus,
          lastStatusUpdate: new Date().toISOString(),
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const updatedEvent = await response.json();
      console.log(
        `✅ [EventList] Database updated: Event "${updatedEvent.title}" → ${newStatus}`
      );
      return updatedEvent;
    } catch (error) {
      console.error(
        `❌ [EventList] Failed to update event ${eventId} in database:`,
        error
      );
      throw error;
    }
  };

  // Auto-update status theo thời gian VÀ UPDATE DATABASE
  const updateEventStatuses = useCallback(async () => {
    const now = new Date();
    const eventsToUpdate = []; // Array để lưu các events cần update database

    setData(prevData => {
      const newData = prevData.map(event => {
        if (!event.active || event.status === 'cancelled' || !event.startDate) {
          return event;
        }

        const startTime = new Date(event.startDate);
        const endTime = new Date(event.endDate || event.startDate);

        // Tính thời gian còn lại đến khi bắt đầu
        const timeUntilStart = startTime - now;
        const hoursUntilStart = timeUntilStart / (1000 * 60 * 60); // Convert to hours

        let newStatus;

        if (now > endTime) {
          // Đã kết thúc
          newStatus = 'completed';
        } else if (now >= startTime && now <= endTime) {
          // Đang diễn ra
          newStatus = 'ongoing';
        } else if (hoursUntilStart <= 12 && hoursUntilStart > 0) {
          //Sắp đến giờ (trong vòng 12h)
          newStatus = 'upcoming';
        } else {
          // Còn lâu mới diễn ra
          newStatus = 'preparing';
        }

        // ✅ CHỈ UPDATE KHI STATUS THỰC SỰ THAY ĐỔI
        if (event.status !== newStatus) {
          console.log(
            `🔄 [EventList] Event "${event.title}" status: ${
              event.status
            } → ${newStatus} (${Math.round(hoursUntilStart)}h until start)`
          );

          // ✅ Thêm vào danh sách cần update database
          eventsToUpdate.push({
            id: event.id,
            title: event.title,
            oldStatus: event.status,
            newStatus: newStatus,
          });

          return { ...event, status: newStatus };
        }

        return event;
      });

      // ✅ UPDATE DATABASE CHO TẤT CẢ EVENTS CÓ THAY ĐỔI
      if (eventsToUpdate.length > 0) {
        Promise.allSettled(
          eventsToUpdate.map(eventUpdate =>
            updateEventStatusInDB(eventUpdate.id, eventUpdate.newStatus)
          )
        ).then(results => {
          const successful = results.filter(
            result => result.status === 'fulfilled'
          ).length;
          const failed = results.filter(
            result => result.status === 'rejected'
          ).length;

          console.log(
            `📊 [EventList] Database update summary: ${successful} successful, ${failed} failed`
          );

          // Log chi tiết các lỗi
          results.forEach((result, index) => {
            if (result.status === 'rejected') {
              console.error(
                `❌ [EventList] Failed to update ${eventsToUpdate[index].title}:`,
                result.reason
              );
            }
          });
        });
      }

      // ✅ CHỈ RETURN DATA MỚI KHI CÓ THAY ĐỔI
      return eventsToUpdate.length > 0 ? newData : prevData;
    });
  }, []);

  // ✅ useEffect cho auto-update với database sync
  useEffect(() => {
    // Cập nhật ngay khi component mount
    updateEventStatuses();

    // Thiết lập interval để cập nhật mỗi 30 giây (thay vì 0.5s)
    const interval = setInterval(() => {
      updateEventStatuses();
    }, 30000); // 30 giây

    // Cleanup khi component unmount
    return () => clearInterval(interval);
  }, [updateEventStatuses]);

  // ✅ Fetch data với retry logic
  const fetchEventsWithRetry = async (retries = 3) => {
    for (let i = 0; i < retries; i++) {
      try {
        const response = await fetch('http://localhost:9999/events');
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
      } catch (error) {
        console.error(`❌ [EventList] Fetch attempt ${i + 1} failed:`, error);
        if (i === retries - 1) throw error;
        await new Promise(resolve => setTimeout(resolve, 1000)); // Đợi 1s trước khi retry
      }
    }
  };

  useEffect(() => {
    const loadEvents = async () => {
      try {
        setLoading(true);
        const data = await fetchEventsWithRetry();

        // ✅ Chỉ lấy events có active = true
        const activeEvents = data.filter(event => event.active === true);
        console.log(
          `📊 [EventList] Loaded ${activeEvents.length} active events`
        );
        setData(activeEvents.slice().reverse());
      } catch (error) {
        console.error('❌ [EventList] Error fetching events:', error);
      } finally {
        setLoading(false);
      }
    };

    loadEvents();
  }, []);

  // Thêm hàm xử lý hủy sự kiện
  const handleCancelEvent = async eventId => {
    console.log('🔍 Event ID to cancel:', eventId, typeof eventId);

    const isConfirmed = window.confirm(
      'Bạn có chắc chắn muốn hủy sự kiện này không? Sự kiện sẽ được đánh dấu là "Đã hủy" và không thể hoàn tác.'
    );
    if (!isConfirmed) return;

    try {
      // Tìm event với ID
      const eventToUpdate = data.find(event => event.id === eventId);

      console.log('🔍 Event found:', eventToUpdate);

      if (!eventToUpdate) {
        console.error('❌ Event not found with ID:', eventId);
        alert('Không tìm thấy sự kiện!');
        return;
      }

      // Chuẩn bị dữ liệu update
      const updatedEvent = {
        ...eventToUpdate,
        status: 'cancelled',
        cancelledAt: new Date().toISOString(), // Thêm timestamp khi hủy
      };

      console.log('🔍 Updated event data:', updatedEvent);

      // Gửi request PUT
      const response = await fetch(`http://localhost:9999/events/${eventId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updatedEvent),
      });

      console.log('🔍 Response status:', response.status);

      if (!response.ok) {
        const errorText = await response.text();
        console.error('❌ Response error:', errorText);
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      console.log('✅ Cancel result:', result);

      // Cập nhật state local
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

      alert('Hủy sự kiện thành công!');
    } catch (error) {
      console.error('❌ Error cancelling event:', error);
      alert(`Có lỗi xảy ra khi hủy sự kiện: ${error.message}`);
    }
  };

  //xử lý xóa mềm
  const handleSoftDelete = async eventId => {
    console.log('🔍 Event ID to delete:', eventId, typeof eventId);

    const isConfirmed = window.confirm(
      'Bạn có chắc chắn muốn xóa sự kiện này không?'
    );
    if (!isConfirmed) return;

    try {
      // Tìm event với ID (giờ tất cả đều là number)
      const eventToUpdate = data.find(event => event.id === eventId);

      console.log('🔍 Event found:', eventToUpdate);

      if (!eventToUpdate) {
        console.error('❌ Event not found with ID:', eventId);
        alert('Không tìm thấy sự kiện!');
        return;
      }

      // Chuẩn bị dữ liệu update
      const updatedEvent = {
        ...eventToUpdate,
        active: false,
      };

      console.log('🔍 Updated event data:', updatedEvent);

      // Gửi request PUT
      const response = await fetch(`http://localhost:9999/events/${eventId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updatedEvent),
      });

      console.log('🔍 Response status:', response.status);

      if (!response.ok) {
        const errorText = await response.text();
        console.error('❌ Response error:', errorText);
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      console.log('✅ Update result:', result);

      // Cập nhật state local - loại bỏ event đã soft delete
      setData(prevData => prevData.filter(event => event.id !== eventId));

      alert('Xóa sự kiện thành công!');
    } catch (error) {
      console.error('❌ Error soft deleting event:', error);
      alert(`Có lỗi xảy ra khi xóa sự kiện: ${error.message}`);
    }
  };

  // Filter data based on filters
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
        // Kiểm tra xem event có ít nhất 1 category trùng với filter
        return filters.categories.every(
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

  // GRID LAYOUT COMPONENT
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
                  <div className="flex items-center gap-3 text-sm text-gray-700">
                    <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                      <Calendar className="h-4 w-4 text-blue-600" />
                    </div>
                    <span className="font-medium">
                      {formatDateTime(event.startDate)}
                    </span>
                  </div>
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
                  <div className="flex items-center gap-3 text-sm text-gray-700">
                    <div className="w-8 h-8 bg-orange-50 rounded-lg flex items-center justify-center flex-shrink-0">
                      <UserCheck className="h-4 w-4 text-orange-600" />
                    </div>
                    <span className="font-medium">
                      Dự kiến: {formatCurrency(event.estimatedAttendees)} người
                    </span>
                  </div>
                </div>

                {/* Budget - Luôn hiển thị, cố định chiều cao */}
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

              {/* Action Buttons - Luôn ở dưới cùng */}
              <div className="flex justify-center gap-2 pt-4 border-t border-gray-100 mt-auto">
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

  // LIST LAYOUT COMPONENT (giữ nguyên code của bạn)
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
              {/* Event Image */}
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

              {/* Event Content */}
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

              {/* Action Buttons */}
              <div className="flex items-center gap-2 flex-shrink-0">
                <button
                  onClick={() => navigate(`/read/${event.id}`)}
                  className="flex-1 p-3 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
                  title="Xem chi tiết"
                >
                  <Eye className="h-4 w-4 group-hover/btn:scale-110 transition-transform" />
                </button>
                <button
                  onClick={() => navigate(`/update/${event.id}`)}
                  className="flex-1 p-3 text-gray-500 hover:text-green-600 hover:bg-blue-50 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 group/btn"
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
            ? 'Chưa có sự kiện nào'
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

  return (
    <div>
      {/* Header với thông tin auto-update */}
      <div className="mb-4">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">
              Tất cả sự kiện
            </h2>
            <p className="text-gray-600">
              {filteredData.length} sự kiện{' '}
              {data.length !== filteredData.length &&
                `(từ ${data.length} sự kiện)`}
            </p>
          </div>
        </div>

        {/* Status summary bar */}
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

      {/* Render layout based on viewMode */}
      {viewMode === 'grid' ? <GridLayout /> : <ListLayout />}
    </div>
  );
};

export default EventList;
