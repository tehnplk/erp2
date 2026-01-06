---
trigger: always_on
---

---
applyTo: "src/app/modules/<modulesName>/service/<nameService>.ts"
---

## General Rules for Creating serviceName.ts 
1. Create BASE_URL for use throughout the file
Example:
```
/**
 * Inventory Service
 * Manages API calls for equipment warehouse system
 */

const INVENTORY_API_BASE = '/api/e-borrow/inventory'

export const inventoryService = {
  /**
   * Fetch all equipment items in warehouse
   */
  async getItems(filters = {}) {
    const params = new URLSearchParams()
    if (filters.storage_id) params.set('storage_id', filters.storage_id)
    if (filters.search) params.set('search', filters.search)
    if (filters.is_active) params.set('is_active', filters.is_active)

    const response = await fetch(`${INVENTORY_API_BASE}/items?${params}`)

    const result = await response.json()
    console.log('response', result);

    if (!response.ok) {
      return {
        success: false,
        error: result.error || 'Unable to fetch equipment data'
      }
    }

    return {
      success: true,
      data: result.data
    }
  },

  /**
   * Fetch equipment data by ID
   */
  async getItemById(id) {
    const response = await fetch(`${INVENTORY_API_BASE}/items/${id}`)
    const result = await response.json()

    if (!response.ok) {
      return {
        success: false,
        error: result.error || 'Unable to fetch equipment data'
      }
    }

    return {
      success: true,
      data: result.data
    }
  },

  /**
   * Add new equipment
   */
  async addItem(data) {
    const response = await fetch(`${INVENTORY_API_BASE}/items`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })

    const result = await response.json()

    if (!response.ok) {
      return {
        success: false,
        error: result.error || 'Unable to add equipment'
      }
    }

    return {
      success: true,
      data: result.data
    }
  },

  /**
   * Update equipment data
   */
  async updateItem(id, data) {
    const response = await fetch(`${INVENTORY_API_BASE}/items/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })

    const result = await response.json()

    if (!response.ok) {
      return {
        success: false,
        error: result.error || 'Unable to update data'
      }
    }

    return {
      success: true,
      data: result.data
    }
  },

  /**
   * Adjust equipment stock
   */
  async adjustStock(id, adjustment, note = null, action_by = null) {
    const response = await fetch(`${INVENTORY_API_BASE}/items/${id}/adjust-stock`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ adjustment, note, action_by })
    })

    const result = await response.json()

    if (!response.ok) {
      return {
        success: false,
        error: result.error || 'Unable to adjust stock'
      }
    }

    return {
      success: true,
      data: result.data,
      message: result.message
    }
  }
}

export default inventoryService
```
