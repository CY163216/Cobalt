local C = select(2, ...)
local WV = C:GetModule('Vault')
local AceGUI = C.Libs.AceGUI

-- Updated Constants for TWW Vault Categories
local CATEGORIES = {
    [Enum.WeeklyRewardChestThresholdType.Activities] = "Dungeon", -- 1
    [Enum.WeeklyRewardChestThresholdType.Raid]       = "Raid",    -- 3
    [Enum.WeeklyRewardChestThresholdType.World]      = "World",   -- 6
}

function WV:Check(event, ...)
    local charKey = C.mynameRealm
    if not charKey then return end

    -- Retry on login if rewards are false, C:Debug(self, "Data not ready, retrying in 5s...")
    if not C_WeeklyRewards.HasAvailableRewards() and event == "ONENABLE" then
        C_Timer.After(5, function() self:Check("RETRY_TIMER") end)
        return
    end

    -- Log which event triggered this check
    -- local trigger = event or "MANUAL_CALL"
    -- C:Debug(self, "Check triggered by: |cff00ccff" .. trigger .. "|r")

    -- Get current week's ID to identify stale progress
    local currentWeek = C_DateAndTime.GetSecondsUntilWeeklyReset()
    local hasUncollected = C_WeeklyRewards.HasAvailableRewards()

    local charData = {
        lastUpdate = time(),
        hasReward = hasUncollected,
        categories = {}
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

    -- LOGIC: Save if they have progress OR if they have a reward waiting
    if totalProgress > 0 or hasUncollected then
        C.DB.vault[charKey] = charData
        -- C:Debug(self, string.format("Save charData, totalProgress: %s - hasUncolledted: %s", tostring(totalProgress), tostring(hasUncollected)))
    else
        C.DB.vault[charKey] = nil -- Truly empty
        -- C:Debug(self, "charData = nil")
    end
    if hasUncollected and (event == "ONENABLE" or event == "RETRY_TIMER") then C:Debug(self, "Vault reward popup.") self:ShowVaultAlert() end
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
