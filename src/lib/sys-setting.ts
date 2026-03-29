export type SysSettingItem = {
  id: number;
  sys_name: string;
  sys_value: string;
  sys_value_detail: string;
  note: string | null;
};

export type SysSettingPublicData = {
  items: SysSettingItem[];
  by_name: Record<string, Pick<SysSettingItem, 'sys_value' | 'sys_value_detail' | 'note'>>;
};

let cachedSysSettings: SysSettingPublicData | null = null;
let pendingPromise: Promise<SysSettingPublicData> | null = null;

export function clearSysSettingCache() {
  cachedSysSettings = null;
}

export async function fetchSysSettingsPublic(forceRefresh = false): Promise<SysSettingPublicData> {
  if (!forceRefresh && pendingPromise) {
    return pendingPromise;
  }

  pendingPromise = (async () => {
    const response = await fetch('/api/sys-setting/public', { cache: 'no-store' });
    const json = await response.json().catch(() => null);

    if (!response.ok || !json?.success || !json?.data) {
      throw new Error(json?.error || 'Failed to fetch system settings');
    }

    cachedSysSettings = json.data as SysSettingPublicData;
    return cachedSysSettings;
  })();

  try {
    return await pendingPromise;
  } finally {
    pendingPromise = null;
  }
}

export async function getSysSetting(name: string, fallback = ''): Promise<string> {
  const data = await fetchSysSettingsPublic();
  return data.by_name?.[name]?.sys_value ?? fallback;
}

export async function getSysSettingDetail(name: string, fallback = ''): Promise<string> {
  const data = await fetchSysSettingsPublic();
  return data.by_name?.[name]?.sys_value_detail ?? fallback;
}
