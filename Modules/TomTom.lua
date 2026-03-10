local C = select(2, ...)
local TT = C:GetModule("TomTom")

local REAGENTS = {
    ["Alchemy"]        = "5x Moonberry Juice, 5x Fizzy Faire Drink (local vendor)",
    ["Tailoring"]      = "1x Coarse Thread, 1x Red Dye, 1x Blue Dye",
    ["Inscription"]    = "5x Light Parchment",
    ["Leatherworking"] = "10x Shiny Bauble, 5x Coarse Thread, 5x Blue Dye",
}

local PROF_ICONS = {
    ["Alchemy"] = 136240, ["Tailoring"] = 136249, ["Inscription"] = 136244,
    ["Enchanting"] = 136244, ["Engineering"] = 136243, ["Leatherworking"] = 136243,
    ["Mining"] = 136243, ["Jewelcrafting"] = 134071, ["Herbalism"] = 136246,
    ["Skinning"] = 136248, ["Blacksmithing"] = 136241, ["Cooking"] = 133971,
    ["Fishing"] = 133971, ["Archaeology"] = 463445,
}

-- The order here determines icon priority (First match wins)
local DMF_LOCATIONS = {
    { mapID = 407, x = 0.5046, y = 0.6961, profs = {"Alchemy"} },
    { mapID = 407, x = 0.5554, y = 0.5502, profs = {"Tailoring"} },
    { mapID = 407, x = 0.5322, y = 0.7581, profs = {"Inscription", "Enchanting"} },
    { mapID = 407, x = 0.4936, y = 0.6086, profs = {"Leatherworking", "Engineering", "Mining"} },
    { mapID = 407, x = 0.5500, y = 0.7077, profs = {"Jewelcrafting", "Herbalism", "Skinning"} },
    { mapID = 407, x = 0.5111, y = 0.8202, profs = {"Blacksmithing"} },
    { mapID = 407, x = 0.5281, y = 0.6799, profs = {"Cooking", "Fishing"} },
}

function TT:ClearDMFWaypoints()
    local charKey = C.mynameRealm
    local charPins = C.DB.Pins[charKey]
    if not charPins then return end
    for i = #charPins, 1, -1 do
        TomTom:RemoveWaypoint(charPins[i])
        table.remove(charPins, i)
    end
end

function TT:ProfessionsDMF()
    if not TomTom then C:Print(self, "DMF: TomTom not active!") return end
    self:ClearDMFWaypoints()

    local charKey = C.mynameRealm
    local playerHas = {}
    local profIndices = {GetProfessions()}
    for _, index in pairs(profIndices) do
        local name = GetProfessionInfo(index)
        playerHas[name] = true
    end

    local count = 0
    for _, loc in ipairs(DMF_LOCATIONS) do
        local matches = {}
        local bestIcon = nil

        for _, pName in ipairs(loc.profs) do
            if playerHas[pName] then
                table.insert(matches, pName)
                -- First match in the 'profs' table sets the icon
                bestIcon = bestIcon or PROF_ICONS[pName]

                if REAGENTS[pName] then
                    C:Print(self, string.format("|cffff0000[REAGENTS]|r %s: %s", pName, REAGENTS[pName]))
                end
            end
        end

        if #matches > 0 then
            local label = table.concat(matches, " & ")
            local uid = TomTom:AddWaypoint(loc.mapID, loc.x, loc.y, {
                title = "DMF " .. label,
                persistent = false,
                minimap_icon = bestIcon or 463445,
                worldmap_icon = bestIcon or 463445,
                minimap_icon_size = 18,
                worldmap_icon_size = 18,
            })
            table.insert(C.DB.Pins[charKey], uid)
            count = count + 1
        end
    end

    if count > 0 then
        C:Print(self, string.format("Placed %d DMF pins for %s.", count, C.myname))
    end
end

function TT:IsDMFActive()
    -- event.eventID == 479 or event.title:find("Darkmoon Faire")
    return C:CheckCalendarEvent(self, 479)
end

function TT:HandleZoneChange()
    local MIDNIGHT_ZONES = {
        [407]  = true, -- Darkmoon Faire
        -- [2393] = true, -- Midnight Silvermoon
    }
    local zoneID = C_Map.GetBestMapForUnit("player")
    if MIDNIGHT_ZONES[zoneID] then
        self:ProfessionsDMF()
    end
end

    -- C:SetModuleState(self)
function TT:OnDisable()
    self:ClearDMFWaypoints()
    C:Debug(self, "DMF inactive")
    C:Debug(self, C.MODULE_DISABLED)
end

function TT:OnEnable()
    if not self:IsDMFActive() then
        -- disable module, save it to profile
        C:SetModuleState(self)
        return false
    end

    C:Debug(self, C.MODULE_ENABLED)

    C.DB.Pins = C.DB.Pins or {}
    local charKey = C.mynameRealm
    C.DB.Pins[charKey] = C.DB.Pins[charKey] or {}

    -- Register for zone changes and quest completions
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "HandleZoneChange")
    -- self:RegisterEvent("QUEST_TURNED_IN", "ProfessionsDMF") -- Refresh pins when a quest is finished

    -- Initial check for login/reload
    C_Timer.After(3, function() self:HandleZoneChange() end)
end