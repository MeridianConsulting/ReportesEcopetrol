// lib/api.js

// Función para detectar el entorno y obtener la URL de la API
function getApiUrl() {
  // Prioridad 1: Detectar por hostname del navegador (más confiable en producción)
  // Esto funciona tanto en desarrollo como en producción
  if (typeof window !== 'undefined') {
    const hostname = window.location.hostname;
    const protocol = window.location.protocol;
    const isLocalhost = hostname === 'localhost' || 
                       hostname === '127.0.0.1' || 
                       hostname.startsWith('192.168.') ||
                       hostname.startsWith('10.0.') ||
                       hostname === '';
    
    if (isLocalhost) {
      return 'http://localhost/tareas/backend/public/api/v1';
    }
    
    // Si estamos en producción (control.meridianltda.com), usar la URL de producción
    if (hostname === 'control.meridianltda.com' || hostname.includes('meridianltda.com')) {
      return 'https://control.meridianltda.com/api/v1';
    }
  }
  
  // Prioridad 2: Variable de entorno explícita (útil durante build/SSR)
  if (process.env.NEXT_PUBLIC_API_URL) {
    return process.env.NEXT_PUBLIC_API_URL;
  }
  
  // Prioridad 3: Detectar por NODE_ENV (útil durante build/SSR)
  if (process.env.NODE_ENV === 'development') {
    return 'http://localhost/tareas/backend/public/api/v1';
  }
  
  // Prioridad 4: Fallback (producción por defecto)
  return 'https://control.meridianltda.com/api/v1';
}

const API_URL = getApiUrl();
const TOKEN_STORAGE_KEY = 'access_token';

let accessToken = null;
let refreshPromise = null; // Lock para evitar múltiples refreshes simultáneos

// Inicializar token desde sessionStorage o localStorage si existe
if (typeof window !== 'undefined') {
  try {
    // Priorizar sessionStorage (sesión actual) sobre localStorage (recordarme)
    let storedToken = sessionStorage.getItem(TOKEN_STORAGE_KEY);
    if (!storedToken) {
      storedToken = localStorage.getItem(TOKEN_STORAGE_KEY);
    }
    if (storedToken) {
      accessToken = storedToken;
    }
  } catch (e) {
    // Error silencioso al leer token de storage
  }
}

export function setAccessToken(token, rememberMe = false) {
  accessToken = token;
  // Guardar en localStorage (persistente) o sessionStorage (temporal) según rememberMe
  if (typeof window !== 'undefined') {
    try {
      if (token) {
        if (rememberMe) {
          // Guardar en localStorage para persistencia entre sesiones
          localStorage.setItem(TOKEN_STORAGE_KEY, token);
          // Limpiar sessionStorage si existe
          sessionStorage.removeItem(TOKEN_STORAGE_KEY);
        } else {
          // Guardar en sessionStorage (se borra al cerrar el navegador)
          sessionStorage.setItem(TOKEN_STORAGE_KEY, token);
          // Limpiar localStorage si existe
          localStorage.removeItem(TOKEN_STORAGE_KEY);
        }
      } else {
        // Si no hay token, limpiar ambos
        localStorage.removeItem(TOKEN_STORAGE_KEY);
        sessionStorage.removeItem(TOKEN_STORAGE_KEY);
      }
    } catch (e) {
      // Error silencioso al guardar token en storage
    }
  }
}

export function getAccessToken() {
  // Si no hay token en memoria, intentar obtenerlo de sessionStorage o localStorage
  if (!accessToken && typeof window !== 'undefined') {
    try {
      // Priorizar sessionStorage (sesión actual) sobre localStorage (recordarme)
      let storedToken = sessionStorage.getItem(TOKEN_STORAGE_KEY);
      if (!storedToken) {
        storedToken = localStorage.getItem(TOKEN_STORAGE_KEY);
      }
      if (storedToken) {
        accessToken = storedToken;
      }
    } catch (e) {
      // Error silencioso al leer token de storage
    }
  }
  return accessToken;
}

export function clearAccessToken() {
  accessToken = null;
  refreshPromise = null;
  // Eliminar de ambos storages
  if (typeof window !== 'undefined') {
    try {
      localStorage.removeItem(TOKEN_STORAGE_KEY);
      sessionStorage.removeItem(TOKEN_STORAGE_KEY);
    } catch (e) {
      // Error silencioso al eliminar token de storage
    }
  }
}

async function refreshToken() {
  // Si ya hay un refresh en curso, esperar a que termine
  if (refreshPromise) {
    return refreshPromise;
  }

  refreshPromise = (async () => {
    try {
      const res = await fetch(`${API_URL}/auth/refresh`, {
        method: 'POST',
        credentials: 'include', // para cookie HttpOnly
      });
      
      if (!res.ok) {
        throw new Error('Refresh failed');
      }
      
      const data = await res.json();
      // Mantener la preferencia de "Recordarme" al refrescar el token
      // Si el token estaba en localStorage, mantenerlo ahí; si estaba en sessionStorage, mantenerlo ahí
      const isRemembered = typeof window !== 'undefined' && localStorage.getItem(TOKEN_STORAGE_KEY) !== null;
      setAccessToken(data.data.access_token, isRemembered);
      return data.data.access_token;
    } catch (error) {
      clearAccessToken();
      if (typeof window !== 'undefined') {
        window.location.href = '/login/';
      }
      throw error;
    } finally {
      refreshPromise = null;
    }
  })();

  return refreshPromise;
}

// Bootstrap: intenta obtener access token desde refresh cookie al iniciar
export async function bootstrapAuth() {
  try {
    const token = await refreshToken();
    return token;
  } catch (error) {
    // Si no hay refresh token válido, no hacer nada (usuario debe hacer login)
    return null;
  }
}

export async function apiRequest(url, options = {}) {
  const token = getAccessToken();
  
  // Obtener CSRF token de cookie (si existe)
  const csrfToken = typeof document !== 'undefined' 
    ? document.cookie
        .split('; ')
        .find(row => row.startsWith('csrf_token='))
        ?.split('=')[1]
    : null;
  
  const config = {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
      ...(csrfToken && { 'X-CSRF-Token': csrfToken }),
      ...options.headers,
    },
    credentials: 'include',
  };
  
  let res = await fetch(`${API_URL}${url}`, config);
  
  // Si 401, intentar refresh (incluso si no hay token en memoria)
  if (res.status === 401) {
    try {
      const newToken = await refreshToken();
      if (newToken) {
        config.headers.Authorization = `Bearer ${newToken}`;
        res = await fetch(`${API_URL}${url}`, config);
      }
    } catch (error) {
      // Si el refresh falla, lanzar error
      const errorData = await res.json().catch(() => ({ error: { message: 'Unauthorized' } }));
      throw new Error(errorData.error?.message || 'Unauthorized');
    }
  }
  
  if (!res.ok) {
    const error = await res.json().catch(() => ({ error: { message: 'Error desconocido' } }));
    let errorMessage = error.error?.message || `Error ${res.status}: ${res.statusText}`;
    
    // Si hay errores de validación específicos, incluirlos en el mensaje
    if (error.error?.code === 'VALIDATION_ERROR' && error.error?.errors) {
      const validationErrors = error.error.errors;
      const errorMessages = Object.values(validationErrors);
      errorMessage = errorMessages.join('. ');
    } else {
      // Traducir mensajes comunes de error a español
      const errorTranslations = {
        'Invalid credentials': 'Credenciales inválidas. Verifica tu correo y contraseña.',
        'Unauthorized': 'No autorizado. Por favor, inicia sesión nuevamente.',
        'Forbidden': 'No tienes permisos para realizar esta acción.',
        'Not found': 'Recurso no encontrado.',
        'Internal server error': 'Error del servidor. Por favor, intenta más tarde.'
      };
      
      errorMessage = errorTranslations[errorMessage] || errorMessage;
    }
    
    // Crear un error con información adicional
    const errorObj = new Error(errorMessage);
    errorObj.validationErrors = error.error?.errors || null;
    errorObj.errorCode = error.error?.code || null;
    throw errorObj;
  }
  
  return res.json();
}
