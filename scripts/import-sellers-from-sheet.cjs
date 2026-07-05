const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

const SHEET_CSV_URL =
  'https://docs.google.com/spreadsheets/d/1hyEnsni-7eYUH3vVB3YezL3yZo-egcBEB5QnjEjPZbE/export?format=csv&gid=0';

function loadEnvFile() {
  const envPath = path.join(process.cwd(), '.env');
  if (!fs.existsSync(envPath)) return;

  const lines = fs.readFileSync(envPath, 'utf8').split(/\r?\n/);
  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const eq = trimmed.indexOf('=');
    if (eq === -1) continue;
    const key = trimmed.slice(0, eq).trim();
    const value = trimmed.slice(eq + 1).trim().replace(/^['"]|['"]$/g, '');
    if (!process.env[key]) process.env[key] = value;
  }
}

function parseCsv(text) {
  const rows = [];
  let row = [];
  let field = '';
  let quoted = false;

  const normalized = text.replace(/^\uFEFF/, '').replace(/\r\n/g, '\n').replace(/\r/g, '\n');
  for (let i = 0; i < normalized.length; i += 1) {
    const ch = normalized[i];
    if (quoted) {
      if (ch === '"' && normalized[i + 1] === '"') {
        field += '"';
        i += 1;
      } else if (ch === '"') {
        quoted = false;
      } else {
        field += ch;
      }
    } else if (ch === '"') {
      quoted = true;
    } else if (ch === ',') {
      row.push(field);
      field = '';
    } else if (ch === '\n') {
      row.push(field);
      rows.push(row);
      row = [];
      field = '';
    } else {
      field += ch;
    }
  }

  if (field.length > 0 || row.length > 0) {
    row.push(field);
    rows.push(row);
  }

  return rows.filter((currentRow) => currentRow.some((value) => String(value).trim() !== ''));
}

function normalizeCategory(value) {
  return String(value || '')
    .trim()
    .replace(/\s+/g, ' ');
}

function splitCategoryValues(value) {
  return String(value || '')
    .split(/[,\n/]+/)
    .map(normalizeCategory)
    .filter(Boolean);
}

function toRecordRows(csvText) {
  const parsed = parseCsv(csvText);
  if (parsed.length < 2) return [];

  const headers = parsed[0].map((header) => header.trim());
  return parsed.slice(1).map((row) => {
    const record = {};
    headers.forEach((header, index) => {
      record[header] = String(row[index] ?? '').trim();
    });
    return record;
  });
}

async function fetchCsv() {
  const response = await fetch(SHEET_CSV_URL);
  if (!response.ok) {
    throw new Error(`Failed to fetch seller sheet: HTTP ${response.status}`);
  }
  return response.text();
}

async function main() {
  loadEnvFile();
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error('DATABASE_URL is required');
  }

  const csvText = await fetchCsv();
  const rows = toRecordRows(csvText);
  if (rows.length === 0) {
    throw new Error('Seller sheet has no data rows');
  }

  const client = new Client({ connectionString });
  await client.connect();

  try {
    const categoriesResult = await client.query(
      `SELECT DISTINCT category_code, category
       FROM public.category
       WHERE COALESCE(category_code, '') <> ''
       ORDER BY category_code`,
    );
    const categoryByName = new Map();
    const categoryByCode = new Map();
    for (const category of categoriesResult.rows) {
      categoryByName.set(normalizeCategory(category.category), category.category_code);
      categoryByCode.set(normalizeCategory(category.category_code), category.category_code);
    }

    const records = rows
      .map((row) => {
        const categoryCodes = splitCategoryValues(row['หมวด']).map((categoryName) => categoryByCode.get(categoryName) || categoryByName.get(categoryName));
        const missingCategories = splitCategoryValues(row['หมวด']).filter((categoryName, index) => !categoryCodes[index]);
        if (missingCategories.length > 0) {
          throw new Error(`Unmapped category for seller ${row['รหัสร้านค้า'] || '(no code)'}: ${missingCategories.join(', ')}`);
        }

        return {
          code: row['รหัสร้านค้า'],
          prefix: row['คำนำหน้าร้านค้า'],
          name: row['ชื่อร้านค้า'],
          business: row['กิจการร้านค้า'],
          address: row['ที่อยู่ร้านค้า'],
          phone: row['เบอร์โทรร้านค้า'],
          fax: row['เบอร์ Fax ร้านค้า'],
          mobile: row['เบอร์มือถือร้านค้า'],
          category_code_sale: [...new Set(categoryCodes.filter(Boolean))],
        };
      })
      .filter((record) => record.code && record.name);

    if (records.length === 0) {
      throw new Error('No importable seller rows found');
    }

    await client.query('BEGIN');
    await client.query('TRUNCATE TABLE public.seller RESTART IDENTITY');

    const insertSql = `
      INSERT INTO public.seller
        (code, prefix, name, business, address, phone, fax, mobile, category_code_sale, is_active)
      VALUES
        ($1, $2, $3, $4, $5, $6, $7, $8, $9::text[], true)
    `;

    for (const record of records) {
      await client.query(insertSql, [
        record.code,
        record.prefix || null,
        record.name,
        record.business || null,
        record.address || null,
        record.phone || null,
        record.fax || null,
        record.mobile || null,
        record.category_code_sale,
      ]);
    }

    await client.query('COMMIT');

    const counts = await client.query(
      `SELECT COUNT(*)::int AS seller_count,
              COUNT(*) FILTER (WHERE array_length(category_code_sale, 1) IS NOT NULL)::int AS categorized_count
       FROM public.seller`,
    );
    console.log(JSON.stringify(counts.rows[0]));
  } catch (error) {
    await client.query('ROLLBACK').catch(() => {});
    throw error;
  } finally {
    await client.end();
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
