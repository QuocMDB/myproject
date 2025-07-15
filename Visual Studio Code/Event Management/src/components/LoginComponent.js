import React, { useState } from 'react';
import { Link } from 'react-router-dom';

const LoginComponent = ({ onLoginSuccess }) => {
  const [formData, setFormData] = useState({
    username: '',
    password: '',
  });
  const [errors, setErrors] = useState({});
  const [isLoading, setIsLoading] = useState(false);

  const handleInputChange = e => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value,
    }));
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({
        ...prev,
        [name]: '',
      }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.username.trim()) {
      newErrors.username = 'Tên đăng nhập không được để trống';
    } else if (formData.username.trim().length < 3) {
      newErrors.username = 'Tên đăng nhập phải có ít nhất 3 ký tự';
    }

    if (!formData.password) {
      newErrors.password = 'Mật khẩu không được để trống';
    } else if (formData.password.length < 4) {
      newErrors.password = 'Mật khẩu phải có ít nhất 4 ký tự';
    }

    return newErrors;
  };

  // ✅ Authenticate user với thông báo lỗi chung
  const authenticateUser = async (username, password) => {
    try {
      console.log('🔍 [Login] Authenticating user:', username);

      // ✅ Tìm user bằng username trong accounts
      const response = await fetch(
        `http://localhost:9999/accounts?username=${username}`,
        {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
          },
        }
      );

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const accounts = await response.json();
      console.log('🔍 [Login] Found accounts:', accounts);

      // ✅ SỬA: Kiểm tra user tồn tại
      if (accounts.length === 0) {
        throw new Error('INVALID_CREDENTIALS'); // Dùng error code thay vì message cụ thể
      }

      const account = accounts[0];

      // ✅ SỬA: Kiểm tra password
      if (account.password !== password) {
        throw new Error('INVALID_CREDENTIALS'); // Dùng error code thay vì message cụ thể
      }

      console.log('✅ [Login] Authentication successful:', account);
      return account;
    } catch (error) {
      console.error('❌ [Login] Authentication failed:', error);

      // ✅ Nếu là lỗi xác thực, ném lại với code
      if (error.message === 'INVALID_CREDENTIALS') {
        throw error;
      }

      // ✅ Các lỗi khác (network, server) giữ nguyên
      throw error;
    }
  };

  const handleSubmit = async e => {
    e.preventDefault();

    const formErrors = validateForm();
    if (Object.keys(formErrors).length > 0) {
      setErrors(formErrors);
      return;
    }

    setIsLoading(true);
    setErrors({});

    try {
      console.log('🔄 [Login] Starting login process...');

      // ✅ Authenticate với API đúng endpoint
      const accountData = await authenticateUser(
        formData.username,
        formData.password
      );

      console.log('✅ [Login] Login successful, calling onLoginSuccess...');
      onLoginSuccess(accountData);
    } catch (error) {
      console.error('❌ [Login] Login failed:', error);

      let errorMessage;

      // ✅ SỬA: Tất cả lỗi xác thực đều hiển thị thông báo chung
      if (error.message === 'INVALID_CREDENTIALS') {
        errorMessage = 'Tài khoản hoặc mật khẩu sai';
      } else if (
        error.message.includes('fetch') ||
        error.message.includes('HTTP error')
      ) {
        errorMessage = 'Không thể kết nối đến server. Vui lòng thử lại.';
      } else {
        // ✅ Các lỗi khác cũng hiển thị thông báo chung để bảo mật
        errorMessage = 'Tài khoản hoặc mật khẩu sai';
      }

      setErrors({ submit: errorMessage });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div className="bg-white rounded-lg shadow-md p-8">
          <div className="text-center mb-8">
            <h2 className="text-3xl font-bold text-gray-900">Đăng nhập</h2>
            <p className="mt-2 text-sm text-gray-600">
              Đăng nhập vào tài khoản của bạn
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            {errors.submit && (
              <div className="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-md">
                {errors.submit}
              </div>
            )}

            <div>
              <label
                htmlFor="username"
                className="block text-sm font-medium text-gray-700 mb-1"
              >
                Tên đăng nhập
              </label>
              <input
                id="username"
                name="username"
                type="text"
                value={formData.username}
                onChange={handleInputChange}
                className={`w-full px-3 py-2 border rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                  errors.username ? 'border-red-300' : 'border-gray-300'
                }`}
                placeholder="Nhập tên đăng nhập"
                autoComplete="username"
              />
              {errors.username && (
                <p className="mt-1 text-sm text-red-600">{errors.username}</p>
              )}
            </div>

            <div>
              <label
                htmlFor="password"
                className="block text-sm font-medium text-gray-700 mb-1"
              >
                Mật khẩu
              </label>
              <input
                id="password"
                name="password"
                type="password"
                value={formData.password}
                onChange={handleInputChange}
                className={`w-full px-3 py-2 border rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                  errors.password ? 'border-red-300' : 'border-gray-300'
                }`}
                placeholder="Nhập mật khẩu"
                autoComplete="current-password"
              />
              {errors.password && (
                <p className="mt-1 text-sm text-red-600">{errors.password}</p>
              )}
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {isLoading ? (
                <div className="flex items-center">
                  <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                  Đang đăng nhập...
                </div>
              ) : (
                'Đăng nhập'
              )}
            </button>
          </form>

          <div className="mt-6 text-center">
            <p className="text-sm text-gray-600">
              Chưa có tài khoản?{' '}
              <Link
                to="/register"
                className="font-medium text-blue-600 hover:text-blue-500"
              >
                Đăng ký ngay
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginComponent;
