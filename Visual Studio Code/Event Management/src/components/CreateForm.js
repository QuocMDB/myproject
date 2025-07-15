import React, { useState } from 'react';
import {
  Calendar,
  MapPin,
  Users,
  DollarSign,
  Plus,
  Trash2,
  AlertCircle,
  CheckCircle,
  Loader2,
  ArrowLeft,
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const CreateForm = () => {
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
    budget: '',
  };

  // State
  const [formData, setFormData] = useState(INITIAL_FORM_DATA);
  const [errors, setErrors] = useState({});
  const [showErrors, setShowErrors] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitSuccess, setSubmitSuccess] = useState(false);
  const navigate = useNavigate();

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

  // ✅ Lấy thông tin user hiện tại từ localStorage - VERSION FIXED
  const getCurrentUser = () => {
    try {
      console.log('🔍 [DEBUG] Checking localStorage for user data...');

      // Debug: In ra tất cả localStorage keys
      console.log(
        '📋 [DEBUG] All localStorage keys:',
        Object.keys(localStorage)
      );

      // Debug: Kiểm tra từng key có thể có
      const currentUser = localStorage.getItem('currentUser');
      const user = localStorage.getItem('user');
      const currentUserId = localStorage.getItem('currentUserId');
      const authToken = localStorage.getItem('authToken');

      console.log('🔍 [DEBUG] currentUser:', currentUser);
      console.log('🔍 [DEBUG] user:', user);
      console.log('🔍 [DEBUG] currentUserId:', currentUserId);
      console.log('🔍 [DEBUG] authToken:', authToken);

      // Thử parse currentUser trước
      if (currentUser) {
        console.log('✅ [DEBUG] Found currentUser, parsing...');
        const parsed = JSON.parse(currentUser);
        console.log('✅ [DEBUG] Parsed currentUser:', parsed);

        // ✅ ENSURE ID EXISTS
        if (!parsed.id && currentUserId) {
          parsed.id = currentUserId;
        }

        return parsed;
      }

      // Thử parse user
      if (user) {
        console.log('✅ [DEBUG] Found user, parsing...');
        const parsed = JSON.parse(user);
        console.log('✅ [DEBUG] Parsed user:', parsed);

        // ✅ ENSURE ID EXISTS
        if (!parsed.id && currentUserId) {
          parsed.id = currentUserId;
        }

        return parsed;
      }

      // Nếu có currentUserId nhưng không có currentUser, tạo object tạm
      if (currentUserId) {
        console.log(
          '⚠️ [DEBUG] Only found currentUserId, creating temp user object'
        );
        return {
          id: currentUserId,
          username: `user_${currentUserId}`, // fallback username
        };
      }

      console.log('❌ [DEBUG] No user data found in localStorage');
      return null;
    } catch (error) {
      console.error('❌ [DEBUG] Error getting current user:', error);
      return null;
    }
  };

  const getNextId = async currentUserAccount => {
    try {
      console.log(
        '🔍 [getNextId] Getting next ID for account:',
        currentUserAccount?.username || currentUserAccount?.id
      );

      // ✅ VALIDATE INPUT
      if (!currentUserAccount) {
        throw new Error('currentUserAccount is null or undefined');
      }

      if (!currentUserAccount.id) {
        throw new Error('currentUserAccount.id is missing');
      }

      // ✅ CHỈ LẤY ID TỪ EVENTS TRONG ACCOUNT HIỆN TẠI
      let maxId = 0;

      if (
        currentUserAccount.events &&
        Array.isArray(currentUserAccount.events) &&
        currentUserAccount.events.length > 0
      ) {
        currentUserAccount.events.forEach(event => {
          const eventId = parseInt(event.id) || 0;
          if (eventId > maxId) {
            maxId = eventId;
          }
        });
        console.log(
          `📊 [getNextId] Max ID in account "${currentUserAccount.username}": ${maxId}`
        );
      } else {
        console.log(
          `📊 [getNextId] No events found in account "${currentUserAccount.username}"`
        );
      }

      const nextId = maxId + 1;
      console.log(
        `✅ [getNextId] Next ID for account "${currentUserAccount.username}": ${nextId}`
      );

      // ✅ LƯU THEO ACCOUNT (OPTIONAL - để track riêng cho mỗi account)
      localStorage.setItem(
        `lastEventId_${currentUserAccount.id}`,
        nextId.toString()
      );

      return nextId.toString();
    } catch (error) {
      console.error('❌ [getNextId] Error:', error);

      // ✅ FALLBACK: LẤY TỪ LOCALSTORAGE THEO ACCOUNT
      const accountId = currentUserAccount?.id || 'unknown';
      const lastId = localStorage.getItem(`lastEventId_${accountId}`);
      const nextId = lastId ? parseInt(lastId) + 1 : 1;

      console.log(
        `🔄 [getNextId] Fallback ID for account "${
          currentUserAccount?.username || accountId
        }": ${nextId}`
      );
      localStorage.setItem(`lastEventId_${accountId}`, nextId.toString());

      return nextId.toString();
    }
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

    return {
      title: formData.title,
      description: formData.description,
      categories: allCategories,
      categoryIds: allCategoryIds,
      active: true,
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
      actualAttendees: null,
      budget: parseInt(formData.budget) || 0,
      status: 'preparing',
      lastStatusUpdate: new Date().toISOString(),
    };
  };

  const submitToBackend = async eventData => {
    try {
      // 1. Lấy thông tin user hiện tại
      const currentUser = getCurrentUser();
      if (!currentUser) {
        throw new Error('Vui lòng đăng nhập để tạo sự kiện');
      }

      console.log('🔍 Current user:', currentUser);
      console.log('🔍 Current user ID:', currentUser.id);
      console.log('🔍 Current user username:', currentUser.username);

      // ✅ VALIDATE USER DATA
      if (!currentUser.id && !currentUser.username) {
        throw new Error('Thông tin user không hợp lệ');
      }

      // 2. Lấy thông tin account từ database
      const accountsResponse = await fetch('http://localhost:9999/accounts');
      if (!accountsResponse.ok) {
        throw new Error('Không thể kết nối đến server');
      }

      const accounts = await accountsResponse.json();
      console.log(
        '📋 All accounts:',
        accounts.map(acc => ({ id: acc.id, username: acc.username }))
      );

      // 3. ✅ TÌM ACCOUNT - IMPROVED LOGIC
      let userAccount = null;

      // Thử tìm theo username trước
      if (currentUser.username) {
        userAccount = accounts.find(
          acc => acc.username === currentUser.username
        );
        console.log(
          `🔍 Search by username "${currentUser.username}":`,
          userAccount ? 'Found' : 'Not found'
        );
      }

      // Nếu không tìm thấy, thử tìm theo id
      if (!userAccount && currentUser.id) {
        userAccount = accounts.find(
          acc =>
            acc.id === currentUser.id.toString() || acc.id === currentUser.id
        );
        console.log(
          `🔍 Search by ID "${currentUser.id}":`,
          userAccount ? 'Found' : 'Not found'
        );
      }

      if (!userAccount) {
        console.error('❌ User account not found');
        console.error('Current user:', currentUser);
        console.error(
          'Available accounts:',
          accounts.map(acc => ({ id: acc.id, username: acc.username }))
        );

        throw new Error(
          `Không tìm thấy tài khoản của user: ${
            currentUser.username || currentUser.id
          }`
        );
      }

      console.log('✅ Found user account:', {
        id: userAccount.id,
        username: userAccount.username,
        eventsCount: userAccount.events?.length || 0,
      });

      // 4. ✅ TạO ID mới CHỈ DỰA TRÊN ACCOUNT HIỆN TẠI
      const nextId = await getNextId(userAccount);
      const eventWithId = { ...eventData, id: nextId };

      console.log(
        `🆔 [Create] New event ID: ${nextId} for account: ${userAccount.username}`
      );

      // 5. Thêm event vào danh sách events của account
      const updatedAccount = {
        ...userAccount,
        events: [...(userAccount.events || []), eventWithId],
      };

      // 6. Cập nhật account
      const response = await fetch(
        `http://localhost:9999/accounts/${userAccount.id}`,
        {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(updatedAccount),
        }
      );

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      console.log(
        `✅ Event created successfully for user: ${userAccount.username} with ID: ${nextId}`
      );

      return {
        success: true,
        id: eventWithId.id,
        message: 'Event created successfully',
        data: eventWithId,
      };
    } catch (error) {
      console.error('❌ Error creating event:', error);
      console.error('❌ Error stack:', error.stack);

      if (error.message.includes('Failed to fetch')) {
        throw new Error('Không thể kết nối đến JSON Server!');
      } else {
        throw new Error(`Lỗi tạo sự kiện: ${error.message}`);
      }
    }
  };

  // Validation functions
  const hasCategoryConflict = () => {
    return (
      formData.primaryCategory &&
      formData.additionalCategories.includes(formData.primaryCategory)
    );
  };

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
          id => id.toString() !== categoryId
        ),
      }));
    }
  };

  const resetForm = () => {
    setFormData(INITIAL_FORM_DATA);
    setErrors({});
    setShowErrors(false);
  };

  const handleSubmit = async e => {
    e.preventDefault();
    console.log('🚀 [DEBUG] Form submission started');

    setShowErrors(true);
    setSubmitSuccess(false);

    // ✅ Kiểm tra đăng nhập trước khi tạo event - VERSION DEBUG
    console.log('🔍 [DEBUG] Checking authentication...');
    const currentUser = getCurrentUser();

    console.log('👤 [DEBUG] Current user result:', currentUser);
    console.log('👤 [DEBUG] Current user type:', typeof currentUser);
    console.log('👤 [DEBUG] Is user null?', currentUser === null);
    console.log('👤 [DEBUG] Is user undefined?', currentUser === undefined);
    console.log('👤 [DEBUG] Boolean check:', !!currentUser);

    if (!currentUser) {
      console.log('❌ [DEBUG] No user found, redirecting to login');
      alert('Vui lòng đăng nhập để tạo sự kiện');
      navigate('/login');
      return;
    }

    console.log(
      '✅ [DEBUG] User authenticated, proceeding with form validation'
    );

    if (validateForm()) {
      console.log('✅ [DEBUG] Form validation passed');
      setIsSubmitting(true);

      try {
        const backendData = prepareDataForBackend();
        console.log('📦 [DEBUG] Prepared backend data:', backendData);

        const result = await submitToBackend(backendData);
        console.log('✅ [DEBUG] Submit result:', result);

        if (result.success) {
          setSubmitSuccess(true);
          setTimeout(() => {
            navigate('/successcreate');
            resetForm();
            setSubmitSuccess(false);
          }, 500);
        }
      } catch (error) {
        console.error('❌ [DEBUG] Submit error:', error);
        alert(error.message);
      } finally {
        setIsSubmitting(false);
      }
    } else {
      console.log('❌ [DEBUG] Form validation failed');
    }
  };

  return (
    <div className="max-w-4xl mx-auto p-6">
      {/* Header */}
      <div className="mb-6">
        <button
          onClick={() => navigate(`/`)}
          className="inline-flex items-center gap-2 px-4 py-2 text-gray-600 hover:text-gray-900 hover:bg-white rounded-lg transition-all duration-200 border border-gray-200 hover:border-gray-300"
        >
          <ArrowLeft className="h-4 w-4" />
          Quay lại
        </button>
      </div>

      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">
          Tạo Sự Kiện Mới
        </h1>
        <p className="text-gray-600">
          Điền thông tin chi tiết để tạo sự kiện mới
        </p>
      </div>

      {/* Success Message */}
      {submitSuccess && (
        <div className="mb-6 bg-green-50 border border-green-200 rounded-xl p-4">
          <div className="flex items-center space-x-2 text-green-800">
            <CheckCircle size={20} />
            <span className="font-medium">Tạo sự kiện thành công!</span>
          </div>
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
                onChange={e => handleInputChange('description', e.target.value)}
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
          <h2 className="text-xl font-semibold mb-4 text-gray-800">Danh Mục</h2>

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
                  <option key={cat.id} value={cat.id}>
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
              <div className="grid grid-cols-3 gap-2">
                {CATEGORIES.map(cat => {
                  const isDisabled =
                    formData.primaryCategory === cat.id.toString();
                  const isChecked =
                    formData.additionalCategories.includes(cat.id) &&
                    !isDisabled;

                  return (
                    <label key={cat.id} className="flex items-center space-x-2">
                      <input
                        type="checkbox"
                        checked={isChecked}
                        onChange={() => handleCategoryChange(cat.id, true)}
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
                <p className="text-red-500 text-sm mt-1">{errors.startTime}</p>
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
                value={formData.location.venue}
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
                value={formData.location.address}
                onChange={e =>
                  handleInputChange('location.address', e.target.value)
                }
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Địa chỉ chi tiết"
              />
            </div>

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

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Người tổ chức <span className="text-red-500">*</span>
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
                <p className="text-red-500 text-sm mt-1">{errors.organizer}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2 flex items-center">
                <Users className="mr-1" size={16} />
                Ước tính người tham gia <span className="text-red-500">*</span>
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

        {/* Submit Button */}
        <div className="flex justify-end space-x-4">
          <button
            type="button"
            onClick={resetForm}
            className="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
          >
            Reset Form
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
                <span>Đang tạo...</span>{' '}
              </>
            ) : (
              <>
                <CheckCircle size={16} />
                <span>Tạo Sự Kiện</span>
              </>
            )}
          </button>
        </div>
      </form>
    </div>
  );
};

export default CreateForm;
