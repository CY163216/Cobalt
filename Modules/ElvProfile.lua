local C = select(2, ...)
local M = C:GetModule("ElvProfile")

-- Constants
local TARGET_PROFILE = "midnight"
local TARGET_PROFILE_PRIVATE = "midnight"

StaticPopupDialogs["COBALT_RELOAD_REQUIRED"] = {
    text = "|cff00aaffCobalt:|r ElvUI profiles updated to '|cff00ff00" .. TARGET_PROFILE .. "|r'. Reload required.",
    button1 = "Reload UI",
    button2 = "Later",
    OnAccept = function() ReloadUI() end,
    timeout = 0, whileDead = true, hideOnEscape = true,
}

-- Check if this character is already flagged with ANY status
function M:GetProfileStatus()
    local val = C.DB.elvui[C.mynameRealm]
    local roleMatch = C.ROSTER[C.mynameRealm].roles[val]
    local isMain = C.ROSTER[C.mynameRealm].roles.main

    -- Check if it's a string and NOT the literal "true"
    if (type(val) == "string" and val ~= "true" and isMain) or (type(val) == "string" and roleMatch) then
        return val
    end

    -- Fallback for booleans, nil, or the string "true"
    return false
end

-- Save specific status (e.g., true, "banker", "manual", or specific Profile Name)
function M:SetProfileStatus(status)
    C.DB.elvui = C.DB.elvui or {}
    C.DB.elvui[C.mynameRealm] = status
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

    local isMain = C.ROSTER[C.mynameRealm].roles.main
    if not isMain then TARGET_PROFILE = "banker" C:Print(self, string.format("Alt character detected. Switching to |cff00ff00%s|r", TARGET_PROFILE)) end

    -- 1. Check Global Profile
    if ElvDB.profileKeys then
        local currentGlobal = ElvDB.profileKeys[C.mynameRealm]
        if currentGlobal == TARGET_PROFILE then
            C:Debug(self, string.format("Profile match: %s. No action required.", currentGlobal))
            globalMatch = true
        elseif (currentGlobal == "Default") or (not isMain and (currentGlobal == "midnight")) then
            local reason = (currentGlobal == "Default") and "Default Profile" or "Non-Main on Midnight"
            C:Print(self, string.format("[%s] detected. Switching to |cff00ff00%s|r", reason, TARGET_PROFILE))
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
        if currentPrivate == TARGET_PROFILE_PRIVATE then
            privateMatch = true
        else
            C:Print(self, string.format("Private Profile mismatch: |cffff0000%s|r", currentPrivate or "None"))
            ElvPrivateDB.profileKeys[C.mynameRealm] = TARGET_PROFILE_PRIVATE
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

    if currentStatus == "main" then
        C:Debug(self, "Skipping: Main character [|cff00ff00" .. tostring(currentStatus) .. "|r]")
        return
    elseif currentStatus then
        C:Debug(self, "Skipping: ROSTER role matches profile [|cff00ff00" .. tostring(currentStatus) .. "|r]")
        return
    end

    if C:HasRole(C.mynameRealm, "banker") then
        local statusType = "banker"
        C:Debug(self, "Character found in ROSTER. Auto-marking as:", statusType)
        self:SetProfileStatus(statusType)
        return
    end

    self:CheckAndSetProfiles()
end
