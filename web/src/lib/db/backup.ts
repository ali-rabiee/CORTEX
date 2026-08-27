import { z } from "zod";

import { db, TABLE_NAMES, withoutRevBump, type TableName } from "./db";

/** Versioned JSON backup envelope for export/import. */

export const BACKUP_SCHEMA_VERSION = 1;

const backupSchema = z.object({
  app: z.literal("cortex"),
  schemaVersion: z.number().int().min(1).max(BACKUP_SCHEMA_VERSION),
  exportedAt: z.string(),
  data: z.record(z.string(), z.array(z.record(z.string(), z.unknown()))),
});

export type Backup = z.infer<typeof backupSchema>;

export async function exportBackup(): Promise<Backup> {
  const data: Backup["data"] = {};
  await db.transaction("r", TABLE_NAMES as unknown as string[], async () => {
    for (const name of TABLE_NAMES) {
      data[name] = (await db.table(name).toArray()) as Array<
        Record<string, unknown>
      >;
    }
  });
  return {
    app: "cortex",
    schemaVersion: BACKUP_SCHEMA_VERSION,
    exportedAt: new Date().toISOString(),
    data,
  };
}

export function downloadBackup(backup: Backup): void {
  const blob = new Blob([JSON.stringify(backup, null, 2)], {
    type: "application/json",
  });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `cortex-backup-${backup.exportedAt.slice(0, 10)}.json`;
  a.click();
  URL.revokeObjectURL(url);
}

/** Replace ALL local progress with the backup's contents. */
export async function importBackup(
  raw: unknown,
  options: { markDirty?: boolean } = {},
): Promise<void> {
  const backup = backupSchema.parse(raw);
  const apply = () =>
    db.transaction("rw", TABLE_NAMES as unknown as string[], async () => {
      for (const name of TABLE_NAMES) {
        const table = db.table(name);
        await table.clear();
        const rows = backup.data[name as TableName];
        if (rows && rows.length > 0) {
          await table.bulkAdd(rows);
        }
      }
    });

  // A snapshot pulled from the server is already in sync; a file the user
  // imported by hand is a local change that should be pushed.
  await (options.markDirty === false ? withoutRevBump(apply) : apply());
}

export async function resetAllProgress(): Promise<void> {
  await db.transaction("rw", TABLE_NAMES as unknown as string[], async () => {
    for (const name of TABLE_NAMES) {
      await db.table(name).clear();
    }
  });
}
