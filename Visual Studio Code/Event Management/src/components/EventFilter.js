import React, { useState } from 'react';
import {
  Search,
  Filter,
  Calendar,
  Tag,
  CheckCircle,
  X,
  RotateCcw,
  CalendarArrowUp,
  CalendarArrowDown,
} from 'lucide-react';

const EventFilter = ({ onFilterChange, filters }) => {
  // State cho filters hiện tại đã áp dụng
  const [appliedFilters, setAppliedFilters] = useState({
    search: filters?.search || '',
    categories: filters?.categories || [],
    status: filters?.status || '',
    startDate: filters?.startDate || '',
    endDate: filters?.endDate || '',
    ...filters,
  });

  // State cho filters đang chỉnh sửa (chưa submit)
  const [localFilters, setLocalFilters] = useState({
    search: filters?.search || '',
    categories: filters?.categories || [],
    status: filters?.status || '',
    startDate: filters?.startDate || '',
    endDate: filters?.endDate || '',
    ...filters,
  });

  // Categories list
  const categories = [
    { value: 'technology', label: 'Technology' },
    { value: 'business', label: 'Business' },
    { value: 'education', label: 'Education' },
    { value: 'entertainment', label: 'Entertainment' },
    { value: 'sports', label: 'Sports' },
    { value: 'health', label: 'Health' },
    { value: 'internal', label: 'Internal' },
    { value: 'marketing', label: 'Marketing' },
    { value: 'training', label: 'Training' },
  ];

  // Status list
  const statuses = [
    { value: '', label: 'Tất cả trạng thái' },
    { value: 'preparing', label: 'Chuẩn bị' },
    { value: 'ongoing', label: 'Đang diễn ra' },
    { value: 'completed', label: 'Hoàn thành' },
    { value: 'cancelled', label: 'Đã hủy' },
  ];

  // Handle local filter change (không submit ngay)
  const handleLocalFilterChange = (key, value) => {
    setLocalFilters(prev => ({
      ...prev,
      [key]: value,
    }));
  };

  // Handle category checkbox change
  const handleCategoryChange = categoryValue => {
    const currentCategories = localFilters.categories || [];
    let newCategories;

    if (currentCategories.includes(categoryValue)) {
      newCategories = currentCategories.filter(cat => cat !== categoryValue);
    } else {
      newCategories = [...currentCategories, categoryValue];
    }

    handleLocalFilterChange('categories', newCategories);
  };

  // Submit filters - Áp dụng bộ lọc
  const handleSubmitFilters = () => {
    setAppliedFilters(localFilters);
    onFilterChange(localFilters);
  };

  // Reset all filters
  const resetFilters = () => {
    const resetFilters = {
      search: '',
      categories: [],
      status: '',
      startDate: '',
      endDate: '',
    };
    setLocalFilters(resetFilters);
    setAppliedFilters(resetFilters);
    onFilterChange(resetFilters);
  };

  // Check if any filter is active (applied)
  const hasActiveFilters =
    appliedFilters.search !== '' ||
    (appliedFilters.categories && appliedFilters.categories.length > 0) ||
    appliedFilters.status !== '' ||
    appliedFilters.startDate !== '' ||
    appliedFilters.endDate !== '';

  // Check if there are pending changes
  const hasPendingChanges =
    JSON.stringify(localFilters) !== JSON.stringify(appliedFilters);

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 h-fit sticky top-24">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center">
            <Filter className="h-4 w-4 text-blue-600" />
          </div>
          <h3 className="text-lg font-bold text-gray-900">Bộ lọc</h3>
        </div>

        {hasActiveFilters && (
          <button
            onClick={resetFilters}
            className="flex items-center gap-1 px-3 py-1.5 text-sm text-gray-600 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all duration-200"
            title="Xóa tất cả bộ lọc"
          >
            <RotateCcw className="h-3 w-3" />
            <span>Đặt lại</span>
          </button>
        )}
      </div>

      {/* Search */}
      <div className="mb-6">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          <Search className="h-4 w-4 inline mr-1" />
          Tìm kiếm sự kiện
        </label>
        <div className="relative">
          <input
            type="text"
            placeholder="Nhập tên sự kiện..."
            value={localFilters.search}
            onChange={e => handleLocalFilterChange('search', e.target.value)}
            className="w-full pl-10 pr-10 py-2.5 border border-gray-300 rounded-lg text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
          />
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Search className="h-4 w-4 text-gray-400" />
          </div>
          {localFilters.search && (
            <button
              onClick={() => handleLocalFilterChange('search', '')}
              className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600"
            >
              <X className="h-4 w-4" />
            </button>
          )}
        </div>
      </div>

      {/* Category Filter */}
      <div className="mb-6">
        <div className="flex items-center justify-between mb-3">
          <label className="block text-sm font-medium text-gray-700">
            <Tag className="h-4 w-4 inline mr-1" />
            Danh mục
          </label>
          {localFilters.categories && localFilters.categories.length > 0 && (
            <span className="text-xs text-blue-600 bg-blue-50 px-2 py-1 rounded-full">
              {localFilters.categories.length} đã chọn
            </span>
          )}
        </div>

        <div className="grid grid-cols-3 gap-1 max-h-48 overflow-y-auto">
          {categories.map(category => (
            <label
              key={category.value}
              className="flex items-center gap-1 p-1.5 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors duration-200"
            >
              <input
                type="checkbox"
                value={category.value}
                checked={
                  localFilters.categories?.includes(category.value) || false
                }
                onChange={() => handleCategoryChange(category.value)}
                className="w-3 h-3 text-blue-600 border-gray-300 focus:ring-blue-500 focus:ring-1"
              />
              <span className="text-xs text-gray-700 font-medium">
                {category.label}
              </span>
            </label>
          ))}
        </div>
      </div>

      {/* Status & Date Filters */}
      <div className="mb-6">
        <div className="grid grid-cols-3 gap-4">
          {/* Status Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <CheckCircle className="h-4 w-4 inline mr-1" />
              Trạng thái
            </label>
            <select
              value={localFilters.status}
              onChange={e => handleLocalFilterChange('status', e.target.value)}
              className="w-full px-2 py-2 border border-gray-300 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 bg-white"
            >
              {statuses.map(status => (
                <option key={status.value} value={status.value}>
                  {status.label}
                </option>
              ))}
            </select>
          </div>

          {/* Start Date */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <CalendarArrowUp className="h-4 w-4 inline mr-1" />
              Từ ngày
            </label>
            <div className="relative">
              <input
                type="date"
                value={localFilters.startDate}
                onChange={e =>
                  handleLocalFilterChange('startDate', e.target.value)
                }
                className="w-full px-2 py-2 border border-gray-300 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
              />
              {localFilters.startDate && (
                <button
                  onClick={() => handleLocalFilterChange('startDate', '')}
                  className="absolute inset-y-0 right-0 pr-2 flex items-center text-gray-400 hover:text-gray-600"
                >
                  <X className="h-3 w-3" />
                </button>
              )}
            </div>
          </div>

          {/* End Date */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <CalendarArrowDown className="h-4 w-4 inline mr-1" />
              Đến ngày
            </label>
            <div className="relative">
              <input
                type="date"
                value={localFilters.endDate}
                onChange={e =>
                  handleLocalFilterChange('endDate', e.target.value)
                }
                min={localFilters.startDate || undefined}
                className="w-full px-2 py-2 border border-gray-300 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
              />
              {localFilters.endDate && (
                <button
                  onClick={() => handleLocalFilterChange('endDate', '')}
                  className="absolute inset-y-0 right-0 pr-2 flex items-center text-gray-400 hover:text-gray-600"
                >
                  <X className="h-3 w-3" />
                </button>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Submit Button */}
      <div className="mb-6">
        <button
          onClick={handleSubmitFilters}
          disabled={!hasPendingChanges}
          className={`w-full py-3 px-4 rounded-lg font-medium text-sm transition-all duration-200 ${
            hasPendingChanges
              ? 'bg-blue-600 hover:bg-blue-700 text-white shadow-sm hover:shadow-md'
              : 'bg-gray-100 text-gray-400 cursor-not-allowed'
          }`}
        >
          {hasPendingChanges ? (
            <div className="flex items-center justify-center gap-2">
              <Filter className="h-4 w-4" />
              <span>Áp dụng bộ lọc</span>
            </div>
          ) : (
            <div className="flex items-center justify-center gap-2">
              <CheckCircle className="h-4 w-4" />
              <span>Bộ lọc đã được áp dụng</span>
            </div>
          )}
        </button>

        {hasPendingChanges && (
          <p className="text-xs text-amber-600 mt-2 text-center">
            Có thay đổi chưa được áp dụng. Nhấn nút để lọc kết quả.
          </p>
        )}
      </div>

      {/* Active Filters Summary - Hiển thị filters đã áp dụng */}
      {hasActiveFilters && (
        <div className="pt-4 border-t border-gray-100">
          <h4 className="text-sm font-medium text-gray-700 mb-2">
            Bộ lọc đang áp dụng:
          </h4>
          <div className="space-y-1 text-xs">
            {appliedFilters.search && (
              <div className="flex items-center gap-2 text-blue-600">
                <Search className="h-3 w-3" />
                <span>"{appliedFilters.search}"</span>
              </div>
            )}
            {appliedFilters.categories &&
              appliedFilters.categories.length > 0 && (
                <div className="flex items-start gap-2 text-green-600">
                  <Tag className="h-3 w-3 mt-0.5" />
                  <div className="flex flex-wrap gap-1">
                    {appliedFilters.categories.map(catValue => {
                      const category = categories.find(
                        c => c.value === catValue
                      );
                      return (
                        <span
                          key={catValue}
                          className="bg-green-50 text-green-700 px-2 py-0.5 rounded text-xs"
                        >
                          {category?.label}
                        </span>
                      );
                    })}
                  </div>
                </div>
              )}
            {appliedFilters.status && (
              <div className="flex items-center gap-2 text-orange-600">
                <CheckCircle className="h-3 w-3" />
                <span>
                  {statuses.find(s => s.value === appliedFilters.status)?.label}
                </span>
              </div>
            )}
            {(appliedFilters.startDate || appliedFilters.endDate) && (
              <div className="flex items-center gap-2 text-purple-600">
                <Calendar className="h-3 w-3" />
                <span>
                  {appliedFilters.startDate && appliedFilters.endDate
                    ? `${new Date(appliedFilters.startDate).toLocaleDateString(
                        'vi-VN'
                      )} - ${new Date(
                        appliedFilters.endDate
                      ).toLocaleDateString('vi-VN')}`
                    : appliedFilters.startDate
                    ? `Từ ${new Date(
                        appliedFilters.startDate
                      ).toLocaleDateString('vi-VN')}`
                    : `Đến ${new Date(
                        appliedFilters.endDate
                      ).toLocaleDateString('vi-VN')}`}
                </span>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default EventFilter;
