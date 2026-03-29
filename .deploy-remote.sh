set -euo pipefail
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$HOME/.bun/bin:$PATH"
cd /www/wwwroot/erp2
# Run this only after the local branch has been pushed to origin.
git pull
/home/adminplk/.bun/bin/bun install
if ! command -v db-cli >/dev/null 2>&1; then
  echo "db-cli not found on remote host" >&2
  exit 1
fi
DATABASE_URL=$(grep '^DATABASE_URL=' .env | head -n 1 | cut -d '=' -f 2- | sed 's/^"//; s/"$//')
eval "$(/home/adminplk/.nvm/versions/node/v22.12.0/bin/node - <<'NODE' "$DATABASE_URL"
const url = new URL(process.argv[2]);
const esc = (value) => `'${String(value ?? '').replace(/'/g, `'"'"'`)}'`;
console.log(`export DB_ENGINE='postgres'`);
console.log(`export DB_HOST=${esc(url.hostname)}`);
console.log(`export DB_PORT=${esc(url.port || '5432')}`);
console.log(`export DB_USER=${esc(decodeURIComponent(url.username))}`);
console.log(`export DB_PASSWORD=${esc(decodeURIComponent(url.password))}`);
console.log(`export DB_NAME=${esc(url.pathname.replace(/^\//, ''))}`);
NODE
)"
db-cli --exec "$(cat sql/20260328_inventory_stock_lot_detail_receipt_items_view.sql)"
/home/adminplk/.bun/bin/bun run build
