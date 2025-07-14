import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { useState } from 'react';
import './App.css';
import EventManagementDashboard from './components/EventManagementDashboard';
import EventList from './components/EventList';
import EventOverview from './components/EventOverview';
import Header from './components/Header';
import HomeEventList from './components/HomeEventList';
import EventFilter from './components/EventFilter';
import CreateForm from './components/CreateForm';
import SuccessCreateEvent from './components/SuccessCreateEvent';
import ReadEvent from './components/ReadEvent';
import UpdateEvent from './components/UpdateEvent';

function App() {
  // State để quản lý chế độ xem
  const [viewMode, setViewMode] = useState('grid');

  // ✅ THÊM: State để quản lý filters
  const [eventFilters, setEventFilters] = useState({
    search: '',
    categories: [],
    status: '',
    startDate: '',
    endDate: '',
  });

  // ✅ THÊM: Handle filter changes
  const handleFilterChange = newFilters => {
    setEventFilters(newFilters);
  };

  return (
    <BrowserRouter>
      <div
        className="min-h-screen bg-gray-50"
        style={{
          paddingLeft: '3cm',
          paddingRight: '3cm',
        }}
      >
        <Routes>
          <Route
            path="/"
            element={
              <div>
                <div>
                  <Header viewMode={viewMode} setViewMode={setViewMode} />
                </div>
                <div>
                  <EventOverview />
                </div>
                <div className="flex flex-col lg:flex-row gap-6 py-6">
                  <div className="flex-1">
                    <HomeEventList viewMode={viewMode} />
                  </div>
                </div>
              </div>
            }
          />
          <Route
            path="/eventlist"
            element={
              <div>
                <div>
                  <Header viewMode={viewMode} setViewMode={setViewMode} />
                </div>
                <div>
                  <EventOverview />
                </div>
                <div className="flex flex-col lg:flex-row gap-6 py-6">
                  <div className="flex-1 lg:w-2/3">
                    <EventList viewMode={viewMode} filters={eventFilters} />
                  </div>
                  <div className="lg:w-1/3 mt-32">
                    <EventFilter
                      onFilterChange={handleFilterChange}
                      filters={eventFilters}
                    />
                  </div>
                </div>
              </div>
            }
          />

          <Route
            path="/create"
            element={
              <div>
                <CreateForm />
              </div>
            }
          />

          <Route
            path="/successcreate"
            element={
              <div>
                <SuccessCreateEvent />
              </div>
            }
          />
          <Route path="/read/:id" element={<ReadEvent />} />
          <Route path="/update/:id" element={<UpdateEvent />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
