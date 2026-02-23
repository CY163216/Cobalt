local C, D = unpack(Cobalt)
local M = C:GetModule("ElvProfile")

local _G = _G

-- Constants
local TARGET_PROFILE = "midnight"

local IgnoreList = {
    ["Melios"] = "banker", 
    ["Kujaku"] = "banker", 
    ["Jisumi"] = "banker",
    ["Shipusuheddo"] = "banker", 
    ["Kozaburo"] = "banker", 
    ["Kurogan"] = "banker", 
    ["Cygnax"] = "banker"
}

StaticPopupDialogs["COBALT_RELOAD_REQUIRED"] = {
    text = "|cff00aaffCobalt:|r ElvUI profiles updated to '|cff00ff00" .. TARGET_PROFILE .. "|r'. Reload required.",
    button1 = "Reload UI",
    button2 = "Later",
    OnAccept = function() ReloadUI() end,
    timeout = 0, whileDead = true, hideOnEscape = true,
}

-- Check if this character is already flagged with ANY status
function M:GetProfileStatus()
    return D.elvui and D.elvui[C.mynameRealm]
end

-- Save specific status (e.g., true, "banker", "manual", or specific Profile Name)
function M:SetProfileStatus(status)
    D.elvui = D.elvui or {}
    D.elvui[C.mynameRealm] = status
    C:Debug(self, "Status set to [|cff00ff00" .. tostring(status) .. "|r] in SavedVariables.")
end

function M:CheckAndSetProfiles()
    local ElvDB = ElvDB
    local ElvPrivateDB = ElvPrivateDB
    
    if not ElvDB or not ElvPrivateDB then
        C:Debug(self, "|cffff0000Error:|r ElvUI SavedVariables not found.")
        return
    end

    local needsReload = false
    local globalMatch = false
    local privateMatch = false
    local customGlobalName = nil

    -- 1. Check Global Profile
    if ElvDB.profileKeys then
        local currentGlobal = ElvDB.profileKeys[C.mynameRealm]
        if currentGlobal == TARGET_PROFILE then
            globalMatch = true
        elseif currentGlobal == "Default" then
            C:Print(self, string.format("Default Global Profile detected. Switching to |cff00ff00%s|r", TARGET_PROFILE))
            ElvDB.profileKeys[C.mynameRealm] = TARGET_PROFILE
            needsReload = true
        else
            C:Debug(self, "Global Profile is [|cff00ff00" .. currentGlobal .. "|r]. Skipping Global update.")
            -- Capture the custom profile name to use as the status
            customGlobalName = currentGlobal
            globalMatch = true 
        end
    end

    -- 2. Check Private Profile
    if ElvPrivateDB.profileKeys then
        local currentPrivate = ElvPrivateDB.profileKeys[C.mynameRealm]
        if currentPrivate == TARGET_PROFILE then
            privateMatch = true
        else
            C:Print(self, string.format("Private Profile mismatch: |cffff0000%s|r", currentPrivate or "None"))
            ElvPrivateDB.profileKeys[C.mynameRealm] = TARGET_PROFILE
            needsReload = true
        end
    end

    -- 3. Logic for Saving Status
    if globalMatch and privateMatch then
        -- Use the custom profile name as status if it was skipped, otherwise use true
        local statusValue = customGlobalName or TARGET_PROFILE
        self:SetProfileStatus(statusValue)
    elseif needsReload then
        StaticPopup_Show("COBALT_RELOAD_REQUIRED")
    end
end

function M:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)
    
    if not C_AddOns.IsAddOnLoaded("ElvUI") then
        C:Debug(self, "ElvUI is not enabled or loaded. Skipping profile check.")
        return
    end    
    local currentStatus = self:GetProfileStatus()
    
    if currentStatus then
        C:Debug(self, "Skipping: Status is already [|cff00ff00" .. tostring(currentStatus) .. "|r]")
        return
    end

    if IgnoreList[C.myname] then 
        local statusType = IgnoreList[C.myname]
        C:Debug(self, "Character in IgnoreList. Auto-marking as:", statusType)
        self:SetProfileStatus(statusType)
        return 
    end

    self:CheckAndSetProfiles()
end
