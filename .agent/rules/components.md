---
trigger: always_on
---

---
applyTo: "src/app/modules/<modulesName>/component/<nameComponent>.tsx"
---

## General Rules for Creating componentName.tsx 
1. Create forms for HTML input, checkbox, form, button elements
2. Create logic and actions for web page functionality
3. For functions to fetch data and send data, refer to .agent/rules/hooks.md

Example:
```
'use client'

import { useState } from 'react'
import { useAuth } from '@/modules/auth/hooks/useAuth'

export function AdjustStockModal({ item, onAdjust, onClose }) {
  const [adjustmentType, setAdjustmentType] = useState('increase') // 'increase' or 'decrease'
  const [adjustmentAmount, setAdjustmentAmount] = useState(0)
  const [note, setNote] = useState('')
  const [errors, setErrors] = useState({})
  
  const { user } = useAuth()

  const validate = () => {
    const newErrors = {}

    if (adjustmentAmount === 0) {
      newErrors.adjustment = 'Please specify the adjustment amount'
    }

    if (adjustmentType === 'decrease' && adjustmentAmount > item.quantity) {
      newErrors.adjustment = `Insufficient quantity (Current: ${item.quantity})`
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = (e) => {
    e.preventDefault()

    if (!validate()) return

    const actionBy = user?.display_name || user?.username || 'Unknown'
    const adjustment = adjustmentType === 'increase' 
      ? parseInt(adjustmentAmount) 
      : -parseInt(adjustmentAmount)

    onAdjust(item.id, adjustment, note.trim() || null, actionBy)
  }

  const adjustment = adjustmentType === 'increase' 
    ? parseInt(adjustmentAmount || 0) 
    : -parseInt(adjustmentAmount || 0)
  const newQuantity = item.quantity + adjustment

  return (
    <div className="modal modal-open">
      <div className="modal-box">
        <h3 className="font-bold text-lg mb-4">Adjust Stock: {item.name}</h3>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="alert alert-info">
            <div>
              <div>Current Quantity: <strong>{item.quantity}</strong></div>
              <div className="text-sm opacity-70">Storage: {item.storage_name}</div>
            </div>
          </div>

          <div className="form-control">
            <label className="label">
              <span className="label-text">Adjustment Type</span>
            </label>
            <div className="btn-group w-full">
              <button
                type="button"
                className={`btn flex-1 ${adjustmentType === 'increase' ? 'btn-success' : 'btn-ghost'}`}
                onClick={() => {
                  setAdjustmentType('increase')
                  setErrors(prev => ({ ...prev, adjustment: '' }))
                }}
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clipRule="evenodd" />
                </svg>
                Increase
              </button>
              <button
                type="button"
                className={`btn flex-1 ${adjustmentType === 'decrease' ? 'btn-error' : 'btn-ghost'}`}
                onClick={() => {
                  setAdjustmentType('decrease')
                  setErrors(prev => ({ ...prev, adjustment: '' }))
                }}
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M5 10a1 1 0 011-1h8a1 1 0 110 2H6a1 1 0 01-1-1z" clipRule="evenodd" />
                </svg>
                Decrease
              </button>
            </div>
          </div>

          <div className="form-control">
            <label className="label">
              <span className="label-text">
                Amount to {adjustmentType === 'increase' ? 'Increase' : 'Decrease'}
              </span>
            </label>
            <input
              type="number"
              className={`input input-bordered ${errors.adjustment ? 'input-error' : ''}`}
              value={adjustmentAmount}
              onChange={(e) => {
                setAdjustmentAmount(parseInt(e.target.value) || 0)
                setErrors(prev => ({ ...prev, adjustment: '' }))
              }}
              placeholder="Enter amount"
              min="0"
            />
            {errors.adjustment && (
              <label className="label">
                <span className="label-text-alt text-error">{errors.adjustment}</span>
              </label>
            )}
            <label className="label">
              <span className="label-text-alt">
                {adjustmentType === 'increase' 
                  ? 'Specify amount to add to stock' 
                  : 'Specify amount to remove from stock'}
              </span>
            </label>
          </div>

          <div className="form-control">
            <label className="label">
              <span className="label-text">Performed By</span>
            </label>
            <input
              type="text"
              className="input input-bordered bg-base-200"
              value={user?.display_name || user?.username || 'Loading...'}
              disabled
            />
            <label className="label">
              <span className="label-text-alt">User performing the action will be recorded automatically</span>
            </label>
          </div>

          <div className="form-control">
            <label className="label">
              <span className="label-text">Notes</span>
            </label>
            <textarea
              className="textarea textarea-bordered"
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder={adjustmentType === 'increase' 
                ? 'e.g. Purchased from central warehouse, donation' 
                : 'e.g. Damaged, lost, expired'}
              rows={3}
              maxLength={255}
            />
          </div>

          <div className="divider"></div>

          <div className={`alert ${newQuantity < 0 ? 'alert-error' : newQuantity < 5 ? 'alert-warning' : 'alert-success'}`}>
            <div className="w-full">
              <div className="flex justify-between items-center mb-2">
                <span className="font-bold">Quantity After Adjustment:</span>
                <div className="badge badge-lg">
                  {adjustmentType === 'increase' ? '+ ' : '- '}{adjustmentAmount}
                </div>
              </div>
              <div className="text-3xl font-bold">
                {item.quantity} → {newQuantity}
              </div>
              {newQuantity < 0 && (
                <div className="text-sm mt-2">⚠️ Warning: Quantity cannot be negative</div>
              )}
              {newQuantity >= 0 && newQuantity < 5 && (
                <div className="text-sm mt-2">⚠️ Warning: Low stock level</div>
              )}
            </div>
          </div>

          <div className="modal-action">
            <button
              type="button"
              className="btn btn-ghost"
              onClick={onClose}
            >
              Cancel
            </button>
            <button
              type="submit"
              className={`btn ${adjustmentType === 'increase' ? 'btn-success' : 'btn-error'}`}
              disabled={adjustmentAmount === 0 || newQuantity < 0}
            >
              {adjustmentType === 'increase' ? '➕ Increase' : '➖ Decrease'} Stock
            </button>
          </div>
        </form>
      </div>
      <div className="modal-backdrop" onClick={onClose}></div>
    </div>
  )
}
```
