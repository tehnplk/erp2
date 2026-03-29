'use client';

import { useEffect, useState } from 'react';
import { clearSysSettingCache, getSysSetting, getSysSettingDetail } from '@/lib/sys-setting';

export function useSysSetting(name: string, fallback = '') {
  const [value, setValue] = useState(fallback);

  useEffect(() => {
    let mounted = true;

    const load = async () => {
      try {
        const nextValue = await getSysSetting(name, fallback);
        if (mounted) {
          setValue(nextValue);
        }
      } catch (error) {
        console.error(`Error loading sys_setting "${name}":`, error);
        if (mounted) {
          setValue(fallback);
        }
      }
    };

    void load();

    const handleUpdate = () => {
      clearSysSettingCache();
      void load();
    };

    window.addEventListener('sys-setting-updated', handleUpdate);

    return () => {
      mounted = false;
      window.removeEventListener('sys-setting-updated', handleUpdate);
    };
  }, [fallback, name]);

  return value;
}

export function useSysSettingDetail(name: string, fallback = '') {
  const [value, setValue] = useState(fallback);

  useEffect(() => {
    let mounted = true;

    const load = async () => {
      try {
        const nextValue = await getSysSettingDetail(name, fallback);
        if (mounted) {
          setValue(nextValue);
        }
      } catch (error) {
        console.error(`Error loading sys_setting detail "${name}":`, error);
        if (mounted) {
          setValue(fallback);
        }
      }
    };

    void load();

    const handleUpdate = () => {
      clearSysSettingCache();
      void load();
    };

    window.addEventListener('sys-setting-updated', handleUpdate);

    return () => {
      mounted = false;
      window.removeEventListener('sys-setting-updated', handleUpdate);
    };
  }, [fallback, name]);

  return value;
}
