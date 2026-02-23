local C = unpack(Cobalt)
local Decor = C:GetModule('Decor')

local GetItemInfo = C_Item.GetItemInfo
local SyndicatorAPI = Syndicator and Syndicator.API

--- Looks up a Decor item's lumber data by ItemID
function Decor:GetDecorData(targetID)
    local DECOR_MAP = C.DECOR_LUMBER_MAP
    local entry = DECOR_MAP and DECOR_MAP[targetID]

    if entry then
        -- entry.type is the LumberType table (e.g., IRONWOOD)
        local lumberType = entry.type
        local name = lumberType and lumberType.name or "Unknown Lumber"
        return entry, name
    end

    return nil
end

--- Parses a string of IDs (comma or space separated) and updates the active list
function Decor:UpdateIDList(inputString)
    -- Clear current session IDs
    self.activeIDs = {}

    if not inputString or inputString == "" then 
        self.inventory = {} -- Reset display inventory if input is wiped
        return 
    end

    -- Extract digits and convert to numbers
    for idStr in string.gmatch(inputString, "%d+") do
        local id = tonumber(idStr)
        if id then 
            table.insert(self.activeIDs, id) 
        end
    end

    -- Refresh the inventory counts based on the new ID list
    self:UpdateCounts()
end

function Decor:UpdateCounts()
    self.inventory = {} -- Use self instead of Decor for internal reference

    local DECOR_MAP = C.DECOR_LUMBER_MAP

    -- Safety check: Ensure our constant map exists
    if not DECOR_MAP then
        C:Debug(self, "Error: C.DECOR_LUMBER_MAP not found!")
        return
    end

    for _, itemID in ipairs(self.activeIDs or {}) do
        local entry = DECOR_MAP[itemID]

        if entry then
            local lumberType = entry.type
            local yieldCount = entry.count

            -- 1. SUM INVENTORY (Syndicator Optimization)
            local totalSum = 0
            if SyndicatorAPI then
                local info = SyndicatorAPI.GetInventoryInfoByItemID(itemID)
                if info then
                    -- Process Characters
                    if info.characters then
                        for _, charData in pairs(info.characters) do
                            totalSum = totalSum + (charData.bags or 0) + (charData.mail or 0) + 
                                       (charData.bank or 0) + (charData.auctions or 0)
                        end
                    end
                    -- Process Warband (Account-wide bank)
                    if info.warband then
                        for _, amount in pairs(info.warband) do 
                            totalSum = totalSum + (amount or 0) 
                        end
                    end
                end
            end

            -- 2. DETERMINE CATEGORY (Grouping by Expansion)
            local expLabel = (lumberType and lumberType.exp and lumberType.exp.label) or "Tracked Items"

            -- 3. BUILD DATA OBJECT
            self.inventory[expLabel] = self.inventory[expLabel] or {}

            table.insert(self.inventory[expLabel], {
                id     = itemID,
                name   = GetItemInfo(itemID) or (lumberType and lumberType.name) or ("ID: " .. itemID),
                target = yieldCount, -- The amount of lumber this decor yields
                total  = totalSum    -- Total items held across all characters/banks
            })
        end
    end
end


function Decor:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)
end
