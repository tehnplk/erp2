export const formatNumberWithComma = (value?: number | string | null, fractionDigits = 0) => {
  if (value === null || value === undefined || value === '') {
    return '';
  }

  const numericValue = typeof value === 'number'
    ? value
    : Number(String(value).replace(/,/g, ''));

  if (Number.isNaN(numericValue)) {
    return '';
  }

  return numericValue.toLocaleString('en-US', {
    minimumFractionDigits: fractionDigits,
    maximumFractionDigits: fractionDigits,
  });
};

export const parseFormattedNumber = (value: string, mode: 'int' | 'float' = 'float') => {
  if (!value) {
    return mode === 'int' ? null : undefined;
  }

  const normalizedValue = value.replace(/,/g, '').trim();
  if (!normalizedValue) {
    return mode === 'int' ? null : undefined;
  }

  const parsedValue = mode === 'int'
    ? parseInt(normalizedValue, 10)
    : parseFloat(normalizedValue);

  if (Number.isNaN(parsedValue)) {
    return mode === 'int' ? null : undefined;
  }

  return parsedValue;
};
