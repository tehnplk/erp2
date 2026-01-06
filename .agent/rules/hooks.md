---
trigger: always_on
---

---
applyTo: "src/app/modules/<modulesName>/hooks/<nameHooks>.ts"
---

## General Rules for Creating hooksName.ts 
1. Create functions for sending data, retrieving data with data management and formatting
2. Do not call API methods (get, post, put, delete) directly in this file
3. Use API functions by reading from .agent/rules/services.md

## Example Pattern:
```typescript
import { useState, useEffect } from 'react'
import { inventoryService } from '../services/inventoryService'

export const useInventory = () => {
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const fetchItems = async (filters = {}) => {
    setLoading(true)
    setError(null)
    
    const result = await inventoryService.getItems(filters)
    
    if (result.success) {
      setItems(result.data)
    } else {
      setError(result.error)
    }
    
    setLoading(false)
  }

  const addItem = async (data) => {
    const result = await inventoryService.addItem(data)
    
    if (result.success) {
      await fetchItems() // Refresh data
    }
    
    return result
  }

  return {
    items,
    loading,
    error,
    fetchItems,
    addItem
  }
}
```
