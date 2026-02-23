local C = select(2, ...)
local L = C:GetModule("Lumber")

local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local TooltipDataProcessor = TooltipDataProcessor

-- Tooltip callback
local function AddLumberTooltip(tooltip, data)
    local _, link = TooltipUtil.GetDisplayedItem(tooltip)
    if not link then return end

    local itemID = tonumber(link:match("item:(%d+)"))
    if not itemID then return end

    -- Updated to your new Constant name
    local mapping = C.DECOR_LUMBER_MAP[itemID]

    if mapping then
        -- Use the named keys: .type and .count
        local type = mapping.type
        local count = mapping.count

        if type and type.exp then
            local name  = type.name
            -- Use the expansion color from your C.EXPANSIONS table
            local color = type.exp.color or "|cffcccccc"

            local rightText = string.format("%s%s: %d|r", color, name, count)
            tooltip:AddDoubleLine(NORMAL_FONT_COLOR:WrapTextInColorCode("Lumber"), rightText, 1, 1, 1, 1, 1, 1)

            local gold = count * 500 * 10000
            tooltip:AddDoubleLine(" ", C_CurrencyInfo.GetCoinTextureString(gold), 1, 1, 1, 1, 1, 1)
            tooltip:AddLine(" ")
        end
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, AddLumberTooltip)

function L:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)
end