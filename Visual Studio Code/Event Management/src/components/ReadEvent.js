import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Calendar,
  MapPin,
  Users,
  ArrowLeft,
  Clock,
  User,
  DollarSign,
  UserCheck,
  CheckCircle2,
  Phone,
  Mail,
  Tag,
} from 'lucide-react';

const ReadEvent = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [event, setEvent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchEvent = async () => {
      try {
        setLoading(true);
        const response = await fetch(`http://localhost:9999/events/${id}`);

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const eventData = await response.json();
        setEvent(eventData);
      } catch (error) {
        console.error('❌ Error fetching event:', error);
        setError(error.message);
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchEvent();
    }
  }, [id]);

  const formatDateTime = dateString => {
    if (!dateString) return 'Chưa xác định';
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

  const formatCurrency = amount => {
    if (amount === null || amount === undefined) return '0 ₫';
    return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
  };

  const getCategoryImage = categories => {
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

    if (!categories || !Array.isArray(categories) || categories.length === 0) {
      return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop';
    }

    // Try to find an image for the first category
    const firstCategory = categories[0].toLowerCase();
    return (
      images[firstCategory] ||
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop'
    );
  };

  const getStatusBadge = status => {
    if (!status) return null;

    const statusConfig = {
      completed: {
        text: 'Hoàn thành',
        class: 'bg-emerald-500 text-white shadow-lg border border-emerald-400',
        icon: <CheckCircle2 className="h-4 w-4" />,
      },
      preparing: {
        text: 'Chuẩn bị',
        class: 'bg-amber-500 text-white shadow-lg border border-amber-400',
        icon: <Clock className="h-4 w-4" />,
      },
      upcoming: {
        text: 'Sắp diễn ra',
        class: 'bg-purple-500 text-white shadow-lg border border-purple-400',
        icon: <Clock className="h-4 w-4" />,
      },
      ongoing: {
        text: 'Đang diễn ra',
        class: 'bg-blue-500 text-white shadow-lg border border-blue-400',
        icon: <span className="text-sm">▶</span>,
      },
      cancelled: {
        text: 'Đã hủy',
        class: 'bg-red-500 text-white shadow-lg border border-red-400',
        icon: <span className="text-sm">✕</span>,
      },
    };

    const config = statusConfig[status.toLowerCase()] || {
      text: status,
      class: 'bg-gray-500 text-white shadow-lg border border-gray-400',
      icon: null,
    };

    return (
      <span
        className={`inline-flex items-center gap-2 px-4 py-2 rounded-full text-sm font-bold ${config.class}`}
      >
        {config.icon}
        {config.text}
      </span>
    );
  };

  const formatLocation = location => {
    if (!location) return 'Chưa xác định địa điểm';
    if (typeof location === 'string') return location;

    const parts = [];
    if (location.venue) parts.push(location.venue);
    if (location.address) parts.push(location.address);

    return parts.length > 0 ? parts.join(', ') : 'Chưa xác định địa điểm';
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Đang tải thông tin sự kiện...</p>
        </div>
      </div>
    );
  }

  if (error || !event) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <span className="text-red-600 text-2xl">!</span>
          </div>
          <h2 className="text-xl font-semibold text-gray-900 mb-2">
            Không tìm thấy sự kiện
          </h2>
          <p className="text-gray-600 mb-4">
            {error || 'Sự kiện không tồn tại hoặc đã bị xóa'}
          </p>
          <button
            onClick={() => navigate(-1)}
            className="inline-flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            <ArrowLeft className="h-4 w-4" />
            Quay lại
          </button>
        </div>
      </div>
    );
  }

  const categoryImage = getCategoryImage(event.categories);

  return (
    <div className="min-h-screen bg-gray-50 pb-12">
      <div className="max-w-6xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        {/* Header với nút quay lại */}
        <div className="mb-6">
          <button
            onClick={() => navigate(`/eventlist`)}
            className="inline-flex items-center gap-2 px-4 py-2 text-gray-600 hover:text-gray-900 hover:bg-white rounded-lg transition-all duration-200 border border-gray-200 hover:border-gray-300"
          >
            <ArrowLeft className="h-4 w-4" />
            Quay lại
          </button>
        </div>

        {/* Main Content */}
        <div className="bg-white rounded-xl shadow-md border border-gray-200 overflow-hidden">
          {/* Tiêu đề, miêu tả và status */}
          <div className="p-6 md:p-8 border-b border-gray-200">
            <div className="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
              <div className="flex-1">
                <h1 className="text-2xl md:text-3xl font-bold text-gray-900 mb-3">
                  {event.title}
                </h1>
                {event.description && (
                  <p className="text-base md:text-lg text-gray-600 leading-relaxed">
                    {event.description}
                  </p>
                )}
              </div>
              <div className="md:ml-6 flex-shrink-0">
                {getStatusBadge(event.status)}
              </div>
            </div>
          </div>

          {/* Hàng chính: Ảnh (3 cột) + Thông tin (3 cột) */}
          <div className="p-6 md:p-8">
            <div className="grid grid-cols-1 lg:grid-cols-6 gap-6 md:gap-8">
              {/* Ảnh sự kiện - 3 cột */}
              <div className="lg:col-span-3">
                <div
                  className="w-full h-64 md:h-80 rounded-xl bg-cover bg-center bg-no-repeat shadow-md"
                  style={{ backgroundImage: `url(${categoryImage})` }}
                />
              </div>

              {/* Thông tin chi tiết - 3 cột */}
              <div className="lg:col-span-3 space-y-6">
                {/* Địa điểm */}
                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 bg-red-50 rounded-lg flex items-center justify-center flex-shrink-0">
                    <MapPin className="h-5 w-5 text-red-600" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-base font-semibold text-gray-900 mb-1">
                      Địa điểm
                    </h3>
                    <p className="text-gray-600">
                      {formatLocation(event.location)}
                    </p>
                    {event.location && typeof event.location === 'object' && (
                      <div className="mt-2 space-y-1 text-sm text-gray-500">
                        {event.location.phone && (
                          <div className="flex items-center gap-2">
                            <Phone className="h-3.5 w-3.5" />
                            <span>{event.location.phone}</span>
                          </div>
                        )}
                        {event.location.email && (
                          <div className="flex items-center gap-2">
                            <Mail className="h-3.5 w-3.5" />
                            <span>{event.location.email}</span>
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                </div>

                {/* Thời gian */}
                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                    <Calendar className="h-5 w-5 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-base font-semibold text-gray-900 mb-1">
                      Thời gian
                    </h3>
                    <div className="space-y-1">
                      <p className="text-gray-600">
                        <span className="font-medium">Bắt đầu:</span>{' '}
                        {formatDateTime(event.startDate)}
                      </p>
                      {event.endDate && (
                        <p className="text-gray-600">
                          <span className="font-medium">Kết thúc:</span>{' '}
                          {formatDateTime(event.endDate)}
                        </p>
                      )}
                    </div>
                  </div>
                </div>

                {/* Danh mục */}
                <div className="flex items-start gap-4">
                  <div className="w-10 h-10 bg-purple-50 rounded-lg flex items-center justify-center flex-shrink-0">
                    <Tag className="h-5 w-5 text-purple-600" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-base font-semibold text-gray-900 mb-1">
                      Danh mục
                    </h3>
                    {event.categories && event.categories.length > 0 ? (
                      <div className="flex flex-wrap gap-2">
                        {event.categories.map((category, index) => (
                          <span
                            key={index}
                            className="px-3 py-1 bg-gray-100 text-gray-700 rounded-md text-sm font-medium"
                          >
                            {category}
                          </span>
                        ))}
                      </div>
                    ) : (
                      <p className="text-gray-500">Chưa phân loại</p>
                    )}
                  </div>
                </div>
              </div>
            </div>

            {/* Hàng thông tin bổ sung */}
            <div className="mt-8 pt-6 border-t border-gray-200">
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                {/* Người phụ trách */}
                <div className="p-4 bg-gray-50 rounded-lg border border-gray-100">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                      <User className="h-5 w-5 text-green-600" />
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-gray-500">
                        Người phụ trách
                      </h4>
                      <p className="text-base font-semibold text-gray-900">
                        {event.organizer || 'Chưa xác định'}
                      </p>
                    </div>
                  </div>
                </div>

                {/* Người dự kiến */}
                <div className="p-4 bg-gray-50 rounded-lg border border-gray-100">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                      <Users className="h-5 w-5 text-blue-600" />
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-gray-500">
                        Dự kiến tham gia
                      </h4>
                      <p className="text-base font-semibold text-gray-900">
                        {event.estimatedAttendees || 0}{' '}
                        <span className="text-sm font-normal text-gray-500">
                          người
                        </span>
                      </p>
                    </div>
                  </div>
                </div>

                {/* Người tham gia thực sự */}
                <div className="p-4 bg-gray-50 rounded-lg border border-gray-100">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center">
                      <UserCheck className="h-5 w-5 text-orange-600" />
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-gray-500">
                        Tham gia thực tế
                      </h4>
                      <p className="text-base font-semibold text-gray-900">
                        {event.actualAttendees !== null
                          ? event.actualAttendees
                          : 'Chưa cập nhật'}
                        {event.actualAttendees !== null && (
                          <span className="text-sm font-normal text-gray-500">
                            {' '}
                            người
                          </span>
                        )}
                      </p>
                    </div>
                  </div>
                </div>

                {/* Budget */}
                <div className="p-4 bg-gray-50 rounded-lg border border-gray-100">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center">
                      <DollarSign className="h-5 w-5 text-emerald-600" />
                    </div>
                    <div>
                      <h4 className="text-sm font-medium text-gray-500">
                        Ngân sách
                      </h4>
                      <p className="text-base font-semibold text-gray-900">
                        {formatCurrency(event.budget)}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ReadEvent;
