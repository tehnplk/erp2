#!/bin/bash
curl -X POST http://localhost:3000/api/inventory/requisitions/cancel?requisitionId=3 \
  -H "Content-Type: application/json" \
  -d '{
    "cancelledBy": "Admin",
    "note": "Testing cancellation functionality"
  }'
echo ""
