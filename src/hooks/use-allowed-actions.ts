'use client';

import { useMemo } from 'react';
import { useSession } from 'next-auth/react';
import { getAllowedActions, type PermissionAction, type PermissionModule } from '@/lib/access-control';

export function useAllowedActions(modulePath: PermissionModule) {
  const { data: session } = useSession();

  return useMemo(() => {
    const allowedActions = getAllowedActions(
      session?.user
        ? {
            role: session.user.role,
            departmentId: session.user.departmentId,
          }
        : null,
      modulePath
    );
    const hasAction = (action: PermissionAction) => allowedActions.includes(action);

    return {
      allowedActions,
      canView: hasAction('view'),
      canCreate: hasAction('create'),
      canEdit: hasAction('edit'),
      canDelete: hasAction('delete'),
    };
  }, [modulePath, session?.user?.departmentId, session?.user?.role]);
}
