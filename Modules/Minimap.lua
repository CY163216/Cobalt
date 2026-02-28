local C = select(2, ...)
local M = C:GetModule("Minimap")
local P = C:GetModule("Panel", true)
local LDB = C.Libs.LDB
local LDBI = C.Libs.LDBI

function M:OnInitialize()
    self.obj = LDB:NewDataObject("Cobalt", {
        type = "launcher",
        text = "Cobalt",
        icon = "Interface\\Icons\\inv_cosmicvoid_orb",

        OnClick = function(_, button)
            if button == "LeftButton" then
                -- Call the Toggle function from Panel.lua
                if P and P.Toggle then
                    P:Toggle()
                else
                    C:Print(self, "Error: Panel module not found.")
                end
            elseif button == "RightButton" then
                C.DB.clickCount = (C.DB.clickCount or 0) + 1
                C:Print(self, "Right-clicks: " .. C.DB.clickCount)
            end
        end,

        OnTooltipShow = function(tooltip)
            tooltip:AddLine("Cobalt")
            tooltip:AddLine("|cff00ff00Left-Click:|r Toggle Panel")
            tooltip:AddLine("|cff00ff00Right-Click:|r Count (" .. (C.DB.clickCount or 0) .. ")")
            tooltip:Show()
        end,
    })
end

function M:HandleCommand(input)
    local command = self:GetArgs(input, 1)
    command = (command and command:lower()) or ""

    -- If no argument is given, or they specifically say "toggle"
    if command == "" or command == "toggle" then
        P:Toggle()
    elseif command == "help" then
        C:Print("Usage: /cobalt [toggle | help]")
    else
        C:Print("Unknown command. Type /cobalt help for info.")
    end
end


function M:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)

    if not C.DB.minimap then C.DB.minimap = {} end
    if not LDBI:IsRegistered("Cobalt") then
        LDBI:Register("Cobalt", self.obj, C.DB.minimap)
    end

    LDBI:Refresh("Cobalt", C.DB.minimap)

    C:RegisterChatCommand("cobalt", function(input)
        self:HandleCommand(input)
    end)
end


