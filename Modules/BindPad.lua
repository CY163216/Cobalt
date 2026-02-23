local C, D = unpack(Cobalt)
local M = C:GetModule("BindPad")

local _G = _G

-- HELPER: Convert "Name - Realm" to BindPad's "Realm_Name"
local function GetBindPadKey(charKey)
    local name, realm = charKey:match("^(.-)%s*-%s*(.+)$")
    if name and realm then
        return string.format("%s_%s", realm, name)
    end
    return nil
end

function M:SyncBinds()
    local config = C.CLASS_MAINS[C.myclass]
    if not config or not C.mynameRealm then 
        C:Debug(self, "No config for class:", C.myclass)
        return 
    end

    -- 1. Main Character Check
    if C.mynameRealm == config.main then
        C:Debug(self, "Main character detected. Skipping Sync.")
        D.bindPadVersions = D.bindPadVersions or {}
        D.bindPadVersions[C.mynameRealm] = config.version
        return
    end

    -- 2. Version Check
    D.bindPadVersions = D.bindPadVersions or {}
    local myCurrentVer = D.bindPadVersions[C.mynameRealm] or 0

    if config.version > myCurrentVer then
        local sourceKey = GetBindPadKey(config.main)
        if not sourceKey then return end

        -- SAFETY: Check BindPadVars using the "PROFILE_" prefix
        local dbKey = "PROFILE_" .. sourceKey
        if not _G.BindPadVars or not _G.BindPadVars[dbKey] then
            C:Print(self, "|cffff0000Error:|r BindPad profile '|cff00ff00" .. dbKey .. "|r' not found in database.")
            return
        end

        -- Execute Sync
        if _G.BindPadCore and _G.BindPadCore.DoCopyFrom then
            C:Print(self, string.format("Updating BindPad (v%d -> v%d) from |cff00ff00%s|r.", myCurrentVer, config.version, config.main))
            
            -- API call uses the key WITHOUT the prefix
            _G.BindPadCore.DoCopyFrom(sourceKey)
            
            D.bindPadVersions[C.mynameRealm] = config.version
        else
            C:Print(self, "|cffff0000Error:|r BindPad API not found.")
        end
    else
        C:Debug(self, "Binds are up to date.")
    end
end

function M:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)
    
    C_Timer.After(0.1, function()
        self:SyncBinds()
    end)
end
