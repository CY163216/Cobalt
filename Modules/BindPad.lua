local C = select(2, ...)
local M = C:GetModule("BindPad")

-- HELPER: Convert "Name - Realm" to BindPad's "Realm_Name"
local function GetBindPadKey(charKey)
    local name, realm = charKey:match("^(.-)%s*-%s*(.+)$")
    if name and realm then
        return string.format("%s_%s", realm, name)
    end
    return nil
end

function M:SyncBinds()
    -- Initialize DB structure if missing
    C.DB.bindpad = C.DB.bindpad or { chars = {}, mainVersions = {}, forceSync = false, ignore = {} }

    local config = C.CLASS_PRIORITY[C.myclass]
    if not config or not C.mynameRealm then
        C:Debug(self, "No config for class:", C.myclass)
        return
    end

    -- 1. Master Version Check: Get the target version from our new DB table
    local targetVer = C.DB.bindpad.mainVersions[C.myclass] or 1
    local myCurrentVer = C.DB.bindpad.chars[C.mynameRealm] or 0
    local ignore = C.DB.bindpad.ignore[C.mynameRealm] or false

    -- skip character is it's set to ignore
    if ignore then C:Debug(self, string.format("Version set to ignore, (v%d -> v%d).", myCurrentVer, targetVer)) return end


    -- 2. Main Character Logic: Just update the DB to match the Master Version
    if C.mynameRealm == config.main then
        if myCurrentVer ~= targetVer then
            C.DB.bindpad.chars[C.mynameRealm] = targetVer
            C:Debug(self, "Main Character updated to v" .. targetVer)
        end
        return
    end

    -- 3. Sync Condition: Is forceSync on, or is the Master Version higher than ours?
    local needsSync = (targetVer > myCurrentVer)
    if needsSync then
        if not C.DB.bindpad.forceSync then
            C:Debug(self, string.format("Force Sync is OFF. Ignoring version mismatch (v%d -> v%d).", myCurrentVer, targetVer))
            return
        end
        local sourceKey = GetBindPadKey(config.main)
        if not sourceKey then 
            C:Debug(self, "Could not resolve BindPadKey for " .. config.main)
            return 
        end

        -- SAFETY: Check BindPadVars (Addon's internal DB)
        local dbKey = "PROFILE_" .. sourceKey
        if not BindPadVars or not BindPadVars[dbKey] then
            C:Print(self, "|cffff0000Error:|r BindPad profile '|cff00ff00" .. dbKey .. "|r' not found.")
            return
        end

        -- 4. Execute the Sync via BindPad API
        if BindPadCore and BindPadCore.DoCopyFrom then
            C:Print(self, string.format("Updating BindPad (v%d -> v%d) from |cff00ff00%s|r.", myCurrentVer, targetVer, config.main))

            -- Perform the actual copy
            BindPadCore.DoCopyFrom(sourceKey)

            -- 5. Update local version to match the Master Version
            C.DB.bindpad.chars[C.mynameRealm] = targetVer
        else
            C:Print(self, "|cffff0000Error:|r BindPad API not found.")
        end
    else
        C:Debug(self, "Binds are up to date (v" .. myCurrentVer .. ").")
    end
end

function M:SetupIgnoreList()
    -- 1. Ensure the ignore table exists
    if not C.DB.bindpad.ignore then C.DB.bindpad.ignore = {} end

    local count = 0
    for charKey, data in pairs(C.ROSTER) do
        -- 2. Check if the character is a banker in the hardcoded ROSTER
        if data.roles and data.roles.banker then
            
            -- 3. ONLY proceed if the key does not exist yet (is nil)
            -- This respects existing 'true' OR 'false' saved values
            if C.DB.bindpad.ignore[charKey] == nil then
                C.DB.bindpad.ignore[charKey] = true
                count = count + 1
                C:Debug(self, "New banker auto-ignored:", charKey)
            end
        end
    end

    if count > 0 then
        C:Debug(self, string.format("BindPad: %d new banker(s) initialized as ignored.", count))
    end
end

function M:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)

    self:SetupIgnoreList()

    C_Timer.After(0.1, function()
        self:SyncBinds()
    end)
end
