import { BrowserRouter, Route, Routes, Navigate } from 'react-router-dom';
import { useState, useEffect } from 'react';
import './App.css';
import EventList from './components/EventList';
import EventOverview from './components/EventOverview';
import Header from './components/Header';
import HomeEventList from './components/HomeEventList';
import EventFilter from './components/EventFilter';
import CreateForm from './components/CreateForm';
import SuccessCreateEvent from './components/SuccessCreateEvent';
import ReadEvent from './components/ReadEvent';
import UpdateEvent from './components/UpdateEvent';
import LoginComponent from './components/LoginComponent';
import RegisterComponent from './components/RegisterComponent';

function App() {
  // State để quản lý chế độ xem
  const [viewMode, setViewMode] = useState('grid');

  // ✅ State để quản lý authentication
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  // ✅ State để quản lý filters
  const [eventFilters, setEventFilters] = useState({
    search: '',
    categories: [],
    status: '',
    startDate: '',
    endDate: '',
  });

  // ✅ Fetch user info từ API với format nhất quán
  const fetchUserInfo = async userId => {
    try {
      console.log('🔍 [App] Fetching user info for ID:', userId);

      const response = await fetch(`http://localhost:9999/accounts/${userId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const userData = await response.json();
      console.log('✅ [App] User data fetched:', userData);

      return userData;
    } catch (error) {
      console.error('❌ [App] Error fetching user info:', error);
      throw error;
    }
  };

  // ✅ Update user login info và lấy user data
  const updateUserLoginInfo = async userId => {
    try {
      console.log('🔄 [App] Updating user login info for ID:', userId);

      const response = await fetch(`http://localhost:9999/accounts/${userId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          lastLogin: new Date().toISOString(),
          isActive: true,
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const userData = await response.json();
      console.log('✅ [App] User login info updated:', userData);

      return userData;
    } catch (error) {
      console.error('❌ [App] Error updating user login info:', error);
      // Fallback to just fetching user info
      return await fetchUserInfo(userId);
    }
  };

  // ✅ Verify user authentication
  const verifyUserAuth = async (userId, authToken) => {
    try {
      console.log('🔍 [App] Verifying user authentication...');

      const response = await fetch(`http://localhost:9999/accounts/${userId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const userData = await response.json();
      console.log('✅ [App] User authentication verified:', userData);

      return userData;
    } catch (error) {
      console.error('❌ [App] Error verifying user auth:', error);
      throw error;
    }
  };

  // ✅ Check authentication status khi app load
  useEffect(() => {
    const checkAuthStatus = async () => {
      try {
        const savedUserId = localStorage.getItem('currentUserId');
        const authToken = localStorage.getItem('authToken');

        console.log('🔍 [App] Checking auth status...');
        console.log('- Saved User ID:', savedUserId);
        console.log('- Auth Token:', authToken ? 'exists' : 'missing');

        if (savedUserId && authToken) {
          console.log('🔄 [App] Found saved credentials, verifying user...');

          try {
            // ✅ Verify auth và fetch user data
            const userData = await verifyUserAuth(savedUserId, authToken);

            setCurrentUser(userData);
            setIsAuthenticated(true);

            console.log('✅ [App] Authentication restored successfully');
          } catch (authError) {
            console.log(
              '⚠️ [App] Auth verification failed, trying simple fetch...'
            );

            // Fallback: chỉ fetch user info
            const userData = await fetchUserInfo(savedUserId);

            setCurrentUser(userData);
            setIsAuthenticated(true);

            console.log('✅ [App] Authentication restored via fallback');
          }
        } else {
          console.log('⚠️ [App] No saved credentials found');
        }
      } catch (error) {
        console.error('❌ [App] Error checking auth status:', error);

        // Clear invalid data
        localStorage.removeItem('currentUserId');
        localStorage.removeItem('authToken');
        localStorage.removeItem('currentUser'); // Clear old format if exists

        setCurrentUser(null);
        setIsAuthenticated(false);
      } finally {
        setIsLoading(false);
      }
    };

    checkAuthStatus();
  }, []);

  // ✅ Handle login success
  const handleLoginSuccess = async loginData => {
    try {
      console.log('🎉 [App] Login successful, processing user data...');
      console.log('- Login data:', loginData);

      let userData;
      let userId;

      // Xác định userId từ loginData
      if (loginData.id) {
        userId = loginData.id;
      } else if (loginData.userId) {
        userId = loginData.userId;
      } else if (loginData.email) {
        // Tìm user bằng email
        const response = await fetch(
          `http://localhost:9999/users?email=${loginData.email}`,
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

        const users = await response.json();
        if (users.length > 0) {
          userId = users[0].id;
        } else {
          throw new Error('User not found');
        }
      } else {
        throw new Error('Invalid login data - missing user identifier');
      }

      console.log('🔍 [App] Determined user ID:', userId);

      // ✅ Update login info và lấy user data
      userData = await updateUserLoginInfo(userId);

      console.log('✅ [App] User data processed:', userData);

      setCurrentUser(userData);
      setIsAuthenticated(true);

      // ✅ Lưu authentication info
      localStorage.setItem('currentUserId', userData.id);
      localStorage.setItem('authToken', 'authenticated_' + Date.now());
      localStorage.setItem('currentUser', JSON.stringify(userData));
      // Remove old format if exists
      localStorage.removeItem('currentUser');

      console.log('✅ [App] Login process completed successfully');
    } catch (error) {
      console.error('❌ [App] Error processing login:', error);
      alert('Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại.');
    }
  };

  // ✅ Handle logout với endpoint đúng
  const handleLogout = async () => {
    try {
      console.log('👋 [App] Logging out user...');

      if (currentUser?.id) {
        // ✅ Update user logout info với endpoint đúng
        await fetch(`http://localhost:9999/accounts/${currentUser.id}`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            lastLogout: new Date().toISOString(),
            isActive: false,
          }),
        });

        console.log('✅ [App] User logout info updated');
      }
    } catch (error) {
      console.error('❌ [App] Error updating logout info:', error);
      // Continue with logout even if update fails
    } finally {
      setCurrentUser(null);
      setIsAuthenticated(false);

      // Clear localStorage
      localStorage.removeItem('currentUserId');
      localStorage.removeItem('authToken');
      localStorage.removeItem('currentUser'); // Clear old format if exists

      console.log('✅ [App] Logout completed');
    }
  };

  // ✅ Handle filter changes
  const handleFilterChange = newFilters => {
    setEventFilters(newFilters);
  };

  // ✅ Protected Route Component
  const ProtectedRoute = ({ children }) => {
    if (isLoading) {
      return (
        <div className="min-h-screen flex items-center justify-center">
          <div className="text-center">
            <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
            <p className="text-gray-600">Đang tải thông tin người dùng...</p>
          </div>
        </div>
      );
    }

    return isAuthenticated ? children : <Navigate to="/login" replace />;
  };

  // ✅ Public Route Component (redirect to home if already logged in)
  const PublicRoute = ({ children }) => {
    if (isLoading) {
      return (
        <div className="min-h-screen flex items-center justify-center">
          <div className="text-center">
            <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
            <p className="text-gray-600">
              Đang kiểm tra trạng thái đăng nhập...
            </p>
          </div>
        </div>
      );
    }

    return isAuthenticated ? <Navigate to="/" replace /> : children;
  };

  // ✅ Debug info (có thể xóa sau khi test xong)
  useEffect(() => {
    console.log('🔍 [App] Current state:', {
      isAuthenticated,
      currentUser: currentUser
        ? {
            id: currentUser.id,
            email: currentUser.email,
            name: currentUser.name || currentUser.username,
            lastLogin: currentUser.lastLogin,
          }
        : null,
      isLoading,
    });
  }, [isAuthenticated, currentUser, isLoading]);

  return (
    <BrowserRouter>
      <div className="min-h-screen bg-gray-50">
        <Routes>
          {/* ✅ Public routes - Login & Register */}
          <Route
            path="/login"
            element={
              <PublicRoute>
                <LoginComponent onLoginSuccess={handleLoginSuccess} />
              </PublicRoute>
            }
          />
          <Route
            path="/register"
            element={
              <PublicRoute>
                <RegisterComponent />
              </PublicRoute>
            }
          />

          {/* ✅ Protected routes - Wrap with authentication */}
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <div style={{ paddingLeft: '3cm', paddingRight: '3cm' }}>
                  <div>
                    <Header
                      viewMode={viewMode}
                      setViewMode={setViewMode}
                      currentUser={currentUser}
                      onLogout={handleLogout}
                    />
                  </div>
                  <div>
                    <EventOverview currentUser={currentUser} />
                  </div>
                  <div className="flex flex-col lg:flex-row gap-6 py-6">
                    <div className="flex-1">
                      <HomeEventList
                        viewMode={viewMode}
                        currentUser={currentUser}
                      />
                    </div>
                  </div>
                </div>
              </ProtectedRoute>
            }
          />

          <Route
            path="/eventlist"
            element={
              <ProtectedRoute>
                <div style={{ paddingLeft: '3cm', paddingRight: '3cm' }}>
                  <div>
                    <Header
                      viewMode={viewMode}
                      setViewMode={setViewMode}
                      currentUser={currentUser}
                      onLogout={handleLogout}
                    />
                  </div>
                  <div>
                    <EventOverview currentUser={currentUser} />
                  </div>
                  <div className="flex flex-col lg:flex-row gap-6 py-6">
                    <div className="flex-1 lg:w-2/3">
                      <EventList
                        viewMode={viewMode}
                        filters={eventFilters}
                        currentUser={currentUser}
                      />
                    </div>
                    <div className="lg:w-1/3 mt-32">
                      <EventFilter
                        onFilterChange={handleFilterChange}
                        filters={eventFilters}
                      />
                    </div>
                  </div>
                </div>
              </ProtectedRoute>
            }
          />

          <Route
            path="/create"
            element={
              <ProtectedRoute>
                <CreateForm currentUser={currentUser} />
              </ProtectedRoute>
            }
          />

          <Route
            path="/successcreate"
            element={
              <ProtectedRoute>
                <SuccessCreateEvent />
              </ProtectedRoute>
            }
          />

          <Route
            path="/read/:id"
            element={
              <ProtectedRoute>
                <ReadEvent currentUser={currentUser} />
              </ProtectedRoute>
            }
          />

          <Route
            path="/update/:id"
            element={
              <ProtectedRoute>
                <UpdateEvent currentUser={currentUser} />
              </ProtectedRoute>
            }
          />

          {/* ✅ Redirect any unknown routes to home */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
