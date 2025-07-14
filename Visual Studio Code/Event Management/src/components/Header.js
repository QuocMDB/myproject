import React, { useState } from 'react';
import { useLocation, Link } from 'react-router-dom';
import {
  Search,
  Menu,
  X,
  Calendar,
  Home,
  Plus,
  Filter,
  Grid3X3,
  List,
  ExternalLink, // Đổi tên Link từ lucide-react thành ExternalLink
} from 'lucide-react';

const Header = ({ viewMode, setViewMode }) => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const location = useLocation(); // Thêm dòng này để sử dụng useLocation

  // Navigation items - xóa thuộc tính active cứng
  const navItems = [
    { name: 'Trang chủ', href: '/', icon: Home },
    { name: 'Sự kiện', href: '/eventlist', icon: Calendar },
  ];

  // Hàm check active dựa trên URL
  const isActive = href => {
    if (href === '/') {
      return location.pathname === '/';
    }
    return location.pathname.startsWith(href);
  };

  return (
    <header className="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-50 w-full">
      <div className="w-full px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Left side - Logo & Navigation */}
          <div className="flex items-center space-x-8">
            {/* Logo */}
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <Calendar className="h-5 w-5 text-white" />
              </div>
              <h1 className="text-xl font-bold text-gray-900">EventHub</h1>
            </div>

            {/* Desktop Navigation */}
            <nav className="hidden md:flex space-x-6">
              {navItems.map(item => {
                const IconComponent = item.icon;
                const active = isActive(item.href); // Sử dụng hàm isActive

                return (
                  <Link
                    key={item.name}
                    to={item.href} // Sử dụng 'to' thay vì 'href' cho React Router Link
                    className={`flex items-center space-x-2 px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                      active
                        ? 'bg-blue-50 text-blue-700'
                        : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
                    }`}
                  >
                    <IconComponent className="h-4 w-4" />
                    <span>{item.name}</span>
                  </Link>
                );
              })}
            </nav>
          </div>

          {/* Right side - Search, Actions */}
          <div className="flex items-center space-x-4">
            {/* View Mode Toggle */}
            <div className="hidden sm:flex items-center bg-gray-100 rounded-lg p-1">
              <button
                onClick={() => setViewMode('grid')}
                className={`p-2 rounded-md transition-colors ${
                  viewMode === 'grid'
                    ? 'bg-white text-blue-600 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
                title="Xem dạng lưới"
              >
                <Grid3X3 className="h-4 w-4" />
              </button>
              <button
                onClick={() => setViewMode('list')}
                className={`p-2 rounded-md transition-colors ${
                  viewMode === 'list'
                    ? 'bg-white text-blue-600 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
                title="Xem dạng danh sách"
              >
                <List className="h-4 w-4" />
              </button>
            </div>

            {/* Create Event Button */}
            <Link
              to="/create" // Sử dụng Link từ react-router-dom
              className="hidden sm:flex items-center space-x-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium"
            >
              <Plus className="h-4 w-4" />
              <span>Tạo sự kiện</span>
            </Link>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
