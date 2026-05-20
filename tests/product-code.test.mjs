import test from 'node:test';
import assert from 'node:assert/strict';

import {
  PRODUCT_CATEGORY_PREFIXES,
  buildNextProductCode,
  getProductCodePrefixForCategory,
} from '../src/lib/product-code.ts';

test('maps documented Thai product categories to product code prefixes', () => {
  assert.equal(getProductCodePrefixForCategory('งบค่าเสื่อม'), 'P010');
  assert.equal(getProductCodePrefixForCategory('ครุภัณฑ์และสิ่งก่อสร้าง'), 'P011');
  assert.equal(getProductCodePrefixForCategory('ครุภัณฑ์ต่ำกว่าเกณฑ์'), 'P231');
  assert.equal(getProductCodePrefixForCategory('ยา'), 'P140');
  assert.equal(getProductCodePrefixForCategory('วัสดุการแพทย์'), 'P150');
  assert.equal(getProductCodePrefixForCategory('วัสดุทันตกรรม'), 'P151');
  assert.equal(getProductCodePrefixForCategory('วัสดุเภสัชกรรม'), 'P152');
  assert.equal(getProductCodePrefixForCategory('วัสดุวิทยาศาสตร์การแพทย์'), 'P160');
  assert.equal(getProductCodePrefixForCategory('ค่าใช้สอย'), 'P210');
  assert.equal(getProductCodePrefixForCategory('ค่าสาธารณูปโภค'), 'P220');
  assert.equal(getProductCodePrefixForCategory('วัสดุใช้ไป'), 'P230');
  assert.equal(PRODUCT_CATEGORY_PREFIXES.length, 11);
});

test('builds next product code from existing matching codes', () => {
  assert.equal(
    buildNextProductCode('P230', ['P230-000001', 'P230-000009', 'P230-ABCDEF', 'P010-000999']),
    'P230-000010',
  );
});

test('starts product code sequence at 1 when a category has no products', () => {
  assert.equal(buildNextProductCode('P140', []), 'P140-000001');
});
