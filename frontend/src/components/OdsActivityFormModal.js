'use client';

import { useMemo, useState } from 'react';
import { CalendarDays, CheckSquare, ClipboardList, Loader2, Save, Users, X } from 'lucide-react';
import Alert from './Alert';

const STATUS_OPTIONS = ['Borrador', 'Activa', 'En pausa', 'Finalizada', 'Cancelada'];

function getInitialForm(activity) {
  return {
    service_order_id: activity?.service_order_id ? String(activity.service_order_id) : '',
    title: activity?.title || '',
    item_general: activity?.item_general || '',
    item_activity: activity?.item_activity || '',
    description: activity?.description || '',
    support_text: activity?.support_text || '',
    delivery_medium_id: activity?.delivery_medium_id ? String(activity.delivery_medium_id) : '',
    contracted_days:
      activity?.contracted_days === null || activity?.contracted_days === undefined
        ? ''
        : String(activity.contracted_days),
    planned_start_date: activity?.planned_start_date || '',
    planned_end_date: activity?.planned_end_date || '',
    status: activity?.status || 'Borrador',
    notes: activity?.notes || '',
    assigned_user_ids: Array.isArray(activity?.assigned_user_ids)
      ? activity.assigned_user_ids.map((id) => Number(id))
      : [],
  };
}

export default function OdsActivityFormModal({
  isOpen,
  activity,
  serviceOrders,
  users,
  deliveryMedia,
  saving,
  onClose,
  onSubmit,
}) {
  const [formData, setFormData] = useState(getInitialForm(activity));
  const [error, setError] = useState('');

  const selectedServiceOrderId = Number(formData.service_order_id || 0);
  const selectedServiceOrder = useMemo(
    () => serviceOrders.find((item) => Number(item.id) === selectedServiceOrderId) || null,
    [serviceOrders, selectedServiceOrderId]
  );

  const availableProfessionals = useMemo(() => {
    if (!selectedServiceOrderId) return [];
    return users.filter((user) =>
      Array.isArray(user.service_order_ids) &&
      user.service_order_ids.map(Number).includes(selectedServiceOrderId)
    );
  }, [users, selectedServiceOrderId]);

  function updateField(field, value) {
    setFormData((prev) => ({ ...prev, [field]: value }));
  }

  function handleServiceOrderChange(value) {
    const nextServiceOrderId = Number(value || 0);
    const validIds = new Set(
      users
        .filter((user) =>
          Array.isArray(user.service_order_ids) &&
          user.service_order_ids.map(Number).includes(nextServiceOrderId)
        )
        .map((user) => Number(user.id))
    );

    setFormData((prev) => ({
      ...prev,
      service_order_id: value,
      assigned_user_ids: nextServiceOrderId
        ? prev.assigned_user_ids.filter((id) => validIds.has(Number(id)))
        : [],
    }));
    setError('');
  }

  function toggleAssignedUser(userId) {
    const normalizedId = Number(userId);
    setFormData((prev) => {
      const exists = prev.assigned_user_ids.includes(normalizedId);
      return {
        ...prev,
        assigned_user_ids: exists
          ? prev.assigned_user_ids.filter((id) => id !== normalizedId)
          : [...prev.assigned_user_ids, normalizedId],
      };
    });
  }

  function handleSelectAllProfessionals() {
    setFormData((prev) => ({
      ...prev,
      assigned_user_ids: availableProfessionals.map((user) => Number(user.id)),
    }));
  }

  function handleClearProfessionals() {
    setFormData((prev) => ({ ...prev, assigned_user_ids: [] }));
  }

  function validateForm() {
    if (!formData.service_order_id) {
      return 'Debes seleccionar una ODS.';
    }

    if (formData.title.trim().length < 3) {
      return 'El título debe tener al menos 3 caracteres.';
    }

    if (formData.description.trim().length < 10) {
      return 'La descripción debe tener al menos 10 caracteres.';
    }

    if (!STATUS_OPTIONS.includes(formData.status)) {
      return 'Selecciona un estado válido.';
    }

    if (formData.contracted_days !== '') {
      const contractedDays = Number(formData.contracted_days);
      if (Number.isNaN(contractedDays) || contractedDays < 0) {
        return 'Los días contratados deben ser un número mayor o igual a cero.';
      }
    }

    if (
      formData.planned_start_date &&
      formData.planned_end_date &&
      formData.planned_end_date < formData.planned_start_date
    ) {
      return 'La fecha final debe ser igual o posterior a la fecha inicial.';
    }

    if (formData.assigned_user_ids.length === 0) {
      return 'Debes asignar al menos un profesional.';
    }

    return '';
  }

  async function handleSubmit(event) {
    event.preventDefault();
    const validationError = validateForm();

    if (validationError) {
      setError(validationError);
      return;
    }

    setError('');

    await onSubmit({
      service_order_id: Number(formData.service_order_id),
      title: formData.title.trim(),
      item_general: formData.item_general.trim() || null,
      item_activity: formData.item_activity.trim() || null,
      description: formData.description.trim(),
      support_text: formData.support_text.trim() || null,
      delivery_medium_id: formData.delivery_medium_id ? Number(formData.delivery_medium_id) : null,
      contracted_days: formData.contracted_days === '' ? null : Number(formData.contracted_days),
      planned_start_date: formData.planned_start_date || null,
      planned_end_date: formData.planned_end_date || null,
      status: formData.status,
      notes: formData.notes.trim() || null,
      assigned_user_ids: formData.assigned_user_ids.map(Number),
    });
  }

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 p-4 backdrop-blur-sm">
      <div className="max-h-[92vh] w-full max-w-5xl overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl">
        <div className="flex items-start justify-between bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 px-6 py-5 text-white">
          <div>
            <div className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-medium text-slate-100">
              <ClipboardList className="h-4 w-4" />
              Administración de actividades ODS
            </div>
            <h2 className="mt-3 text-2xl font-semibold tracking-tight">
              {activity ? 'Editar actividad' : 'Nueva actividad'}
            </h2>
            <p className="mt-1 text-sm text-slate-300">
              Registra la actividad, define su estado y asígnala a uno o varios profesionales de la ODS.
            </p>
          </div>

          <button
            type="button"
            onClick={onClose}
            className="rounded-xl p-2 text-slate-300 transition hover:bg-white/10 hover:text-white"
            aria-label="Cerrar"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="flex max-h-[calc(92vh-112px)] flex-col">
          <div className="overflow-y-auto p-6 sm:p-7">
            {error ? (
              <div className="mb-5">
                <Alert type="error" dismissible onDismiss={() => setError('')}>
                  {error}
                </Alert>
              </div>
            ) : null}

            <div className="grid gap-6 xl:grid-cols-[1.4fr_0.9fr]">
              <section className="space-y-5 rounded-2xl border border-slate-200 bg-white p-5">
                <div className="grid gap-4 sm:grid-cols-2">
                  <label className="space-y-2">
                    <span className="text-sm font-medium text-slate-700">
                      ODS <span className="text-rose-500">*</span>
                    </span>
                    <select
                      value={formData.service_order_id}
                      onChange={(event) => handleServiceOrderChange(event.target.value)}
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    >
                      <option value="">Selecciona una ODS</option>
                      {serviceOrders.map((item) => (
                        <option key={item.id} value={item.id}>
                          {item.ods_code}
                        </option>
                      ))}
                    </select>
                  </label>

                  <label className="space-y-2">
                    <span className="text-sm font-medium text-slate-700">
                      Estado <span className="text-rose-500">*</span>
                    </span>
                    <select
                      value={formData.status}
                      onChange={(event) => updateField('status', event.target.value)}
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    >
                      {STATUS_OPTIONS.map((status) => (
                        <option key={status} value={status}>
                          {status}
                        </option>
                      ))}
                    </select>
                  </label>
                </div>

                {selectedServiceOrder ? (
                  <div className="rounded-2xl border border-slate-200 bg-slate-50/80 p-4 text-sm text-slate-600">
                    <p className="font-medium text-slate-900">
                      {selectedServiceOrder.ods_code}
                      {selectedServiceOrder.project_name ? ` · ${selectedServiceOrder.project_name}` : ''}
                    </p>
                    {selectedServiceOrder.object_text ? (
                      <p className="mt-2 line-clamp-3">{selectedServiceOrder.object_text}</p>
                    ) : null}
                  </div>
                ) : null}

                <label className="space-y-2">
                  <span className="text-sm font-medium text-slate-700">
                    Título <span className="text-rose-500">*</span>
                  </span>
                  <input
                    type="text"
                    value={formData.title}
                    onChange={(event) => updateField('title', event.target.value)}
                    placeholder="Ej: Generación de informe petrotécnico mensual"
                    maxLength={180}
                    className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                  />
                </label>

                <div className="grid gap-4 sm:grid-cols-2">
                  <label className="space-y-2">
                    <span className="text-sm font-medium text-slate-700">Ítem general</span>
                    <input
                      type="text"
                      value={formData.item_general}
                      onChange={(event) => updateField('item_general', event.target.value)}
                      placeholder="Ej: 1"
                      maxLength={20}
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    />
                  </label>

                  <label className="space-y-2">
                    <span className="text-sm font-medium text-slate-700">Ítem actividad</span>
                    <input
                      type="text"
                      value={formData.item_activity}
                      onChange={(event) => updateField('item_activity', event.target.value)}
                      placeholder="Ej: 1.1"
                      maxLength={20}
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    />
                  </label>
                </div>

                <label className="space-y-2">
                  <span className="text-sm font-medium text-slate-700">
                    Descripción <span className="text-rose-500">*</span>
                  </span>
                  <textarea
                    value={formData.description}
                    onChange={(event) => updateField('description', event.target.value)}
                    rows={5}
                    placeholder="Describe con claridad el alcance, entregable y contexto de la actividad."
                    className="w-full rounded-2xl border border-slate-300 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                  />
                </label>

                <label className="space-y-2">
                  <span className="text-sm font-medium text-slate-700">Soporte / evidencia</span>
                  <textarea
                    value={formData.support_text}
                    onChange={(event) => updateField('support_text', event.target.value)}
                    rows={3}
                    placeholder="Ej: Informe técnico, base de datos, modelo, presentación..."
                    className="w-full rounded-2xl border border-slate-300 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                  />
                </label>
              </section>

              <section className="space-y-5 rounded-2xl border border-slate-200 bg-slate-50/60 p-5">
                <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-1">
                  <label className="space-y-2">
                    <span className="text-sm font-medium text-slate-700">Medio de entrega</span>
                    <select
                      value={formData.delivery_medium_id}
                      onChange={(event) => updateField('delivery_medium_id', event.target.value)}
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    >
                      <option value="">Sin definir</option>
                      {deliveryMedia.map((item) => (
                        <option key={item.id} value={item.id}>
                          {item.name}
                        </option>
                      ))}
                    </select>
                  </label>

                  <label className="space-y-2">
                    <span className="text-sm font-medium text-slate-700">Días contratados</span>
                    <input
                      type="number"
                      min="0"
                      step="0.5"
                      value={formData.contracted_days}
                      onChange={(event) => updateField('contracted_days', event.target.value)}
                      placeholder="0"
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    />
                  </label>
                </div>

                <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-1">
                  <label className="space-y-2">
                    <span className="flex items-center gap-2 text-sm font-medium text-slate-700">
                      <CalendarDays className="h-4 w-4" />
                      Fecha inicial
                    </span>
                    <input
                      type="date"
                      value={formData.planned_start_date}
                      onChange={(event) => updateField('planned_start_date', event.target.value)}
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    />
                  </label>

                  <label className="space-y-2">
                    <span className="flex items-center gap-2 text-sm font-medium text-slate-700">
                      <CalendarDays className="h-4 w-4" />
                      Fecha final
                    </span>
                    <input
                      type="date"
                      value={formData.planned_end_date}
                      onChange={(event) => updateField('planned_end_date', event.target.value)}
                      className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 outline-none transition focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                    />
                  </label>
                </div>

                <label className="space-y-2">
                  <span className="text-sm font-medium text-slate-700">Notas internas</span>
                  <textarea
                    value={formData.notes}
                    onChange={(event) => updateField('notes', event.target.value)}
                    rows={4}
                    placeholder="Notas para administración, seguimiento o coordinación."
                    className="w-full rounded-2xl border border-slate-300 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-slate-500 focus:ring-2 focus:ring-slate-200"
                  />
                </label>

                <div className="rounded-2xl border border-slate-200 bg-white p-4">
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <p className="flex items-center gap-2 text-sm font-semibold text-slate-900">
                        <Users className="h-4 w-4" />
                        Profesionales asignados
                      </p>
                      <p className="mt-1 text-xs text-slate-500">
                        Solo se muestran usuarios vinculados a la ODS seleccionada.
                      </p>
                    </div>

                    <div className="flex gap-2">
                      <button
                        type="button"
                        onClick={handleSelectAllProfessionals}
                        disabled={availableProfessionals.length === 0}
                        className="inline-flex items-center gap-1 rounded-lg border border-slate-200 px-2.5 py-1.5 text-xs font-medium text-slate-600 transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-50"
                      >
                        <CheckSquare className="h-3.5 w-3.5" />
                        Todos
                      </button>
                      <button
                        type="button"
                        onClick={handleClearProfessionals}
                        disabled={formData.assigned_user_ids.length === 0}
                        className="rounded-lg border border-slate-200 px-2.5 py-1.5 text-xs font-medium text-slate-600 transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-50"
                      >
                        Limpiar
                      </button>
                    </div>
                  </div>

                  <div className="mt-4 max-h-72 space-y-2 overflow-y-auto pr-1">
                    {selectedServiceOrderId === 0 ? (
                      <div className="rounded-xl border border-dashed border-slate-300 bg-slate-50 p-4 text-sm text-slate-500">
                        Selecciona primero una ODS para habilitar la asignación de profesionales.
                      </div>
                    ) : availableProfessionals.length === 0 ? (
                      <div className="rounded-xl border border-dashed border-amber-300 bg-amber-50 p-4 text-sm text-amber-800">
                        Esta ODS no tiene profesionales activos asociados.
                      </div>
                    ) : (
                      availableProfessionals.map((user) => {
                        const checked = formData.assigned_user_ids.includes(Number(user.id));
                        return (
                          <label
                            key={user.id}
                            className={`flex cursor-pointer items-start gap-3 rounded-2xl border px-3 py-3 transition ${
                              checked
                                ? 'border-emerald-300 bg-emerald-50'
                                : 'border-slate-200 bg-white hover:border-slate-300 hover:bg-slate-50'
                            }`}
                          >
                            <input
                              type="checkbox"
                              checked={checked}
                              onChange={() => toggleAssignedUser(user.id)}
                              className="mt-1 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"
                            />
                            <div className="min-w-0">
                              <p className="text-sm font-medium text-slate-900">{user.name}</p>
                              <p className="truncate text-xs text-slate-500">{user.email}</p>
                            </div>
                          </label>
                        );
                      })
                    )}
                  </div>
                </div>
              </section>
            </div>
          </div>

          <div className="flex items-center justify-between gap-3 border-t border-slate-200 bg-slate-50 px-6 py-4">
            <p className="text-xs text-slate-500">
              {formData.assigned_user_ids.length} profesional(es) seleccionado(s)
            </p>

            <div className="flex items-center gap-3">
              <button
                type="button"
                onClick={onClose}
                className="rounded-xl border border-slate-300 bg-white px-4 py-2.5 text-sm font-medium text-slate-700 transition hover:bg-slate-50"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={saving}
                className="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-4 py-2.5 text-sm font-medium text-white transition hover:bg-slate-800 disabled:cursor-not-allowed disabled:opacity-60"
              >
                {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                {saving ? 'Guardando...' : activity ? 'Guardar cambios' : 'Crear actividad'}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
}
