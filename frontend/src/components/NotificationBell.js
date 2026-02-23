// components/NotificationBell.js
'use client';

import { useState, useEffect, useRef, useCallback } from 'react';
import { apiRequest } from '../lib/api';
import { 
  Bell, 
  Check, 
  CheckCheck, 
  Clock, 
  X,
  ChevronRight,
  FileText,
  Loader2,
  ThumbsUp,
  ThumbsDown,
  CheckCircle2,
  XCircle,
  MessageSquare,
  Inbox,
  Send
} from 'lucide-react';

export default function NotificationBell() {
  const [isOpen, setIsOpen] = useState(false);
  const [activeTab, setActiveTab] = useState('received'); // 'received' | 'responses'
  const [assignments, setAssignments] = useState([]);
  const [responses, setResponses] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [unreadResponseCount, setUnreadResponseCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [markingRead, setMarkingRead] = useState(null);
  const [respondingId, setRespondingId] = useState(null);
  const [showRejectInput, setShowRejectInput] = useState(null);
  const [rejectMessage, setRejectMessage] = useState('');
  const dropdownRef = useRef(null);

  const loadUnreadCount = useCallback(async () => {
    try {
      const [assignData, responseData] = await Promise.all([
        apiRequest('/assignments/unread-count'),
        apiRequest('/assignments/responses/unread-count')
      ]);
      setUnreadCount(assignData.data?.count || 0);
      setUnreadResponseCount(responseData.data?.count || 0);
    } catch (e) {
      // Error loading counts
    }
  }, []);

  const loadAssignments = useCallback(async () => {
    setLoading(true);
    try {
      const data = await apiRequest('/assignments/my?limit=15');
      setAssignments(data.data || []);
    } catch (e) {
      // Error loading assignments
    } finally {
      setLoading(false);
    }
  }, []);

  const loadResponses = useCallback(async () => {
    setLoading(true);
    try {
      const data = await apiRequest('/assignments/responses?limit=15');
      setResponses(data.data || []);
    } catch (e) {
      // Error loading responses
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadUnreadCount();
    const interval = setInterval(loadUnreadCount, 30000);
    return () => clearInterval(interval);
  }, [loadUnreadCount]);

  useEffect(() => {
    if (isOpen) {
      if (activeTab === 'received') {
        loadAssignments();
      } else {
        loadResponses();
      }
    }
  }, [isOpen, activeTab, loadAssignments, loadResponses]);

  useEffect(() => {
    function handleClickOutside(event) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
        setShowRejectInput(null);
        setRejectMessage('');
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleMarkAsRead = async (id) => {
    setMarkingRead(id);
    try {
      await apiRequest(`/assignments/${id}/read`, { method: 'PUT' });
      setAssignments(prev => prev.map(a => 
        a.id === id ? { ...a, is_read: 1 } : a
      ));
      setUnreadCount(prev => Math.max(0, prev - 1));
    } catch (e) {
      // Error
    } finally {
      setMarkingRead(null);
    }
  };

  const handleMarkAllAsRead = async () => {
    try {
      await apiRequest('/assignments/mark-all-read', { method: 'PUT' });
      setAssignments(prev => prev.map(a => ({ ...a, is_read: 1 })));
      setUnreadCount(0);
    } catch (e) {
      // Error
    }
  };

  const handleAccept = async (id) => {
    setRespondingId(id);
    try {
      await apiRequest(`/assignments/${id}/accept`, { method: 'PUT' });
      setAssignments(prev => prev.map(a => 
        a.id === id ? { ...a, status: 'accepted', is_read: 1 } : a
      ));
      setUnreadCount(prev => Math.max(0, prev - 1));
    } catch (e) {
      // Error
    } finally {
      setRespondingId(null);
    }
  };

  const handleReject = async (id) => {
    setRespondingId(id);
    try {
      await apiRequest(`/assignments/${id}/reject`, { 
        method: 'PUT',
        body: JSON.stringify({ response_message: rejectMessage || null })
      });
      setAssignments(prev => prev.map(a => 
        a.id === id ? { ...a, status: 'rejected', is_read: 1, response_message: rejectMessage } : a
      ));
      setUnreadCount(prev => Math.max(0, prev - 1));
      setShowRejectInput(null);
      setRejectMessage('');
    } catch (e) {
      // Error
    } finally {
      setRespondingId(null);
    }
  };

  const handleMarkResponseAsRead = async (id) => {
    try {
      await apiRequest(`/assignments/${id}/response-read`, { method: 'PUT' });
      setResponses(prev => prev.map(r => 
        r.id === id ? { ...r, response_read: 1 } : r
      ));
      setUnreadResponseCount(prev => Math.max(0, prev - 1));
    } catch (e) {
      // Error
    }
  };

  const handleMarkAllResponsesAsRead = async () => {
    try {
      await apiRequest('/assignments/mark-all-responses-read', { method: 'PUT' });
      setResponses(prev => prev.map(r => ({ ...r, response_read: 1 })));
      setUnreadResponseCount(0);
    } catch (e) {
      // Error
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    const now = new Date();
    const diff = now - date;
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);

    if (minutes < 1) return 'Ahora';
    if (minutes < 60) return `Hace ${minutes}m`;
    if (hours < 24) return `Hace ${hours}h`;
    if (days < 7) return `Hace ${days}d`;
    return date.toLocaleDateString('es-ES', { day: '2-digit', month: 'short' });
  };

  const getPriorityColor = (priority) => {
    switch (priority) {
      case 'Alta': return 'text-rose-600 bg-rose-50';
      case 'Media': return 'text-amber-600 bg-amber-50';
      case 'Baja': return 'text-emerald-600 bg-emerald-50';
      default: return 'text-slate-600 bg-slate-50';
    }
  };

  const totalUnread = unreadCount + unreadResponseCount;

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Botón de campana */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="relative p-2 text-slate-500 hover:text-slate-700 hover:bg-slate-100 rounded-lg transition-colors"
        title="Notificaciones"
      >
        <Bell className="w-5 h-5" />
        {totalUnread > 0 && (
          <span className="absolute -top-0.5 -right-0.5 w-5 h-5 bg-rose-500 text-white text-xs font-bold rounded-full flex items-center justify-center">
            {totalUnread > 9 ? '9+' : totalUnread}
          </span>
        )}
      </button>

      {/* Dropdown */}
      {isOpen && (
        <div className="absolute right-0 top-full mt-2 w-[420px] bg-white rounded-xl shadow-xl border border-slate-200 overflow-hidden z-50">
          {/* Header */}
          <div className="px-4 py-3 border-b border-slate-100 bg-slate-50">
            <div className="flex items-center justify-between mb-2">
              <div className="flex items-center gap-2">
                <Bell className="w-4 h-4 text-green-600" />
                <span className="font-semibold text-slate-900 text-sm">Notificaciones</span>
              </div>
              <button
                onClick={() => setIsOpen(false)}
                className="p-1 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
            {/* Tabs */}
            <div className="flex gap-1 bg-slate-200/60 p-0.5 rounded-lg">
              <button
                onClick={() => setActiveTab('received')}
                className={`flex-1 flex items-center justify-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-md transition-colors ${
                  activeTab === 'received' ? 'bg-white text-slate-900 shadow-sm' : 'text-slate-500 hover:text-slate-700'
                }`}
              >
                <Inbox className="w-3.5 h-3.5" />
                Recibidas
                {unreadCount > 0 && (
                  <span className="px-1.5 py-0.5 bg-green-600 text-white text-[10px] rounded-full leading-none">{unreadCount}</span>
                )}
              </button>
              <button
                onClick={() => setActiveTab('responses')}
                className={`flex-1 flex items-center justify-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-md transition-colors ${
                  activeTab === 'responses' ? 'bg-white text-slate-900 shadow-sm' : 'text-slate-500 hover:text-slate-700'
                }`}
              >
                <Send className="w-3.5 h-3.5" />
                Respuestas
                {unreadResponseCount > 0 && (
                  <span className="px-1.5 py-0.5 bg-rose-500 text-white text-[10px] rounded-full leading-none">{unreadResponseCount}</span>
                )}
              </button>
            </div>
          </div>

          {/* Marcar todas como leídas */}
          {activeTab === 'received' && unreadCount > 0 && (
            <div className="px-4 py-2 border-b border-slate-100 flex justify-end">
              <button
                onClick={handleMarkAllAsRead}
                className="flex items-center gap-1 text-xs text-green-600 hover:text-green-800 font-medium"
              >
                <CheckCheck className="w-3.5 h-3.5" />
                Marcar todas como leídas
              </button>
            </div>
          )}
          {activeTab === 'responses' && unreadResponseCount > 0 && (
            <div className="px-4 py-2 border-b border-slate-100 flex justify-end">
              <button
                onClick={handleMarkAllResponsesAsRead}
                className="flex items-center gap-1 text-xs text-green-600 hover:text-green-800 font-medium"
              >
                <CheckCheck className="w-3.5 h-3.5" />
                Marcar todas como leídas
              </button>
            </div>
          )}

          {/* Lista */}
          <div className="max-h-[400px] overflow-y-auto">
            {loading ? (
              <div className="flex items-center justify-center py-8">
                <Loader2 className="w-6 h-6 text-green-600 animate-spin" />
              </div>
            ) : activeTab === 'received' ? (
              /* TAB: Asignaciones recibidas */
              assignments.length > 0 ? (
                <div className="divide-y divide-slate-100">
                  {assignments.map(assignment => (
                    <div
                      key={assignment.id}
                      className={`p-3.5 hover:bg-slate-50 transition-colors ${
                        !assignment.is_read ? 'bg-green-50/50' : ''
                      }`}
                    >
                      <div className="flex items-start gap-3">
                        <div className="w-8 h-8 bg-slate-700 rounded-full flex items-center justify-center text-white text-xs font-medium flex-shrink-0">
                          {assignment.assigned_by_name?.charAt(0).toUpperCase()}
                        </div>
                        
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 mb-0.5">
                            <span className="text-sm font-medium text-slate-900 truncate">
                              {assignment.assigned_by_name}
                            </span>
                            <span className="text-xs text-slate-500">te asignó</span>
                            {!assignment.is_read && (
                              <span className="w-2 h-2 bg-green-600 rounded-full flex-shrink-0"></span>
                            )}
                          </div>
                          
                          <div className="flex items-center gap-1.5 mb-1">
                            <FileText className="w-3 h-3 text-slate-400 flex-shrink-0" />
                            <span className="text-xs text-slate-800 font-medium truncate">{assignment.task_title}</span>
                          </div>
                          
                          <div className="flex items-center gap-1.5 text-[11px]">
                            <span className={`px-1.5 py-0.5 rounded ${getPriorityColor(assignment.task_priority)}`}>
                              {assignment.task_priority || 'Media'}
                            </span>
                            <span className="text-slate-400">{formatDate(assignment.created_at)}</span>
                          </div>

                          {assignment.message && (
                            <p className="mt-1.5 text-xs text-slate-500 bg-slate-100 rounded p-1.5 italic truncate">
                              "{assignment.message}"
                            </p>
                          )}

                          {/* Botones aceptar/rechazar si está pendiente */}
                          {assignment.status === 'pending' && (
                            <div className="mt-2 flex items-center gap-2">
                              <button
                                onClick={() => handleAccept(assignment.id)}
                                disabled={respondingId === assignment.id}
                                className="inline-flex items-center gap-1 px-2.5 py-1 bg-emerald-600 text-white text-[11px] font-medium rounded-md hover:bg-emerald-700 transition-colors disabled:opacity-50"
                              >
                                {respondingId === assignment.id ? (
                                  <Loader2 className="w-3 h-3 animate-spin" />
                                ) : (
                                  <ThumbsUp className="w-3 h-3" />
                                )}
                                Aceptar
                              </button>
                              {showRejectInput === assignment.id ? (
                                <div className="flex-1 flex items-center gap-1">
                                  <input
                                    type="text"
                                    value={rejectMessage}
                                    onChange={(e) => setRejectMessage(e.target.value)}
                                    placeholder="Motivo (opcional)..."
                                    className="flex-1 px-2 py-1 text-[11px] border border-slate-300 rounded-md focus:outline-none focus:ring-1 focus:ring-rose-500"
                                    onKeyDown={(e) => e.key === 'Enter' && handleReject(assignment.id)}
                                  />
                                  <button
                                    onClick={() => handleReject(assignment.id)}
                                    disabled={respondingId === assignment.id}
                                    className="p-1 bg-rose-600 text-white rounded-md hover:bg-rose-700 disabled:opacity-50"
                                  >
                                    {respondingId === assignment.id ? (
                                      <Loader2 className="w-3 h-3 animate-spin" />
                                    ) : (
                                      <Check className="w-3 h-3" />
                                    )}
                                  </button>
                                  <button
                                    onClick={() => { setShowRejectInput(null); setRejectMessage(''); }}
                                    className="p-1 text-slate-400 hover:text-slate-600"
                                  >
                                    <X className="w-3 h-3" />
                                  </button>
                                </div>
                              ) : (
                                <button
                                  onClick={() => setShowRejectInput(assignment.id)}
                                  disabled={respondingId === assignment.id}
                                  className="inline-flex items-center gap-1 px-2.5 py-1 bg-white text-rose-600 text-[11px] font-medium rounded-md border border-rose-300 hover:bg-rose-50 transition-colors disabled:opacity-50"
                                >
                                  <ThumbsDown className="w-3 h-3" />
                                  Rechazar
                                </button>
                              )}
                            </div>
                          )}

                          {/* Badge si ya respondió */}
                          {assignment.status === 'accepted' && (
                            <div className="mt-1.5">
                              <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-emerald-50 text-emerald-700 text-[11px] font-medium rounded-full border border-emerald-200">
                                <CheckCircle2 className="w-3 h-3" />
                                Aceptada
                              </span>
                            </div>
                          )}
                          {assignment.status === 'rejected' && (
                            <div className="mt-1.5">
                              <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-rose-50 text-rose-700 text-[11px] font-medium rounded-full border border-rose-200">
                                <XCircle className="w-3 h-3" />
                                Rechazada
                              </span>
                            </div>
                          )}
                        </div>

                        {/* Marcar como leída */}
                        {!assignment.is_read && assignment.status !== 'pending' && (
                          <button
                            onClick={() => handleMarkAsRead(assignment.id)}
                            disabled={markingRead === assignment.id}
                            className="p-1 text-green-500 hover:text-green-700 hover:bg-green-100 rounded-lg transition-colors flex-shrink-0"
                            title="Marcar como leída"
                          >
                            {markingRead === assignment.id ? (
                              <Loader2 className="w-3.5 h-3.5 animate-spin" />
                            ) : (
                              <Check className="w-3.5 h-3.5" />
                            )}
                          </button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="py-10 text-center">
                  <Inbox className="w-8 h-8 text-slate-300 mx-auto mb-2" />
                  <p className="text-sm font-medium text-slate-900 mb-0.5">No hay asignaciones</p>
                  <p className="text-xs text-slate-500">Las tareas que te asignen aparecerán aquí</p>
                </div>
              )
            ) : (
              /* TAB: Respuestas (feedback) */
              responses.length > 0 ? (
                <div className="divide-y divide-slate-100">
                  {responses.map(response => (
                    <div
                      key={response.id}
                      className={`p-3.5 hover:bg-slate-50 transition-colors ${
                        !response.response_read ? 'bg-amber-50/40' : ''
                      }`}
                    >
                      <div className="flex items-start gap-3">
                        <div className={`w-8 h-8 rounded-full flex items-center justify-center text-white text-xs font-medium flex-shrink-0 ${
                          response.status === 'accepted' ? 'bg-emerald-600' : 'bg-rose-600'
                        }`}>
                          {response.status === 'accepted' ? (
                            <ThumbsUp className="w-4 h-4" />
                          ) : (
                            <ThumbsDown className="w-4 h-4" />
                          )}
                        </div>

                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 mb-0.5">
                            <span className="text-sm font-medium text-slate-900 truncate">
                              {response.assigned_to_name}
                            </span>
                            <span className={`text-xs font-medium ${
                              response.status === 'accepted' ? 'text-emerald-600' : 'text-rose-600'
                            }`}>
                              {response.status === 'accepted' ? 'aceptó' : 'rechazó'}
                            </span>
                            {!response.response_read && (
                              <span className="w-2 h-2 bg-amber-500 rounded-full flex-shrink-0"></span>
                            )}
                          </div>

                          <div className="flex items-center gap-1.5 mb-1">
                            <FileText className="w-3 h-3 text-slate-400 flex-shrink-0" />
                            <span className="text-xs text-slate-800 font-medium truncate">{response.task_title}</span>
                          </div>

                          {response.response_message && (
                            <div className="mt-1.5 p-2 bg-rose-50 rounded-md border border-rose-200">
                              <p className="text-[11px] font-medium text-rose-700 mb-0.5 flex items-center gap-1">
                                <MessageSquare className="w-3 h-3" />
                                Motivo:
                              </p>
                              <p className="text-xs text-rose-600 italic">"{response.response_message}"</p>
                            </div>
                          )}

                          <p className="mt-1 text-[11px] text-slate-400">
                            {formatDate(response.responded_at)}
                          </p>
                        </div>

                        {!response.response_read && (
                          <button
                            onClick={() => handleMarkResponseAsRead(response.id)}
                            className="p-1 text-amber-500 hover:text-amber-700 hover:bg-amber-100 rounded-lg transition-colors flex-shrink-0"
                            title="Marcar como leída"
                          >
                            <Check className="w-3.5 h-3.5" />
                          </button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="py-10 text-center">
                  <Send className="w-8 h-8 text-slate-300 mx-auto mb-2" />
                  <p className="text-sm font-medium text-slate-900 mb-0.5">No hay respuestas</p>
                  <p className="text-xs text-slate-500">Las respuestas a tus asignaciones aparecerán aquí</p>
                </div>
              )
            )}
          </div>

          {/* Footer */}
          <div className="px-4 py-3 border-t border-slate-100 bg-slate-50">
            <a
              href="/assignments"
              className="flex items-center justify-center gap-2 text-sm text-green-600 hover:text-green-800 font-medium"
            >
              Ver todas las asignaciones
              <ChevronRight className="w-4 h-4" />
            </a>
          </div>
        </div>
      )}
    </div>
  );
}
