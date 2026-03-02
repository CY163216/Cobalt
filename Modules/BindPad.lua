local C = select(2, ...)
local M = C:GetModule("BindPad")

-- Localize External Addon Globals
local BPCore = BindPadCore
local BPVars = BindPadVars

-- HELPER: Convert "Name - Realm" to BindPad's "Realm_Name"
local function GetBindPadKey(charKey)
    local name, realm = charKey:match("^(.-)%s*-%s*(.+)$")
    return name and realm and string.format("%s_%s", realm, name) or nil
end

function M:SyncBinds(force)
    -- Initialize DB structure
    C.DB.bindpad = C.DB.bindpad or { chars = {}, mainVersions = {}, forceSync = false, ignore = {} }
    local db = C.DB.bindpad

    local config = C.CLASS_PRIORITY[C.myclass]
    if not config or not C.mynameRealm then
        C:Debug(self, "Missing config or character name for class:", C.myclass)
        return
    end

    local myCurrentVer = db.chars[C.mynameRealm] or 0
    local targetVer = db.mainVersions[C.myclass] or 1
    local isMain = (C.mynameRealm == config.main)
    local isIgnored = db.ignore[C.mynameRealm]

    -- 1. Main Character Logic
    if isMain then
        if myCurrentVer ~= targetVer then
            db.chars[C.mynameRealm] = targetVer
            C:Debug(self, string.format("Main updated: v%d -> v%d", myCurrentVer, targetVer))
        end
        return
    end

    -- 2. Skip checks
    if isIgnored then
        C:Debug(self, "Character ignored. Skipping sync.")
        return
    end

    -- 3. Determine if sync is required
    local needsSync = (targetVer > myCurrentVer)
    if not (force or (needsSync and db.forceSync)) then
        C:Debug(self, string.format("Sync not required or forceSync OFF (v%d/v%d).", myCurrentVer, targetVer))
        return
    end

    -- 4. Safety & API Checks
    local sourceKey = GetBindPadKey(config.main)
    local dbKey = sourceKey and ("PROFILE_" .. sourceKey)

    if not (BPCore and BPCore.DoCopyFrom) then
        C:Print(self, "|cffff0000Error:|r BindPad API not found.")
        return
    end

    if not (BPVars and BPVars[dbKey]) then
        C:Print(self, string.format("|cffff0000Error:|r Profile '|cff00ff00%s|r' not found.", dbKey or "Unknown"))
        return
    end

    -- 5. Execute Sync
    C:Print(self, string.format("Syncing BindPad (v%d -> v%d) from |cff00ff00%s|r.", myCurrentVer, targetVer, config.main))
    BPCore.DoCopyFrom(sourceKey)
    db.chars[C.mynameRealm] = targetVer
end

function M:SetupIgnoreList()
    C.DB.bindpad.ignore = C.DB.bindpad.ignore or {}
    local count = 0

    for charKey, data in pairs(C.ROSTER) do
        -- Auto-ignore bankers if not already explicitly set
        if data.roles and data.roles.banker and C.DB.bindpad.ignore[charKey] == nil then
            C.DB.bindpad.ignore[charKey] = true
            count = count + 1
        end
    end

    if count > 0 then
        C:Debug(self, string.format("Initialized %d new banker(s) as ignored.", count))
    end
end

function M:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)
    self:SetupIgnoreList()
    C_Timer.After(0.1, function() self:SyncBinds() end)
end
