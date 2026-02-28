
local C = select(2, ...)
local WM = C:GetModule('Warmode')
local LSM = C.Libs.LSM

-- Configuration
local FADE_TIME = 0.4
local TEXT_COLOR = {1, 0.2, 0.2}
local FONT_SIZE = 34

function WM:CreateFrame()
    if self.frame then return end

    -- Fetch font from SharedMedia via Cobalt's Libs table
    local fontPath = (LSM and LSM:Fetch("font", "TeX Bold")) or [[Fonts\FRIZQT__.TTF]]

    local f = CreateFrame("Frame", "Cobalt_WM_AlertFrame", UIParent)
    f:SetSize(500, 70)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 350)
    f:SetAlpha(0)
    f:Hide()

    local t = f:CreateFontString(nil, "OVERLAY")
    t:SetFont(fontPath, FONT_SIZE, "OUTLINE")
    t:SetAllPoints(f)
    t:SetJustifyH("CENTER")
    t:SetTextColor(unpack(TEXT_COLOR))
    t:SetText("WAR MODE ACTIVE (RESTING)")

    f.text = t
    self.frame = f
end

function WM:Update()
    if not self.frame then return end

    local isDesired = C_PvP.IsWarModeDesired()
    local isResting = IsResting()
    local showWarning = isDesired and isResting

    if showWarning then
        self.frame:Show()
        UIFrameFadeIn(self.frame, FADE_TIME, self.frame:GetAlpha(), 1)
    else
        UIFrameFadeOut(self.frame, FADE_TIME, self.frame:GetAlpha(), 0)
        -- Hide frame after fade to prevent it blocking clicks
        C_Timer.After(FADE_TIME, function()
            if not C_PvP.IsWarModeDesired() or not IsResting() then
                self.frame:Hide()
            end
        end)
    end
end

function WM:OnInitialize()
    self:CreateFrame()

    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
    self:RegisterEvent("PLAYER_UPDATE_RESTING", "OnEvent")
    self:RegisterEvent("WAR_MODE_STATUS_UPDATE", "OnEvent")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnEvent")
    self:RegisterEvent("ZONE_CHANGED", "OnEvent")
    self:RegisterEvent("PLAYER_FLAGS_CHANGED", "OnEvent")
end

function WM:OnDisable()
    -- Ace3 automatically unregisters events/hooks registered via Ace3 mixins
    -- But you can add manual cleanup here if needed
    self.frame:Hide()
    C:Debug(self, C.MODULE_DISABLED)
end

function WM:OnEvent(event)
    -- C:Debug(self, "Warmode Update Triggered: " .. (event or "Initial"))
    self:Update()
end

function WM:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)

    self:Update()
end
