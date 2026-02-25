// components/Sidebar.js
'use client';

import { usePathname, useRouter } from 'next/navigation';
import Link from 'next/link';
import { logout } from '../lib/auth';
import NotificationBell from './NotificationBell';
import { 
  Building2, 
  Users, 
  ChevronLeft, 
  ChevronRight, 
  LogOut,
  Table2,
  FileDown
} from 'lucide-react';

export default function Sidebar({ user, isOpen, onToggle }) {
  const router = useRouter();
  const pathname = usePathname();
  const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost/tareas/backend/public/api/v1';

  const menuItems = [
    { 
      href: '/my-tasks/', 
      label: 'Mis Tareas', 
      icon: Table2
    },
  ];

  // Reportes adicionales solo para admin y lider_area
  if (user?.role === 'admin' || user?.role === 'lider_area') {
    menuItems.push({ 
      href: '/reports/download/', 
      label: 'Descargar Reportes', 
      icon: FileDown
    });
  }

  if (user?.role === 'admin') {
    menuItems.push(
      { 
        href: '/admin/areas/', 
        label: 'Areas', 
        icon: Building2
      },
      { 
        href: '/admin/users/', 
        label: 'Usuarios', 
        icon: Users
      }
    );
  }

  async function handleLogout() {
    try {
      await fetch(`${API_URL}/auth/logout`, {
        method: 'POST',
        credentials: 'include',
      });
    } catch (e) {
      // Error on logout
    } finally {
      logout();
    }
  }

  return (
    <>
      <aside className={`bg-slate-900 text-white transition-all duration-300 ease-in-out ${isOpen ? 'w-64' : 'w-[72px]'} flex flex-col`}>
        {/* Header */}
        <div className={`h-16 flex items-center border-b border-slate-800 ${isOpen ? 'px-4 justify-between' : 'px-2 justify-center'}`}>
          {isOpen ? (
            <>
              <div className="flex items-center gap-2.5">
                <img 
                  src="/logo.png?v=2" 
                  alt="Meridian Control" 
                  className="w-8 h-8 object-contain"
                />
                <span className="font-semibold text-base tracking-tight">Meridian Control</span>
              </div>
              <button 
                onClick={onToggle} 
                className="p-2 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition-colors focus:outline-none focus:ring-2 focus:ring-slate-600"
                aria-label="Colapsar menu"
              >
                <ChevronLeft className="w-5 h-5" strokeWidth={1.75} />
              </button>
            </>
          ) : (
            <button 
              onClick={onToggle} 
              className="p-2 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition-colors focus:outline-none focus:ring-2 focus:ring-slate-600"
              aria-label="Expandir menu"
            >
              <ChevronRight className="w-5 h-5" strokeWidth={1.75} />
            </button>
          )}
        </div>

        {/* Navegacion */}
        <nav className={`flex-1 ${isOpen ? 'px-3' : 'px-2'} pb-4 overflow-y-auto sidebar-scroll`}>
          {isOpen && (
            <p className="px-3 py-2 text-[11px] font-semibold text-slate-500 uppercase tracking-wider">
              Menu
            </p>
          )}
          <ul className="space-y-1">
            {menuItems.map(item => {
              const Icon = item.icon;
              // Normalizar pathname y href para comparar (con/sin trailing slash)
              const normalize = (p) => (p.endsWith('/') ? p.slice(0, -1) : p);
              const isActive = normalize(pathname) === normalize(item.href);
              
              return (
                <li key={item.href}>
            <Link
              href={item.href}
              prefetch={false}
                    className={`flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors ${
                      isActive 
                        ? 'bg-green-600/20 text-white' 
                        : 'text-slate-400 hover:text-white hover:bg-slate-800'
              } ${!isOpen ? 'justify-center' : ''}`}
              title={!isOpen ? item.label : ''}
            >
                    <Icon 
                      className={`w-5 h-5 flex-shrink-0 ${isActive ? 'text-green-400' : ''}`} 
                      strokeWidth={isActive ? 2 : 1.75} 
                    />
                    {isOpen && (
                      <span className={`text-sm ${isActive ? 'font-medium' : ''}`}>
                        {item.label}
              </span>
                    )}
            </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        {/* Usuario */}
        {user && (
          <div className={`border-t border-slate-800 ${isOpen ? 'p-4' : 'p-3'}`}>
            {isOpen ? (
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-slate-700 rounded-full flex items-center justify-center font-medium text-sm text-slate-200">
                  {user.name?.charAt(0).toUpperCase()}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-slate-200 truncate">{user.name}</p>
                  <p className="text-xs text-slate-500 capitalize">{user.role?.replace('_', ' ')}</p>
                </div>
                <button
                  onClick={handleLogout}
                  className="p-2 text-slate-500 hover:text-rose-400 hover:bg-slate-800 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-slate-600"
                  title="Cerrar sesion"
                >
                  <LogOut className="w-5 h-5" strokeWidth={1.75} />
                </button>
              </div>
            ) : (
              <div className="flex flex-col items-center gap-3">
                <div className="w-9 h-9 bg-slate-700 rounded-full flex items-center justify-center font-medium text-sm text-slate-200">
                  {user.name?.charAt(0).toUpperCase()}
                </div>
                <button
                  onClick={handleLogout}
                  className="p-2 text-slate-500 hover:text-rose-400 hover:bg-slate-800 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-slate-600"
                  title="Cerrar sesion"
                >
                  <LogOut className="w-5 h-5" strokeWidth={1.75} />
                </button>
              </div>
            )}
          </div>
        )}
      </aside>
    </>
  );
}
