// components/Layout.js
'use client';

import { createContext, useContext, useEffect, useMemo, useState } from 'react';
import { usePathname, useRouter } from 'next/navigation';
import Sidebar from './Sidebar';
import { apiRequest, bootstrapAuth, getAccessToken } from '../lib/api';
import { Loader2 } from 'lucide-react';

const LayoutContext = createContext({
  user: null,
  isBootstrapping: true,
});

export function useLayoutContext() {
  return useContext(LayoutContext);
}

export default function Layout({ children }) {
  const router = useRouter();
  const pathname = usePathname();
  const [user, setUser] = useState(null);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [isBootstrapping, setIsBootstrapping] = useState(true);
  const contextValue = useMemo(
    () => ({
      user,
      isBootstrapping,
    }),
    [user, isBootstrapping]
  );

  useEffect(() => {
    if (pathname === '/login' || pathname === '/login/') {
      setIsBootstrapping(false);
      return;
    }
    
    let isMounted = true;
    
    async function bootstrap() {
      try {
        // 1. Si no hay token en memoria, intentar obtener desde refresh cookie
        if (!getAccessToken()) {
          await bootstrapAuth();
        }
        
        // 2. Obtener informacion del usuario
        const data = await apiRequest('/auth/me');
        if (isMounted) {
          setUser(data.data);
        }
      } catch (e) {
        // Solo redirigir si el componente sigue montado y no estamos ya en login
        if (isMounted && pathname !== '/login' && pathname !== '/login/') {
          router.push('/login/');
        }
      } finally {
        if (isMounted) {
          setIsBootstrapping(false);
        }
      }
    }
    
    bootstrap();
    
    return () => {
      isMounted = false;
    };
  }, [pathname, router]);

  if (pathname === '/login') {
    return <>{children}</>;
  }

  if (isBootstrapping) {
    return (
      <div className="flex h-screen items-center justify-center bg-[radial-gradient(circle_at_top,_rgba(16,185,129,0.12),_transparent_30%),linear-gradient(to_bottom,_#f8fafc,_#eef2f7)]">
        <div className="flex flex-col items-center gap-3 rounded-3xl border border-slate-200 bg-white/90 px-8 py-7 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.35)] backdrop-blur">
          <Loader2 className="h-10 w-10 animate-spin text-emerald-600" strokeWidth={1.75} />
          <p className="text-sm font-medium text-slate-600">Cargando tu espacio de trabajo...</p>
        </div>
      </div>
    );
  }

  return (
    <LayoutContext.Provider value={contextValue}>
      <div className="flex h-screen overflow-hidden bg-[radial-gradient(circle_at_top,_rgba(16,185,129,0.08),_transparent_24%),linear-gradient(to_bottom,_#f8fafc,_#eef2f7)]">
        <Sidebar user={user} isOpen={sidebarOpen} onToggle={() => setSidebarOpen(!sidebarOpen)} />
        <div className="flex-1 min-w-0 flex flex-col overflow-hidden">
          <header className="h-16 flex-shrink-0 border-b border-slate-200/80 bg-white/85 px-4 backdrop-blur sm:px-6">
            <div className="flex h-full items-center justify-between gap-4">
              <div className="min-w-0">
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-slate-400">
                  Production Analytics Reports
                </p>
                <h1 className="truncate text-sm font-semibold text-slate-900 sm:text-base">
                  {pathname?.startsWith('/admin')
                    ? 'Panel administrativo'
                    : pathname?.startsWith('/reports')
                    ? 'Centro de reportes'
                    : 'Mis actividades y reportes'}
                </h1>
              </div>
            
              <div className="flex items-center gap-3">
                {user && (
                  <div className="hidden items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50/80 px-3 py-2 shadow-sm sm:flex">
                    <div className="flex h-9 w-9 items-center justify-center rounded-2xl bg-gradient-to-br from-emerald-500 to-emerald-600 text-sm font-semibold text-white shadow-sm shadow-emerald-700/20">
                      {user.name?.charAt(0).toUpperCase()}
                    </div>
                    <div className="text-right">
                      <p className="text-sm font-semibold text-slate-900">{user.name}</p>
                      <p className="text-xs capitalize text-slate-500">{user.role?.replace('_', ' ')}</p>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </header>
          
          {/* Contenido principal */}
          <main className="flex-1 overflow-y-auto overflow-x-hidden">
            {children}
          </main>
          
          {/* Footer discreto */}
          <footer className="hidden h-8 flex-shrink-0 items-center justify-center border-t border-slate-200/70 bg-white/60 backdrop-blur lg:flex">
            <p className="text-[10px] text-slate-400/70 tracking-wide">
              <span className="text-slate-400/60">© {new Date().getFullYear()}</span>
              <span className="mx-1.5 text-slate-300">·</span>
              <span className="text-slate-400/60">Meridian Consulting</span>
              <span className="mx-1.5 text-slate-300">·</span>
              <span className="text-slate-400/50">Development By</span>
              <span className="ml-0.5 text-slate-400/60 font-normal">José Mateo López Cifuentes</span>
            </p>
          </footer>
        </div>
      </div>
    </LayoutContext.Provider>
  );
}
