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
  const [localFilters, setLocalFilters] = useState({
    search: filters?.search || '',
    categories: filters?.categories || [], // Thay đổi từ category thành categories (array)
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

  // Handle filter change
  const handleFilterChange = (key, value) => {
    const newFilters = {
      ...localFilters,
      [key]: value,
    };
    setLocalFilters(newFilters);
    onFilterChange(newFilters);
  };

  // Handle category checkbox change
  const handleCategoryChange = categoryValue => {
    const currentCategories = localFilters.categories || [];
    let newCategories;

    if (currentCategories.includes(categoryValue)) {
      // Remove category if already selected
      newCategories = currentCategories.filter(cat => cat !== categoryValue);
    } else {
      // Add category if not selected
      newCategories = [...currentCategories, categoryValue];
    }

    handleFilterChange('categories', newCategories);
  };

  // Reset all filters
  const resetFilters = () => {
    const resetFilters = {
      search: '',
      categories: [], // Reset to empty array
      status: '',
      startDate: '',
      endDate: '',
    };
    setLocalFilters(resetFilters);
    onFilterChange(resetFilters);
  };

  // Check if any filter is active
  const hasActiveFilters =
    localFilters.search !== '' ||
    (localFilters.categories && localFilters.categories.length > 0) ||
    localFilters.status !== '' ||
    localFilters.startDate !== '' ||
    localFilters.endDate !== '';

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
            onChange={e => handleFilterChange('search', e.target.value)}
            className="w-full pl-10 pr-10 py-2.5 border border-gray-300 rounded-lg text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
          />
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Search className="h-4 w-4 text-gray-400" />
          </div>
          {localFilters.search && (
            <button
              onClick={() => handleFilterChange('search', '')}
              className="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600"
            >
              <X className="h-4 w-4" />
            </button>
          )}
        </div>
      </div>

      {/* Category Filter - THAY ĐỔI THÀNH CHECKBOX */}
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

      {/* Status & Date Filters - Same Row */}
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
              onChange={e => handleFilterChange('status', e.target.value)}
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
                onChange={e => handleFilterChange('startDate', e.target.value)}
                className="w-full px-2 py-2 border border-gray-300 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
              />
              {localFilters.startDate && (
                <button
                  onClick={() => handleFilterChange('startDate', '')}
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
                onChange={e => handleFilterChange('endDate', e.target.value)}
                min={localFilters.startDate || undefined}
                className="w-full px-2 py-2 border border-gray-300 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
              />
              {localFilters.endDate && (
                <button
                  onClick={() => handleFilterChange('endDate', '')}
                  className="absolute inset-y-0 right-0 pr-2 flex items-center text-gray-400 hover:text-gray-600"
                >
                  <X className="h-3 w-3" />
                </button>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Active Filters Summary */}
      {hasActiveFilters && (
        <div className="pt-4 border-t border-gray-100">
          <h4 className="text-sm font-medium text-gray-700 mb-2">
            Bộ lọc đang áp dụng:
          </h4>
          <div className="space-y-1 text-xs">
            {localFilters.search && (
              <div className="flex items-center gap-2 text-blue-600">
                <Search className="h-3 w-3" />
                <span>"{localFilters.search}"</span>
              </div>
            )}
            {localFilters.categories && localFilters.categories.length > 0 && (
              <div className="flex items-start gap-2 text-green-600">
                <Tag className="h-3 w-3 mt-0.5" />
                <div className="flex flex-wrap gap-1">
                  {localFilters.categories.map(catValue => {
                    const category = categories.find(c => c.value === catValue);
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
            {localFilters.status && (
              <div className="flex items-center gap-2 text-orange-600">
                <CheckCircle className="h-3 w-3" />
                <span>
                  {statuses.find(s => s.value === localFilters.status)?.label}
                </span>
              </div>
            )}
            {(localFilters.startDate || localFilters.endDate) && (
              <div className="flex items-center gap-2 text-purple-600">
                <Calendar className="h-3 w-3" />
                <span>
                  {localFilters.startDate && localFilters.endDate
                    ? `${new Date(localFilters.startDate).toLocaleDateString(
                        'vi-VN'
                      )} - ${new Date(localFilters.endDate).toLocaleDateString(
                        'vi-VN'
                      )}`
                    : localFilters.startDate
                    ? `Từ ${new Date(localFilters.startDate).toLocaleDateString(
                        'vi-VN'
                      )}`
                    : `Đến ${new Date(localFilters.endDate).toLocaleDateString(
                        'vi-VN'
                      )}`}
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
