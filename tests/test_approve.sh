#!/bin/bash
curl -X POST http://localhost:3000/api/inventory/requisitions/approve?requisitionId=3 \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {
        "requisitionItemId": 3,
        "approvedQty": 1
      }
    ],
    "approvedBy": "Admin",
    "note": "Testing partial approve or full approve"
  }'
echo ""
