// app/login/page.js
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { login } from '../../lib/auth';
import { apiRequest } from '../../lib/api';
import { Loader2, Mail, Lock, Eye, EyeOff, Shield, FileText, History, TrendingUp, CheckCircle } from 'lucide-react';
import Alert from '../../components/Alert';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const data = await apiRequest('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email, password }),
      });

      login(data.data.access_token, rememberMe);
      router.push('/my-tasks/');
    } catch (e) {
      setError(e.message || 'Error de autenticación. Por favor, verifica tus credenciales.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen flex">
      {/* Panel izquierdo - Branding */}
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-green-900 via-green-800 to-slate-900 relative overflow-hidden">
        {/* Patrón de fondo */}
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-0 left-0 w-96 h-96 bg-white rounded-full -translate-x-1/2 -translate-y-1/2"></div>
          <div className="absolute bottom-0 right-0 w-80 h-80 bg-white rounded-full translate-x-1/3 translate-y-1/3"></div>
          <div className="absolute top-1/2 left-1/2 w-64 h-64 bg-white rounded-full -translate-x-1/2 -translate-y-1/2"></div>
        </div>
        
        {/* Contenido del panel */}
        <div className="relative z-10 flex flex-col justify-between p-12 w-full">
          {/* Logo y título */}
          <div>
            <img
              src="/logo_meridian.png"
              alt="Meridian Consulting"
              className="h-12 w-auto object-contain brightness-0 invert"
            />
          </div>
          
          {/* Mensaje principal */}
          <div className="space-y-8">
            <div>
              <h1 className="text-4xl font-bold text-white leading-tight">
                Mantén tu reporte al día
              </h1>
              <p className="mt-4 text-lg text-green-200 max-w-md">
                Carga tu información diaria de forma sencilla y consulta tu progreso cuando lo necesites.
              </p>
            </div>
            
            {/* Bullets */}
            <div className="space-y-4">
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center">
                  <FileText className="w-5 h-5 text-green-300" />
                </div>
                <p className="text-white font-medium">Reporte diario</p>
              </div>
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center">
                  <History className="w-5 h-5 text-green-300" />
                </div>
                <p className="text-white font-medium">Historial de actividades</p>
              </div>
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center">
                  <TrendingUp className="w-5 h-5 text-green-300" />
                </div>
                <p className="text-white font-medium">Control de avances</p>
              </div>
            </div>
          </div>
          
          {/* Footer del panel */}
          <div className="text-green-300 text-sm space-y-1">
            <div>
              © {new Date().getFullYear()} Meridian Consulting. Todos los derechos reservados.
            </div>
            <div className="text-xs text-green-200/70 mt-1">
              Development By <span className="font-medium">José Mateo López Cifuentes</span>
            </div>
          </div>
        </div>
      </div>

      {/* Panel derecho - Formulario */}
      <div className="flex-1 flex items-center justify-center bg-slate-50 p-6 sm:p-12">
        <div className="w-full max-w-md">
          {/* Logo móvil */}
          <div className="lg:hidden text-center mb-8">
            <img
              src="/logo_meridian.png"
              alt="Meridian Consulting"
              className="h-14 w-auto mx-auto object-contain"
            />
          </div>

          {/* Encabezado del formulario */}
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-slate-900">Bienvenido</h2>
            <p className="mt-2 text-slate-600">
              Ingresa tus credenciales para acceder al sistema
            </p>
          </div>

          {/* Formulario */}
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">
                Correo electrónico
              </label>
              <div className="relative group">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Mail className="h-5 w-5 text-slate-400 group-focus-within:text-green-600 transition-colors" />
                </div>
                <input
                  type="email"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  required
                  className="w-full pl-12 pr-4 py-3.5 text-sm bg-white border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-green-600 focus:border-transparent transition-all duration-200 placeholder:text-slate-400 shadow-sm"
                  placeholder="correo@empresa.com"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-2">
                Contraseña
              </label>
              <div className="relative group">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Lock className="h-5 w-5 text-slate-400 group-focus-within:text-green-600 transition-colors" />
                </div>
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  required
                  className="w-full pl-12 pr-12 py-3.5 text-sm bg-white border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-green-600 focus:border-transparent transition-all duration-200 placeholder:text-slate-400 shadow-sm"
                  placeholder="Ingresa tu contraseña"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(v => !v)}
                  className="absolute inset-y-0 right-0 pr-4 flex items-center text-slate-400 hover:text-slate-600 transition-colors"
                  aria-label={showPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'}
                >
                  {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                </button>
              </div>
            </div>

            <div className="flex items-center">
              <label className="flex items-center gap-2.5 cursor-pointer">
                <input
                  type="checkbox"
                  checked={rememberMe}
                  onChange={(e) => setRememberMe(e.target.checked)}
                  className="h-4.5 w-4.5 rounded border-slate-300 text-green-600 focus:ring-green-600 focus:ring-offset-0 cursor-pointer"
                />
                <span className="text-sm text-slate-600">Recordarme</span>
              </label>
            </div>

            {error && (
              <Alert type="error" dismissible onDismiss={() => setError('')}>
                {error}
              </Alert>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full flex items-center justify-center gap-2.5 py-3.5 px-6 text-sm font-semibold text-white bg-green-600 rounded-xl hover:bg-green-700 active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:active:scale-100 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-green-600 focus:ring-offset-2 shadow-lg shadow-green-600/25"
            >
              {loading ? (
                <>
                  <Loader2 className="h-5 w-5 animate-spin" />
                  <span>Verificando...</span>
                </>
              ) : (
                <>
                  <span>Iniciar sesión</span>
                </>
              )}
            </button>
          </form>

          {/* Indicadores de seguridad */}
          <div className="mt-8 pt-6 border-t border-slate-200">
            <div className="flex items-center justify-center gap-6 text-xs text-slate-500">
              <div className="flex items-center gap-1.5">
                <CheckCircle className="w-4 h-4 text-emerald-500" />
                <span>Conexión segura</span>
              </div>
              <div className="flex items-center gap-1.5">
                <Shield className="w-4 h-4 text-green-500" />
                <span>Datos encriptados</span>
              </div>
            </div>
          </div>

          {/* Footer móvil */}
          <div className="lg:hidden text-center mt-8 pt-6 border-t border-slate-100/50">
            <p className="text-[10px] text-slate-400/60 tracking-wide space-y-0.5">
              <span className="block">
                <span className="text-slate-400/50">© {new Date().getFullYear()}</span>
                <span className="mx-1.5 text-slate-300/50">·</span>
                <span className="text-slate-400/50">Meridian Consulting</span>
              </span>
              <span className="block text-slate-400/50">
                Development By <span className="text-slate-400/60 font-normal">José Mateo López Cifuentes</span>
              </span>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
