local C = select(2, ...)
local M = C:GetModule("ElvProfile")

local DEFAULT_PROFILES = {
    MAIN = "midnight",
    ALT  = "banker",
    PRIVATE = "midnight"
}

StaticPopupDialogs["COBALT_RELOAD_REQUIRED"] = {
    text = "|cff00aaffCobalt:|r ElvUI profiles updated. Reload required.",
    button1 = "Reload UI",
    button2 = "Later",
    OnAccept = ReloadUI,
    timeout = 0, whileDead = true, hideOnEscape = true,
}

-- Re-implemented for external module compatibility
-- Returns: currentProfileName, isStandardProfile
function M:GetProfileStatus()
    local nameKey = C.mynameRealm
    local currentProfile = ElvDB and ElvDB.profileKeys and ElvDB.profileKeys[nameKey]

    -- Check if the current profile is one of our defaults
    local isStandard = (currentProfile == DEFAULT_PROFILES.MAIN) or (currentProfile == DEFAULT_PROFILES.ALT)

    return currentProfile, isStandard
end

function M:CheckAndSetProfiles()
    if not (ElvDB and ElvPrivateDB) then return end

    local nameKey = C.mynameRealm
    local currentSaved = C.DB.elvui[nameKey]
    local currentElv = ElvDB.profileKeys[nameKey]
    local needsReload = false

    -- 1. INITIAL SETUP: Only runs if DB is empty/false
    if not currentSaved or currentSaved == "" then
        local isMain = C.ROSTER[nameKey] and C.ROSTER[nameKey].roles.main
        local target = isMain and DEFAULT_PROFILES.MAIN or DEFAULT_PROFILES.ALT

        ElvDB.profileKeys[nameKey] = target
        C.DB.elvui[nameKey] = target
        needsReload = true
    else
        -- 2. MAINTENANCE: Sync Cobalt DB with user's manual ElvUI changes
        if currentSaved ~= currentElv then
            C.DB.elvui[nameKey] = currentElv
            C:Debug(self, string.format("Syncing Cobalt DB to manual profile: [|cff00ff00%s|r]", currentElv))
        end
    end

    -- 3. PRIVATE PROFILE: Force layout/skins to match Cobalt's standard
    if ElvPrivateDB.profileKeys[nameKey] ~= DEFAULT_PROFILES.PRIVATE then
        ElvPrivateDB.profileKeys[nameKey] = DEFAULT_PROFILES.PRIVATE
        needsReload = true
    end

    if needsReload then
        StaticPopup_Show("COBALT_RELOAD_REQUIRED")
    end
end

function M:OnEnable()
    if not C_AddOns.IsAddOnLoaded("ElvUI") then return end

    -- We run every load because 'Maintenance' needs to check if the user
    -- swapped profiles via the ElvUI menu during the last session.
    self:CheckAndSetProfiles()
end
