import React, { useState, useEffect } from 'react';
import {
  Calendar,
  MapPin,
  Users,
  DollarSign,
  AlertCircle,
  CheckCircle,
  Loader2,
  ArrowLeft,
  Tag,
  User,
  UserCheck,
  Save,
  X,
} from 'lucide-react';
import { useNavigate, useParams } from 'react-router-dom';

const UpdateEvent = () => {
  const { id } = useParams();
  const navigate = useNavigate();

  // Constants
  const CATEGORIES = [
    { id: 1, name: 'Technology' },
    { id: 2, name: 'Business' },
    { id: 3, name: 'Education' },
    { id: 4, name: 'Entertainment' },
    { id: 5, name: 'Sports' },
    { id: 6, name: 'Health' },
    { id: 7, name: 'Internal' },
    { id: 8, name: 'Marketing' },
    { id: 9, name: 'Training' },
  ];

  const INITIAL_FORM_DATA = {
    title: '',
    description: '',
    primaryCategory: '',
    additionalCategories: [],
    date: '',
    startTime: '',
    endTime: '',
    location: {
      venue: '',
      address: '',
      phone: '',
      email: '',
    },
    organizer: '',
    estimatedAttendees: '',
    actualAttendees: '',
    budget: '',
    status: '',
  };

  // State
  const [formData, setFormData] = useState(INITIAL_FORM_DATA);
  const [originalEvent, setOriginalEvent] = useState(null);
  const [errors, setErrors] = useState({});
  const [showErrors, setShowErrors] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitSuccess, setSubmitSuccess] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [loadError, setLoadError] = useState(null);

  // Fetch event data
  useEffect(() => {
    const fetchEvent = async () => {
      try {
        setIsLoading(true);
        setLoadError(null);

        const response = await fetch(`http://localhost:9999/events/${id}`);

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const eventData = await response.json();
        setOriginalEvent(eventData);

        // Convert event data to form format
        const startDate = eventData.startDate
          ? new Date(eventData.startDate)
          : null;
        const endDate = eventData.endDate ? new Date(eventData.endDate) : null;

        // Find primary category (first in the list)
        let primaryCategoryId = '';
        let additionalCategoryIds = [];

        if (eventData.categoryIds && eventData.categoryIds.length > 0) {
          primaryCategoryId = eventData.categoryIds[0].toString();
          additionalCategoryIds = eventData.categoryIds
            .slice(1)
            .map(catId => catId.toString());
        }

        setFormData({
          title: eventData.title || '',
          description: eventData.description || '',
          primaryCategory: primaryCategoryId,
          additionalCategories: additionalCategoryIds,
          date: startDate ? startDate.toISOString().split('T')[0] : '',
          startTime: startDate ? startDate.toTimeString().substring(0, 5) : '',
          endTime: endDate ? endDate.toTimeString().substring(0, 5) : '',
          location: {
            venue: eventData.location?.venue || '',
            address: eventData.location?.address || '',
            phone: eventData.location?.phone || '',
            email: eventData.location?.email || '',
          },
          organizer: eventData.organizer || '',
          estimatedAttendees: eventData.estimatedAttendees?.toString() || '',
          actualAttendees: eventData.actualAttendees?.toString() || '',
          budget: eventData.budget?.toString() || '',
          status: eventData.status || '',
        });
      } catch (error) {
        console.error('Error fetching event:', error);
        setLoadError(error.message);
      } finally {
        setIsLoading(false);
      }
    };

    if (id) {
      fetchEvent();
    }
  }, [id]);

  // Utility Functions
  const formatToISO = (date, time) => {
    if (!date || !time) return null;
    const dateTimeString = `${date}T${time}:00`;
    return new Date(dateTimeString).toISOString();
  };

  const getCategoryNames = categoryIds => {
    return categoryIds
      .map(id => {
        const category = CATEGORIES.find(cat => cat.id === parseInt(id));
        return category ? category.name : '';
      })
      .filter(name => name !== '');
  };

  // Data Preparation
  const prepareDataForBackend = () => {
    const startDate = formatToISO(formData.date, formData.startTime);
    const endDate = formatToISO(formData.date, formData.endTime);

    const allCategoryIds = [
      parseInt(formData.primaryCategory),
      ...formData.additionalCategories.map(id => parseInt(id)),
    ].filter(id => !isNaN(id));

    const allCategories = getCategoryNames(allCategoryIds);

    // Preserve fields that shouldn't be changed
    return {
      ...originalEvent,
      title: formData.title,
      description: formData.description,
      categories: allCategories,
      categoryIds: allCategoryIds,
      startDate,
      endDate,
      location: {
        venue: formData.location.venue || null,
        address: formData.location.address || null,
        phone: formData.location.phone || null,
        email: formData.location.email || null,
      },
      organizer: formData.organizer,
      estimatedAttendees: parseInt(formData.estimatedAttendees) || 0,
      actualAttendees: formData.actualAttendees
        ? parseInt(formData.actualAttendees)
        : null,
      budget: parseInt(formData.budget) || 0,
      // status is preserved from originalEvent
    };
  };

  // API Functions
  const submitToBackend = async eventData => {
    try {
      const response = await fetch(`http://localhost:9999/events/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(eventData),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      return {
        success: true,
        id: result.id,
        message: 'Event updated successfully',
        data: result,
      };
    } catch (error) {
      if (error.message.includes('Failed to fetch')) {
        throw new Error('Không thể kết nối đến JSON Server!');
      } else {
        throw new Error(`Lỗi cập nhật sự kiện: ${error.message}`);
      }
    }
  };

  // Validation
  const hasCategoryConflict = () => {
    return (
      formData.primaryCategory &&
      formData.additionalCategories.includes(formData.primaryCategory)
    );
  };

  // validate phone and email
  const validatePhone = phone => {
    if (!phone) return true;
    const digits = phone.replace(/\D/g, '');
    if (digits.length < 9 || digits.length > 11) {
      return false;
    }
    if (!digits.startsWith('0')) {
      return false;
    }
    return true;
  };

  const validateEmail = email => {
    if (!email) return true;
    const trimmedEmail = email.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(trimmedEmail)) {
      return false;
    }
    const domain = trimmedEmail.split('@')[1];
    const extension = domain.split('.').pop();
    if (extension.length < 2) {
      return false;
    }
    return true;
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.title.trim()) newErrors.title = 'Tiêu đề là bắt buộc';
    if (!formData.description.trim())
      newErrors.description = 'Mô tả là bắt buộc';
    if (!formData.primaryCategory)
      newErrors.primaryCategory = 'Danh mục chính là bắt buộc';
    if (!formData.date) newErrors.date = 'Ngày diễn ra là bắt buộc';
    if (!formData.startTime) newErrors.startTime = 'Giờ bắt đầu là bắt buộc';
    if (!formData.endTime) newErrors.endTime = 'Giờ kết thúc là bắt buộc';
    if (!formData.organizer.trim())
      newErrors.organizer = 'Người tổ chức là bắt buộc';
    if (!formData.estimatedAttendees || formData.estimatedAttendees <= 0) {
      newErrors.estimatedAttendees = 'Số người tham gia phải lớn hơn 0';
    }
    if (!formData.budget || formData.budget <= 0) {
      newErrors.budget = 'Ngân sách phải lớn hơn 0';
    }

    if (
      formData.startTime &&
      formData.endTime &&
      formData.startTime >= formData.endTime
    ) {
      newErrors.timeRange = 'Giờ kết thúc phải sau giờ bắt đầu';
    }

    if (hasCategoryConflict()) {
      newErrors.categoryConflict =
        'Danh mục bổ sung không được trùng với danh mục chính';
    }

    // validation cho phone và email
    if (formData.location.phone && !validatePhone(formData.location.phone)) {
      newErrors.phone =
        'Số điện thoại không hợp lệ (phải có 9-11 số và bắt đầu bằng 0)';
    }

    if (formData.location.email && !validateEmail(formData.location.email)) {
      newErrors.email = 'Địa chỉ email không hợp lệ';
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  // Event Handlers
  const handleInputChange = (field, value) => {
    if (field === 'description' && value.length > 80) return;

    if (field.startsWith('location.')) {
      const locationField = field.split('.')[1];
      setFormData(prev => ({
        ...prev,
        location: { ...prev.location, [locationField]: value },
      }));
    } else {
      setFormData(prev => ({ ...prev, [field]: value }));
    }
  };

  const handleCategoryChange = (categoryId, isAdditional = false) => {
    if (isAdditional) {
      setFormData(prev => ({
        ...prev,
        additionalCategories: prev.additionalCategories.includes(categoryId)
          ? prev.additionalCategories.filter(id => id !== categoryId)
          : [...prev.additionalCategories, categoryId],
      }));
    } else {
      setFormData(prev => ({
        ...prev,
        primaryCategory: categoryId,
        additionalCategories: prev.additionalCategories.filter(
          id => id !== categoryId
        ),
      }));
    }
  };

  const handleSubmit = async e => {
    e.preventDefault();
    setShowErrors(true);
    setSubmitSuccess(false);

    if (validateForm()) {
      setIsSubmitting(true);

      try {
        const backendData = prepareDataForBackend();
        const result = await submitToBackend(backendData);

        if (result.success) {
          setSubmitSuccess(true);
          setTimeout(() => {
            navigate(`/read/${id}`);
          }, 500);
        }
      } catch (error) {
        alert(error.message);
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  // Loading and Error states
  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Đang tải thông tin sự kiện...</p>
        </div>
      </div>
    );
  }

  if (loadError || !originalEvent) {
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
            {loadError || 'Sự kiện không tồn tại hoặc đã bị xóa'}
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

  return (
    <div className="min-h-screen bg-gray-50 pb-12">
      <div className="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-6 flex items-center justify-between">
          <div>
            <button
              onClick={() => navigate(-1)}
              className="inline-flex items-center gap-2 px-4 py-2 text-gray-600 hover:text-gray-900 hover:bg-white rounded-lg transition-all duration-200 border border-gray-200 hover:border-gray-300 mb-4"
            >
              <ArrowLeft className="h-4 w-4" />
              Quay lại
            </button>
            <h1 className="text-2xl font-bold text-gray-900">
              Chỉnh sửa sự kiện
            </h1>
            <p className="text-gray-600 mt-1">
              ID: {id} | Trạng thái:{' '}
              <span className="font-medium capitalize">{formData.status}</span>
            </p>
          </div>

          {/* Status Badge */}
          <div
            className={`px-4 py-2 rounded-full text-sm font-medium ${
              formData.status === 'completed'
                ? 'bg-green-100 text-green-800'
                : formData.status === 'cancelled'
                ? 'bg-red-100 text-red-800'
                : formData.status === 'ongoing'
                ? 'bg-blue-100 text-blue-800'
                : 'bg-gray-100 text-gray-800'
            }`}
          >
            {formData.status === 'completed'
              ? 'Hoàn thành'
              : formData.status === 'cancelled'
              ? 'Đã hủy'
              : formData.status === 'ongoing'
              ? 'Đang diễn ra'
              : formData.status}
          </div>
        </div>

        {/* Success Message */}
        {submitSuccess && (
          <div className="mb-6 bg-green-50 border border-green-200 rounded-xl p-4">
            <div className="flex items-center space-x-2 text-green-800">
              <CheckCircle size={20} />
              <span className="font-medium">Cập nhật sự kiện thành công!</span>
            </div>
            <p className="text-green-700 text-sm mt-1">
              Đang chuyển hướng về trang chi tiết...
            </p>
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Basic Information */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
            <h2 className="text-xl font-semibold mb-4 text-gray-800">
              Thông Tin Cơ Bản
            </h2>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Tiêu đề sự kiện <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  value={formData.title}
                  onChange={e => handleInputChange('title', e.target.value)}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.title
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                  placeholder="Nhập tiêu đề sự kiện"
                />
                {showErrors && errors.title && (
                  <p className="text-red-500 text-sm mt-1">{errors.title}</p>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Mô tả sự kiện <span className="text-red-500">*</span> (
                  {formData.description.length}/80)
                </label>
                <textarea
                  value={formData.description}
                  onChange={e =>
                    handleInputChange('description', e.target.value)
                  }
                  rows={4}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.description
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                  placeholder="Mô tả chi tiết về sự kiện"
                />
                {showErrors && errors.description && (
                  <p className="text-red-500 text-sm mt-1">
                    {errors.description}
                  </p>
                )}
              </div>
            </div>
          </div>

          {/* Categories */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
            <h2 className="text-xl font-semibold mb-4 text-gray-800 flex items-center">
              <Tag className="mr-2" size={20} />
              Danh Mục
            </h2>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Danh mục chính <span className="text-red-500">*</span>
                </label>
                <select
                  value={formData.primaryCategory}
                  onChange={e => handleCategoryChange(e.target.value)}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.primaryCategory
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                >
                  <option value="" disabled>
                    Chọn danh mục chính
                  </option>
                  {CATEGORIES.map(cat => (
                    <option key={cat.id} value={cat.id.toString()}>
                      {cat.name}
                    </option>
                  ))}
                </select>
                {showErrors && errors.primaryCategory && (
                  <p className="text-red-500 text-sm mt-1">
                    {errors.primaryCategory}
                  </p>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Danh mục bổ sung
                </label>
                <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
                  {CATEGORIES.map(cat => {
                    const isDisabled =
                      formData.primaryCategory === cat.id.toString();
                    const isChecked =
                      formData.additionalCategories.includes(
                        cat.id.toString()
                      ) && !isDisabled;

                    return (
                      <label
                        key={cat.id}
                        className="flex items-center space-x-2"
                      >
                        <input
                          type="checkbox"
                          checked={isChecked}
                          onChange={() =>
                            handleCategoryChange(cat.id.toString(), true)
                          }
                          disabled={isDisabled}
                          className={`rounded border-gray-300 text-blue-600 focus:ring-blue-500 ${
                            isDisabled ? 'opacity-50 cursor-not-allowed' : ''
                          }`}
                        />
                        <span
                          className={`text-sm ${
                            isDisabled ? 'text-gray-400' : 'text-gray-700'
                          }`}
                        >
                          {cat.name}
                        </span>
                      </label>
                    );
                  })}
                </div>

                {showErrors && errors.categoryConflict && (
                  <div className="flex items-center space-x-2 text-red-500 text-sm mt-2">
                    <AlertCircle size={16} />
                    <span>{errors.categoryConflict}</span>
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Date & Time */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
            <h2 className="text-xl font-semibold mb-4 text-gray-800 flex items-center">
              <Calendar className="mr-2" size={20} />
              Thời Gian
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Ngày diễn ra <span className="text-red-500">*</span>
                </label>
                <input
                  type="date"
                  value={formData.date}
                  onChange={e => handleInputChange('date', e.target.value)}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.date
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                />
                {showErrors && errors.date && (
                  <p className="text-red-500 text-sm mt-1">{errors.date}</p>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Giờ bắt đầu <span className="text-red-500">*</span>
                </label>
                <input
                  type="time"
                  value={formData.startTime}
                  onChange={e => handleInputChange('startTime', e.target.value)}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.startTime
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                />
                {showErrors && errors.startTime && (
                  <p className="text-red-500 text-sm mt-1">
                    {errors.startTime}
                  </p>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Giờ kết thúc <span className="text-red-500">*</span>
                </label>
                <input
                  type="time"
                  value={formData.endTime}
                  onChange={e => handleInputChange('endTime', e.target.value)}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.endTime
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                />
                {showErrors && errors.endTime && (
                  <p className="text-red-500 text-sm mt-1">{errors.endTime}</p>
                )}
              </div>
            </div>
            {showErrors && errors.timeRange && (
              <p className="text-red-500 text-sm mt-2">{errors.timeRange}</p>
            )}
          </div>

          {/* Location */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
            <h2 className="text-xl font-semibold mb-4 text-gray-800 flex items-center">
              <MapPin className="mr-2" size={20} />
              Địa Điểm
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Tên địa điểm
                </label>
                <input
                  type="text"
                  value={formData.location.venue || ''}
                  onChange={e =>
                    handleInputChange('location.venue', e.target.value)
                  }
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Tên khách sạn, trung tâm hội nghị..."
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Địa chỉ
                </label>
                <input
                  type="text"
                  value={formData.location.address || ''}
                  onChange={e =>
                    handleInputChange('location.address', e.target.value)
                  }
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Địa chỉ chi tiết"
                />
              </div>

              {/* Input số điện thoại */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Số điện thoại
                </label>
                <input
                  type="tel"
                  value={formData.location.phone || ''}
                  onChange={e =>
                    handleInputChange('location.phone', e.target.value)
                  }
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.phone
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                  placeholder="Số điện thoại liên hệ"
                />
                {showErrors && errors.phone && (
                  <p className="text-red-500 text-sm mt-1">{errors.phone}</p>
                )}
              </div>

              {/* Input email */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Email
                </label>
                <input
                  type="email"
                  value={formData.location.email || ''}
                  onChange={e =>
                    handleInputChange('location.email', e.target.value)
                  }
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.email
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                  placeholder="Email liên hệ"
                />
                {showErrors && errors.email && (
                  <p className="text-red-500 text-sm mt-1">{errors.email}</p>
                )}
              </div>
            </div>
          </div>

          {/* Event Details */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
            <h2 className="text-xl font-semibold mb-4 text-gray-800">
              Chi Tiết Sự Kiện
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
                  <User className="mr-1" size={16} />
                  Người phụ trách <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  value={formData.organizer}
                  onChange={e => handleInputChange('organizer', e.target.value)}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.organizer
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                  placeholder="Tên người/đơn vị tổ chức"
                />
                {showErrors && errors.organizer && (
                  <p className="text-red-500 text-sm mt-1">
                    {errors.organizer}
                  </p>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
                  <Users className="mr-1" size={16} />
                  Dự kiến tham gia <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  min="1"
                  value={formData.estimatedAttendees}
                  onChange={e =>
                    handleInputChange('estimatedAttendees', e.target.value)
                  }
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.estimatedAttendees
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                  placeholder="Số người"
                />
                {showErrors && errors.estimatedAttendees && (
                  <p className="text-red-500 text-sm mt-1">
                    {errors.estimatedAttendees}
                  </p>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
                  <UserCheck className="mr-1" size={16} />
                  Tham gia thực tế
                </label>
                <input
                  type="number"
                  min="0"
                  value={formData.actualAttendees}
                  onChange={e =>
                    handleInputChange('actualAttendees', e.target.value)
                  }
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Số người thực tế"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
                  <DollarSign className="mr-1" size={16} />
                  Ngân sách (VND) <span className="text-red-500">*</span>
                </label>
                <input
                  type="number"
                  min="0"
                  value={formData.budget}
                  onChange={e => handleInputChange('budget', e.target.value)}
                  className={`w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                    showErrors && errors.budget
                      ? 'border-red-500'
                      : 'border-gray-300'
                  }`}
                  placeholder="Ngân sách dự kiến"
                />
                {showErrors && errors.budget && (
                  <p className="text-red-500 text-sm mt-1">{errors.budget}</p>
                )}
              </div>
            </div>
          </div>

          {/* Submit Buttons */}
          <div className="flex justify-end space-x-4">
            <button
              type="button"
              onClick={() => navigate(`/read/${id}`)}
              className="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors flex items-center gap-2"
            >
              <X size={16} />
              <span>Hủy</span>
            </button>

            <button
              type="submit"
              disabled={isSubmitting}
              className={`px-8 py-3 rounded-lg font-medium transition-colors flex items-center space-x-2 ${
                isSubmitting
                  ? 'bg-gray-400 cursor-not-allowed'
                  : 'bg-blue-600 hover:bg-blue-700'
              } text-white`}
            >
              {isSubmitting ? (
                <>
                  <Loader2 size={16} className="animate-spin" />
                  <span>Đang cập nhật...</span>
                </>
              ) : (
                <>
                  <Save size={16} />
                  <span>Lưu thay đổi</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default UpdateEvent;
