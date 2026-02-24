local C = select(2, ...)
local WV = C:GetModule('Vault')
local AceGUI = C.Libs.AceGUI

-- Updated Constants for TWW Vault Categories
local CATEGORIES = {
    [Enum.WeeklyRewardChestThresholdType.Activities] = "Dungeon", -- 1
    [Enum.WeeklyRewardChestThresholdType.Raid]       = "Raid",    -- 3
    [Enum.WeeklyRewardChestThresholdType.World]      = "World",   -- 6
}

function WV:Check()
    local charKey = C.mynameRealm
    if not charKey then return end

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
    else
        C.DB.vault[charKey] = nil -- Truly empty
    end
end

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

function WV:ShowVaultAlert()
    if self.alertShown then return end -- Safety check
    self.alertShown = true

    local frame = AceGUI:Create("Window")
    frame:SetTitle("Vault Alert")
    frame:SetWidth(250)
    frame:SetHeight(120)
    frame:SetLayout("List")
    frame:EnableResize(false)
    -- Center it on screen
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)

    local label = AceGUI:Create("Label")
    label:SetText("\n   |cff00ff00You have rewards waiting|r\n   in the Great Vault!")
    label:SetFullWidth(true)
    frame:AddChild(label)

    local btn = AceGUI:Create("Button")
    btn:SetText("Understood")
    btn:SetFullWidth(true)
    btn:SetCallback("OnClick", function() frame:Hide() end)
    frame:AddChild(btn)

    -- Close automatically if the user enters combat
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
end

function WV:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)

    self:RegisterEvent("WEEKLY_REWARDS_UPDATE", "Check")
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED", "Check")
    self:RegisterEvent("BOSS_KILL", "Check")

    self:Check()

    -- LOGIN CHECK: Only trigger if rewards are waiting to be claimed
    if C_WeeklyRewards.HasAvailableRewards() then
        -- Small delay to ensure the UI is fully loaded before popping the window
        C_Timer.After(3, function()
            self:ShowVaultAlert()
        end)
    end
end
