// app/login/page.js
'use client';

import { useState } from 'react';
import Image from 'next/image';
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
    <div className="flex min-h-screen bg-[radial-gradient(circle_at_top,_rgba(16,185,129,0.1),_transparent_28%),linear-gradient(to_bottom,_#f8fafc,_#eef2f7)]">
      {/* Panel izquierdo - Branding */}
      <div className="relative hidden overflow-hidden lg:flex lg:w-1/2 bg-gradient-to-br from-emerald-950 via-slate-900 to-slate-950">
        {/* Patrón de fondo */}
        <div className="absolute inset-0 opacity-20">
          <div className="absolute left-0 top-0 h-96 w-96 -translate-x-1/2 -translate-y-1/2 rounded-full bg-emerald-400/60 blur-3xl"></div>
          <div className="absolute bottom-0 right-0 h-80 w-80 translate-x-1/3 translate-y-1/3 rounded-full bg-cyan-400/30 blur-3xl"></div>
          <div className="absolute left-1/2 top-1/2 h-72 w-72 -translate-x-1/2 -translate-y-1/2 rounded-full bg-white/10 blur-3xl"></div>
        </div>
        
        {/* Contenido del panel */}
        <div className="relative z-10 flex flex-col justify-between p-12 w-full">
          {/* Logo y título */}
          <div>
            <Image
              src="/logo_meridian.png"
              alt="Meridian Consulting"
              width={160}
              height={48}
              className="h-12 w-auto object-contain brightness-0 invert"
              priority
            />
          </div>
          
          {/* Mensaje principal */}
          <div className="space-y-8">
            <div>
              <div className="mb-4 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/10 px-3 py-1 text-xs font-semibold uppercase tracking-[0.18em] text-emerald-100 backdrop-blur">
                <Shield className="h-3.5 w-3.5" />
                Acceso seguro
              </div>
              <h1 className="text-4xl font-bold text-white leading-tight xl:text-5xl">
                Reportes mensuales de entregables
              </h1>
              <p className="mt-4 max-w-md text-lg leading-8 text-emerald-100/85">
                Registra y consolida tus entregables del mes de forma sencilla y consulta tu avance cuando lo necesites.
              </p>
            </div>
            
            {/* Bullets */}
            <div className="space-y-4">
              <div className="flex items-center gap-4 rounded-2xl border border-white/10 bg-white/5 px-4 py-3 backdrop-blur">
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/10">
                  <FileText className="w-5 h-5 text-emerald-300" />
                </div>
                <p className="font-medium text-white">Reporte mensual</p>
              </div>
              <div className="flex items-center gap-4 rounded-2xl border border-white/10 bg-white/5 px-4 py-3 backdrop-blur">
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/10">
                  <History className="w-5 h-5 text-emerald-300" />
                </div>
                <p className="font-medium text-white">Historial de actividades</p>
              </div>
              <div className="flex items-center gap-4 rounded-2xl border border-white/10 bg-white/5 px-4 py-3 backdrop-blur">
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/10">
                  <TrendingUp className="w-5 h-5 text-emerald-300" />
                </div>
                <p className="font-medium text-white">Control de avances</p>
              </div>
            </div>
          </div>
          
          {/* Footer del panel */}
          <div className="space-y-1 text-sm text-emerald-200/90">
            <div>
              © {new Date().getFullYear()} Meridian Consulting. Todos los derechos reservados.
            </div>
            <div className="mt-1 text-xs text-emerald-100/60">
              Development By <span className="font-medium">José Mateo López Cifuentes</span>
            </div>
          </div>
        </div>
      </div>

      {/* Panel derecho - Formulario */}
      <div className="flex flex-1 items-center justify-center p-6 sm:p-12">
        <div className="w-full max-w-md">
          {/* Logo móvil */}
          <div className="lg:hidden text-center mb-8">
            <Image
              src="/logo_meridian.png"
              alt="Meridian Consulting"
              width={180}
              height={56}
              className="mx-auto h-14 w-auto object-contain"
              priority
            />
          </div>

          <div className="rounded-[32px] border border-slate-200/80 bg-white/95 p-6 shadow-[0_24px_60px_-34px_rgba(15,23,42,0.32)] backdrop-blur sm:p-8">
            {/* Encabezado del formulario */}
            <div className="mb-8">
              <div className="inline-flex items-center gap-2 rounded-full border border-emerald-100 bg-emerald-50 px-3 py-1 text-xs font-semibold uppercase tracking-[0.18em] text-emerald-700">
                <Shield className="h-3.5 w-3.5" />
                Acceso al sistema
              </div>
              <h2 className="mt-4 text-2xl font-bold text-slate-900">Bienvenido</h2>
              <p className="mt-2 text-slate-600">
                Ingresa tus credenciales para acceder al sistema
              </p>
            </div>

            {/* Formulario */}
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/80 p-3">
                <label className="block text-sm font-semibold text-slate-700">
                  Correo electrónico
                </label>
                <div className="relative group">
                  <div className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                    <Mail className="h-5 w-5 text-slate-400 transition-colors group-focus-within:text-emerald-600" />
                  </div>
                  <input
                    type="email"
                    value={email}
                    onChange={e => setEmail(e.target.value)}
                    required
                    className="w-full rounded-2xl border border-slate-200 bg-white py-3.5 pl-12 pr-4 text-sm shadow-sm outline-none transition-all duration-200 placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                    placeholder="correo@empresa.com"
                  />
                </div>
              </div>

              <div className="space-y-2 rounded-2xl border border-slate-200 bg-slate-50/80 p-3">
                <label className="block text-sm font-semibold text-slate-700">
                  Contraseña
                </label>
                <div className="relative group">
                  <div className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                    <Lock className="h-5 w-5 text-slate-400 transition-colors group-focus-within:text-emerald-600" />
                  </div>
                  <input
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={e => setPassword(e.target.value)}
                    required
                    className="w-full rounded-2xl border border-slate-200 bg-white py-3.5 pl-12 pr-12 text-sm shadow-sm outline-none transition-all duration-200 placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-100"
                    placeholder="Ingresa tu contraseña"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(v => !v)}
                    className="absolute inset-y-0 right-0 flex items-center pr-4 text-slate-400 transition-colors hover:text-slate-600"
                    aria-label={showPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'}
                  >
                    {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                  </button>
                </div>
              </div>

              <div className="flex items-center justify-between gap-3">
                <label className="flex cursor-pointer items-center gap-2.5">
                  <input
                    type="checkbox"
                    checked={rememberMe}
                    onChange={(e) => setRememberMe(e.target.checked)}
                    className="h-4.5 w-4.5 cursor-pointer rounded border-slate-300 text-emerald-600 focus:ring-emerald-600 focus:ring-offset-0"
                  />
                  <span className="text-sm text-slate-600">Recordarme</span>
                </label>
                <span className="text-xs font-medium uppercase tracking-wide text-slate-400">
                  Inicio seguro
                </span>
              </div>

              {error && (
                <Alert type="error" dismissible onDismiss={() => setError('')}>
                  {error}
                </Alert>
              )}

              <button
                type="submit"
                disabled={loading}
                className="flex w-full items-center justify-center gap-2.5 rounded-2xl bg-emerald-600 px-6 py-3.5 text-sm font-semibold text-white shadow-lg shadow-emerald-600/25 transition-all duration-200 hover:bg-emerald-500 active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-emerald-600 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 disabled:active:scale-100"
              >
                {loading ? (
                  <>
                    <Loader2 className="h-5 w-5 animate-spin" />
                    <span>Verificando...</span>
                  </>
                ) : (
                  <span>Iniciar sesión</span>
                )}
              </button>
            </form>

            {/* Indicadores de seguridad */}
            <div className="mt-8 border-t border-slate-200 pt-6">
              <div className="flex flex-wrap items-center justify-center gap-4 text-xs text-slate-500">
                <div className="flex items-center gap-1.5 rounded-full bg-slate-50 px-3 py-1.5">
                  <CheckCircle className="w-4 h-4 text-emerald-500" />
                  <span>Conexión segura</span>
                </div>
                <div className="flex items-center gap-1.5 rounded-full bg-slate-50 px-3 py-1.5">
                  <Shield className="w-4 h-4 text-emerald-500" />
                  <span>Datos encriptados</span>
                </div>
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
