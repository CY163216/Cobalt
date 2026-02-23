local C, D = unpack(Cobalt)
local WV = C:GetModule('Vault')
local AceGUI = C.Libs.AceGUI

local _G = _G

-- Updated Constants for TWW Vault Categories
local CATEGORIES = {
    [Enum.WeeklyRewardChestThresholdType.Activities] = "Dungeon", -- 1
    [Enum.WeeklyRewardChestThresholdType.Raid]       = "Raid",    -- 3
    [Enum.WeeklyRewardChestThresholdType.World]      = "World",   -- 6
}

function WV:Check()
    local charKey = C.mynameRealm
    if not charKey then return end

    D.vault = D.vault or {}
    
    local charData = {}
    local totalProgress = 0

    for categoryID, categoryName in pairs(CATEGORIES) do
        local activities = C_WeeklyRewards.GetActivities(categoryID)
        charData[categoryName] = {}

        if activities then
            -- Sort by index to ensure slot 1, 2, 3 order
            table.sort(activities, function(a, b) return a.index < b.index end)

            for i, activity in ipairs(activities) do
                -- Sum up progress to see if character is "active"
                totalProgress = totalProgress + (activity.progress or 0)

                table.insert(charData[categoryName], {
                    index     = activity.index,
                    unlocked  = activity.progress >= activity.threshold,
                    progress  = activity.progress,
                    threshold = activity.threshold,
                    level     = activity.level,
                })
            end
        end
    end

    -- If total progress across all categories is > 0, save the data
    if totalProgress > 0 then
        D.vault[charKey] = charData
        C:Debug(self, "Updated for:", charKey)
    else
        -- Wipe the character key if they have 0 progress
        D.vault[charKey] = nil
        C:Debug(self, "(Zero Progress) for:", charKey)
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
