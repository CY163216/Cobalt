local C = select(2, ...)
local M = C:GetModule("BindPad")

-- Localize External Addon Globals
local BPCore = BindPadCore
local BPVars = BindPadVars

-- HELPER: Convert "Name - Realm" to BindPad's "Realm_Name"
local function GetBindPadKey(charKey)
    if not charKey then return nil end
    local name, realm = charKey:match("^(.-)%s*-%s*(.+)$")
    return name and realm and string.format("%s_%s", realm, name) or nil
end

function M:SyncBinds(force)
    local db = C.DB.bindpad

    local config = C.CLASS_PRIORITY[C.myclass]
    if not config or not C.mynameRealm then
        C:Debug(self, "Missing config/name for class:", C.myclass)
        return
    end

    local myCurrentVer = db.chars[C.mynameRealm] or 0
    local targetVer = db.mainVersions[C.myclass] or 1
    local isMain = (C.mynameRealm == config.main)
    local isIgnored = db.ignore[C.mynameRealm]

    -- 1. Main Character Logic: Always just update the version tracker
    if isMain then
        if myCurrentVer ~= targetVer then
            db.chars[C.mynameRealm] = targetVer
            C:Debug(self, string.format("Main updated: v%d -> v%d", myCurrentVer, targetVer))
        end
        return
    end

    -- 2. Sync Logic
    local needsSync = (targetVer > myCurrentVer)

    -- Logic: Proceed if 'force' is true OR (version is old AND forceSync is ON AND not ignored)
    local shouldSync = force or (needsSync and db.forceSync and not isIgnored)

    if not shouldSync then
        if isIgnored and needsSync then
            C:Debug(self, string.format("Sync skipped: v%d -> v%d (Character Ignored)", myCurrentVer, targetVer))
            C:SetModuleState(self, false)
        end
        return
    end

    -- 3. Resolve Keys & API Safety
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

    -- 4. Execute Sync
    C:Print(self, string.format("%sBindPad (v%d -> v%d) from |cff00ff00%s|r.",
        force and "Force updating " or "Updating ", myCurrentVer, targetVer, config.main))

    BPCore.DoCopyFrom(sourceKey)
    db.chars[C.mynameRealm] = targetVer
end

function M:SetupIgnoreList()
    C.DB.bindpad.ignore = C.DB.bindpad.ignore or {}
    local count = 0

    for charKey, data in pairs(C.ROSTER) do
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
    -- Delay ensures BindPad has loaded its own DB first
    C_Timer.After(0.5, function() self:SyncBinds() end)
end
