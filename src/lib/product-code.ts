export type ProductCategoryPrefix = {
  category: string;
  prefix: string;
};

export const PRODUCT_CATEGORY_PREFIXES: ProductCategoryPrefix[] = [
  { prefix: 'P010', category: 'งบค่าเสื่อม' },
  { prefix: 'P011', category: 'ครุภัณฑ์และสิ่งก่อสร้าง' },
  { prefix: 'P231', category: 'ครุภัณฑ์ต่ำกว่าเกณฑ์' },
  { prefix: 'P140', category: 'ยา' },
  { prefix: 'P150', category: 'วัสดุการแพทย์' },
  { prefix: 'P151', category: 'วัสดุทันตกรรม' },
  { prefix: 'P152', category: 'วัสดุเภสัชกรรม' },
  { prefix: 'P160', category: 'วัสดุวิทยาศาสตร์การแพทย์' },
  { prefix: 'P210', category: 'ค่าใช้สอย' },
  { prefix: 'P220', category: 'ค่าสาธารณูปโภค' },
  { prefix: 'P230', category: 'วัสดุใช้ไป' },
];

const sequenceWidth = 6;

export const getProductCodePrefixForCategory = (category: string) => {
  const normalizedCategory = category.trim();
  return PRODUCT_CATEGORY_PREFIXES.find((item) => item.category === normalizedCategory)?.prefix ?? null;
};

export const buildNextProductCode = (prefix: string, existingCodes: string[]) => {
  const pattern = new RegExp(`^${prefix}-(\\d{${sequenceWidth}})$`);
  const maxSequence = existingCodes.reduce((max, code) => {
    const match = code.match(pattern);
    if (!match) return max;

    const sequence = Number.parseInt(match[1], 10);
    return Number.isFinite(sequence) ? Math.max(max, sequence) : max;
  }, 0);

  return `${prefix}-${String(maxSequence + 1).padStart(sequenceWidth, '0')}`;
};
