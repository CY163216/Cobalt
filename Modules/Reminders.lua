local C = select(2, ...)
local M = C:GetModule("Reminders")

-- The on-screen display frame
local Display = CreateFrame("Frame", "CobaltMidnightReminders", UIParent)
Display:SetSize(250, 150)
Display:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 150, -250)

Display.text = Display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Display.text:SetPoint("TOPLEFT")
Display.text:SetJustifyH("LEFT")

-- MUST be defined as M:UpdateDisplay so REM:UpdateDisplay() works in Panel
function M:UpdateDisplay()
    local charKey = C.mynameRealm
    if not C.DB.reminders or not C.DB.reminders[charKey] then
        Display.text:SetText("")
        return
    end

    local notes = C.DB.reminders[charKey]
    local displayStr = ""
    local hasContent = false

    for _, note in ipairs(notes) do
        if not note.hidden then
            if not hasContent then
                displayStr = "|cff00aaff[ Reminders ]|r\n"
                hasContent = true
            end
            displayStr = displayStr .. "|cffffffff- " .. note.text .. "|r\n"
        end
    end

    Display.text:SetText(displayStr)
end

function M:OnInitialize()
    C.DB.reminders = C.DB.reminders or {}
    C.DB.reminders[C.mynameRealm] = C.DB.reminders[C.mynameRealm] or {}
end

function M:OnEnable()
    self:UpdateDisplay()
end
