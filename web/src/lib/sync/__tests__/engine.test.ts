import { describe, expect, test } from "vitest";

import { decideSync, type SyncInputs } from "../engine";

const base: SyncInputs = {
  remoteVersion: 0,
  remoteHasBlob: false,
  baseVersion: 0,
  localRev: 0,
  lastSyncedRev: 0,
  hasLocalData: false,
};

const at = (overrides: Partial<SyncInputs>) => decideSync({ ...base, ...overrides });

describe("decideSync", () => {
  test("fresh install, empty server: nothing to do", () => {
    expect(at({})).toBe("noop");
  });

  test("first sync of a device that already has local progress: push", () => {
    expect(at({ hasLocalData: true, localRev: 42 })).toBe("push");
  });

  test("local writes since last sync: push", () => {
    expect(
      at({
        remoteVersion: 7,
        remoteHasBlob: true,
        baseVersion: 7,
        localRev: 12,
        lastSyncedRev: 9,
        hasLocalData: true,
      }),
    ).toBe("push");
  });

  test("in sync and unchanged: nothing to do", () => {
    expect(
      at({
        remoteVersion: 7,
        remoteHasBlob: true,
        baseVersion: 7,
        localRev: 9,
        lastSyncedRev: 9,
        hasLocalData: true,
      }),
    ).toBe("noop");
  });

  test("another device pushed and we have no local writes: pull", () => {
    expect(
      at({
        remoteVersion: 8,
        remoteHasBlob: true,
        baseVersion: 7,
        localRev: 9,
        lastSyncedRev: 9,
        hasLocalData: true,
      }),
    ).toBe("pull");
  });

  test("brand-new device joining an existing account: pull", () => {
    expect(at({ remoteVersion: 3, remoteHasBlob: true })).toBe("pull");
  });

  test("both sides moved: ask the user rather than pick a winner", () => {
    expect(
      at({
        remoteVersion: 8,
        remoteHasBlob: true,
        baseVersion: 7,
        localRev: 15,
        lastSyncedRev: 9,
        hasLocalData: true,
      }),
    ).toBe("conflict");
  });

  test("a device with weeks of offline progress never silently loses it", () => {
    // Used locally for a long time, only now pointed at a server that has data.
    expect(
      at({
        remoteVersion: 20,
        remoteHasBlob: true,
        baseVersion: 0,
        localRev: 500,
        lastSyncedRev: 0,
        hasLocalData: true,
      }),
    ).toBe("conflict");
  });

  test("server was wiped: restore it from this device, don't wipe the device", () => {
    expect(
      at({
        remoteVersion: 0,
        remoteHasBlob: false,
        baseVersion: 12,
        localRev: 30,
        lastSyncedRev: 30,
        hasLocalData: true,
      }),
    ).toBe("push");
  });
});
