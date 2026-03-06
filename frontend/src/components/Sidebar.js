// components/Sidebar.js
'use client';

import { usePathname, useRouter } from 'next/navigation';
import Link from 'next/link';
import Image from 'next/image';
import { logout } from '../lib/auth';
import NotificationBell from './NotificationBell';
import { 
  Users, 
  ChevronLeft, 
  ChevronRight, 
  LogOut,
  Table2,
  FileDown,
  ClipboardList
} from 'lucide-react';

export default function Sidebar({ user, isOpen, onToggle }) {
  const router = useRouter();
  const pathname = usePathname();
  const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost/ReportesEcopetrol/backend/public/api/v1';

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
    menuItems.push({
      href: '/admin/ods-activities/',
      label: 'Actividades ODS',
      icon: ClipboardList
    });
    menuItems.push({ 
      href: '/admin/users/', 
      label: 'Usuarios', 
      icon: Users
    });
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
      <aside className={`flex flex-col border-r border-slate-800/70 bg-gradient-to-b from-slate-950 via-slate-900 to-slate-900 text-white shadow-[18px_0_50px_-35px_rgba(15,23,42,0.9)] transition-all duration-300 ease-in-out ${isOpen ? 'w-72' : 'w-[84px]'}`}>
        {/* Header */}
        <div className={`flex h-20 items-center border-b border-slate-800/80 ${isOpen ? 'px-4 justify-between' : 'px-3 justify-center'}`}>
          {isOpen ? (
            <>
              <div className="flex items-center gap-2.5">
                <Image 
                  src="/logo.png?v=2" 
                  alt="Production Analytics Reports" 
                  width={40}
                  height={40}
                  className="h-10 w-10 rounded-2xl bg-white/5 p-1.5 object-contain"
                />
                <div className="min-w-0">
                  <span className="block truncate text-sm font-semibold tracking-tight text-white">Production Analytics Reports</span>
                  <span className="block text-[11px] uppercase tracking-[0.18em] text-slate-500">Workspace</span>
                </div>
              </div>
              <button 
                onClick={onToggle} 
                className="rounded-xl p-2 text-slate-400 transition-colors hover:bg-white/5 hover:text-white focus:outline-none focus:ring-2 focus:ring-slate-600"
                aria-label="Colapsar menu"
              >
                <ChevronLeft className="w-5 h-5" strokeWidth={1.75} />
              </button>
            </>
          ) : (
            <button 
              onClick={onToggle} 
              className="rounded-xl p-2 text-slate-400 transition-colors hover:bg-white/5 hover:text-white focus:outline-none focus:ring-2 focus:ring-slate-600"
              aria-label="Expandir menu"
            >
              <ChevronRight className="w-5 h-5" strokeWidth={1.75} />
            </button>
          )}
        </div>

        {/* Navegacion */}
        <nav className={`sidebar-scroll flex-1 overflow-y-auto pb-4 ${isOpen ? 'px-3 pt-4' : 'px-2 pt-4'}`}>
          {isOpen && (
            <p className="px-3 py-2 text-[11px] font-semibold uppercase tracking-[0.18em] text-slate-500">
              Navegación
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
                    className={`group flex items-center gap-3 rounded-2xl px-3 py-3 transition-all ${
                      isActive 
                        ? 'bg-emerald-500/15 text-white shadow-inner ring-1 ring-emerald-400/20' 
                        : 'text-slate-400 hover:bg-white/5 hover:text-white'
              } ${!isOpen ? 'justify-center' : ''}`}
              title={!isOpen ? item.label : ''}
            >
                    <Icon 
                      className={`w-5 h-5 flex-shrink-0 transition-colors ${isActive ? 'text-emerald-400' : 'group-hover:text-white'}`} 
                      strokeWidth={isActive ? 2 : 1.75} 
                    />
                    {isOpen && (
                      <span className={`text-sm ${isActive ? 'font-semibold' : 'font-medium'}`}>
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
          <div className={`border-t border-slate-800/80 ${isOpen ? 'p-4' : 'p-3'}`}>
            {isOpen ? (
              <div className="rounded-2xl border border-white/5 bg-white/[0.03] p-3 shadow-inner">
                <div className="mb-3 flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-2xl bg-gradient-to-br from-emerald-500 to-emerald-600 font-semibold text-sm text-white shadow-sm shadow-emerald-950/20">
                    {user.name?.charAt(0).toUpperCase()}
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-semibold text-slate-100">{user.name}</p>
                    <p className="text-xs capitalize text-slate-500">{user.role?.replace('_', ' ')}</p>
                  </div>
                  <NotificationBell />
                </div>
                <button
                  onClick={handleLogout}
                  className="flex w-full items-center justify-center gap-2 rounded-2xl border border-slate-700/80 bg-slate-900/60 px-3 py-2.5 text-sm font-medium text-slate-200 transition hover:border-rose-500/30 hover:bg-rose-500/10 hover:text-rose-200 focus:outline-none focus:ring-2 focus:ring-slate-600"
                  title="Cerrar sesion"
                >
                  <LogOut className="w-4 h-4" strokeWidth={1.75} />
                  Cerrar sesión
                </button>
              </div>
            ) : (
              <div className="flex flex-col items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-2xl bg-gradient-to-br from-emerald-500 to-emerald-600 font-semibold text-sm text-white">
                  {user.name?.charAt(0).toUpperCase()}
                </div>
                <NotificationBell />
                <button
                  onClick={handleLogout}
                  className="rounded-xl p-2 text-slate-500 transition-colors hover:bg-rose-500/10 hover:text-rose-300 focus:outline-none focus:ring-2 focus:ring-slate-600"
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
