local C = select(2, ...)
local WV = C:GetModule('Vault')

-- Updated Constants for TWW Vault Categories
local CATEGORIES = {
    [Enum.WeeklyRewardChestThresholdType.Activities] = "Dungeon", -- 1
    [Enum.WeeklyRewardChestThresholdType.Raid]       = "Raid",    -- 3
    [Enum.WeeklyRewardChestThresholdType.World]      = "World",   -- 6
}
WV.CAT_ORDER = {"Raid", "Dungeon", "World"}
WV.THRESHOLDS = { ["Raid"] = {2, 4, 6}, ["Dungeon"] = {1, 4, 8}, ["World"] = {2, 4, 8} }

function WV:Check(event, ...)
    local charKey = C.mynameRealm
    if not charKey then return end

    -- 1. Calculate Reset Timestamps
    local now = time()
    local secondsToReset = C_DateAndTime.GetSecondsUntilWeeklyReset()
    local nextReset = now + secondsToReset
    local thisWeekStart = nextReset - (7 * 24 * 60 * 60)

    local hasUncollected = C_WeeklyRewards.HasAvailableRewards()

    -- 2. Retry Logic: Check for nil/loading state specifically
    if not hasUncollected and event == "ONENABLE" then
        -- C:Debug(self, "Data not ready, retrying in 5s...")
        C_Timer.After(5, function() self:Check("RETRY_TIMER") end)
        return
    end

    -- 3. Handle Archiving OLD Data to C.DB.vault[charKey].lastReset
    local existingData = C.DB.vault[charKey]
    local archivedReset = nil

    if existingData and existingData.lastUpdate and existingData.lastUpdate < thisWeekStart then
        -- Preserve the old data into a local variable to re-insert it later
        archivedReset = {
            categories = existingData.categories,
            lastUpdate = existingData.lastUpdate,
            wasCollected = not hasUncollected
        }
        C:Debug(self, "Archiving previous week data for this character.")
    elseif existingData and existingData.lastReset then
        -- If current data isn't old, but we already have an archive, keep it!
        archivedReset = existingData.lastReset
    end

    -- 4. Gather Current Week Data
    local charData = {
        lastUpdate = now,
        hasReward = hasUncollected or false,
        categories = {},
        lastReset = archivedReset -- Nested archive inside the character's entry
    }

    local totalProgress = 0
    for categoryID, categoryName in pairs(CATEGORIES) do
        local activities = C_WeeklyRewards.GetActivities(categoryID)
        if activities and #activities > 0 then
            charData.categories[categoryName] = {}
            for _, activity in ipairs(activities) do
                totalProgress = totalProgress + (activity.progress or 0)
                table.insert(charData.categories[categoryName], {
                    progress = activity.progress,
                    threshold = activity.threshold,
                    level = activity.level,
                })
            end
        end
    end

    -- 5. Save Logic
    if totalProgress > 0 or hasUncollected then
        C.DB.vault[charKey] = charData
    else
        -- Only wipe if there's no archive to save either
        if not archivedReset then
            C.DB.vault[charKey] = nil
        else
            -- Keep the entry just for the archive
            C.DB.vault[charKey] = { lastReset = archivedReset, lastUpdate = now }
        end
    end

    -- 6. UI Trigger
    if hasUncollected and (event == "ONENABLE" or event == "RETRY_TIMER") then
        C:Debug(self, "Vault reward popup.")
        self:ShowVaultAlert()
    end
end

function WV:GetActiveVaultAlts()
    local charKey = C.mynameRealm
    if not C.DB.vault then return { charKey } end

    -- Calculate Reset once
    local now = time()
    local thisWeekStart = (now + C_DateAndTime.GetSecondsUntilWeeklyReset()) - 604800

    local sortedNames = { charKey }
    local others = {}

    for name, data in pairs(C.DB.vault) do
        if name ~= charKey then
            local isStale = data.lastUpdate and data.lastUpdate < thisWeekStart
            local isActive = data.hasReward or isStale

            -- Only check categories if not already flagged active
            if not isActive and data.categories then
                for catName, slots in pairs(data.categories) do
                    local t = WV.THRESHOLDS[catName]
                    local maxP = 0
                    for i=1, #slots do
                        if (slots[i].progress or 0) > maxP then maxP = slots[i].progress end
                    end
                    if t and maxP >= t[1] then isActive = true; break end
                end
            end
            if isActive then others[#others + 1] = name end
        end
    end

    table.sort(others)
    for i=1, #others do sortedNames[#sortedNames + 1] = others[i] end

    return sortedNames, thisWeekStart
end

-- ##DEBUG Not being used
function WV:ClearStaleProgress()
    local lastReset = self:GetLastResetTime() -- Function from previous step

    for charKey, data in pairs(C.DB.vault) do
        -- If data is from last week
        if (data.lastUpdate or 0) < lastReset then
            if data.hasReward then
                -- Keep the entry, but clear the progress bars
                data.categories = {}
                C:Debug(self, charKey .. " has old rewards; hiding progress but keeping alert.")
            else
                -- No reward and old data? Wipe it.
                C.DB.vault[charKey] = nil
            end
        end
    end
end

-- 1. Define the dialog (Do this once, outside the function)
StaticPopupDialogs["WV_VAULT_ALERT"] = {
    text = "|cff00ff00You have rewards waiting!\n",
    button1 = "Understood",
    OnAccept = function()
        -- Logic for when they click "Understood"
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3, -- Prevents UI taint in modern WoW
}

-- 2. The function to show it
function WV:ShowVaultAlert()
    if self.alertShown then return end
    self.alertShown = true

    StaticPopup_Show("WV_VAULT_ALERT")
end

function WV:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)

    self:RegisterEvent("WEEKLY_REWARDS_UPDATE", "Check")
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED", "Check")
    self:RegisterEvent("BOSS_KILL", "Check")

    self:Check("ONENABLE")
end
