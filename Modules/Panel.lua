local C = select(2, ...)
local Panel = C:GetModule("Panel")
local BP = C:GetModule("BindPad")
local DC = C:GetModule("Decor")
local EP = C:GetModule("ElvProfile")
local Dev = C:GetModule("Dev")
local WV = C:GetModule("Vault")
local AceGUI = C.Libs.AceGUI

local _G = _G

local GetCoinTextureString = _G.C_CurrencyInfo.GetCoinTextureString
local GameTooltip = _G.GameTooltip
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

-- Reference your updated constants (Panel UpdateDecor)
local DECOR_MAP = C.DECOR_LUMBER_MAP
local DEFAULT_COLOR = "|cffffffff"
local STOCK_COLOR = "|cff00ff00"

-- Configuration & Constants
local UI_CONFIG = {
    WIDTH = 750,
    HEIGHT = 700,
    MIN_WIDTH = 600,
    MIN_HEIGHT = 350,
    SIDEBAR_WIDTH = 196, -- Increased for wider buttons
    BUTTON_WIDTH = 176,  -- Wider buttons
    RIGHT_PADDING = 40,  -- Reduced padding to close the gap
}

local NAV_MENU = {
    -- { name = "General",    method = "UpdateGeneral" },
    { name = "Vault",      method = "UpdateVault" },
    { name = "Quests",     method = "UpdateQuests" },
    { name = "Decor",      method = "UpdateDecor" },
    { name = "BindPad",    method = "UpdateBindPad" },
    { name = "ElvUI",      method = "UpdateElvProfile" },
    { name = "Dev",        method = "UpdateDev" }
}

-- Content Management (The Dispatcher)
function Panel:RefreshContent()
    if not self.contentFrame then return end
    self.contentFrame:ReleaseChildren()

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("List")
    scroll:SetFullHeight(true)
    scroll:SetFullWidth(true)
    self.contentFrame:AddChild(scroll)

    local currentTab = self.selectedTab or "General"
    self.contentFrame:SetTitle("Cobalt - " .. currentTab)

    -- Refresh the sidebar buttons to update the disabled (greyed out) state
    self:UpdateNavigation()

    local methodName = nil
    for _, item in ipairs(NAV_MENU) do
        if item.name == currentTab then methodName = item.method break end
    end

    if methodName and self[methodName] then
        self[methodName](self, scroll)
    else
        local label = AceGUI:Create("Label")
        label:SetText("|cffff0000Error:|r Method for '" .. tostring(currentTab) .. "' not found.")
        scroll:AddChild(label)
    end
end

-- Helper to rebuild sidebar buttons with "Selected" state
function Panel:UpdateNavigation()
    if not self.sidebar then return end
    self.sidebar:ReleaseChildren()

    for _, item in ipairs(NAV_MENU) do
        local btn = AceGUI:Create("Button")
        btn:SetText(item.name)
        btn:SetWidth(UI_CONFIG.BUTTON_WIDTH)
        if self.selectedTab == item.name then
            btn.frame:SetHighlightLocked(true)
        else
            btn.frame:SetHighlightLocked(false)
        end

        btn:SetCallback("OnClick", function()
            self.selectedTab = item.name
            -- Module specific logic
            -- if item.name == "Quests" then C:GetModule("QuestTracker"):UpdateQuestStatus() end
            -- if item.name == "Vault" then C:GetModule("vault"):Check() end
            -- if item.name == "Decor" then C:GetModule("Decor"):UpdateCounts() end

            self:RefreshContent()
        end)
        self.sidebar:AddChild(btn)
    end
end

--#region DECOR TAB
function Panel:UpdateDecor(container)
    -- --- SECTION 1: CONFIGURATION (As before) ---
    local configGroup = AceGUI:Create("InlineGroup")
    configGroup:SetTitle("Tracker Configuration")
    configGroup:SetFullWidth(true)
    configGroup:SetLayout("Flow")
    container:AddChild(configGroup)

    local editbox = AceGUI:Create("MultiLineEditBox")
    editbox:SetLabel("Paste Item IDs (comma separated):")
    editbox:SetFullWidth(true)
    editbox:SetNumLines(2)
    if DC.activeIDs and #DC.activeIDs > 0 then
        editbox:SetText(table.concat(DC.activeIDs, ", "))
    end
    editbox:SetCallback("OnEnterPressed", function(_, _, value)
        DC:UpdateIDList(value)
        self:RefreshContent()
    end)
    configGroup:AddChild(editbox)

    -- --- SECTION 2: CONSOLIDATED ITEM LIST ---
    if not DC.inventory or next(DC.inventory) == nil then
        local empty = AceGUI:Create("Label")
        empty:SetText("\n|cff808080No active items tracked.|r")
        empty:SetFullWidth(true)
        container:AddChild(empty)
        return
    end

    local mainGroup = AceGUI:Create("ScrollFrame")
    mainGroup:SetFullWidth(true)
    mainGroup:SetLayout("Flow")
    container:AddChild(mainGroup)

    for categoryName, items in pairs(DC.inventory) do
        -- Category Header (Inside the main group)
        local header = AceGUI:Create("Heading")
        header:SetText(categoryName)
        header:SetFullWidth(true)
        mainGroup:AddChild(header)

        for _, item in ipairs(items) do
            local row = AceGUI:Create("SimpleGroup")
            row:SetLayout("Flow")
            row:SetFullWidth(true)
            mainGroup:AddChild(row)

            -- 1. ASYNC DATA FETCH (Fixes the naming issue)
            local nameLabel = AceGUI:Create("InteractiveLabel")
            nameLabel:SetText("|cff808080Loading...|r") -- Placeholder
            nameLabel:SetWidth(180)

            -- Use Mixin to force server query for missing item names
            local itemObj = Item:CreateFromItemID(item.id)
            itemObj:ContinueOnItemLoad(function()
                local realName = itemObj:GetItemName()
                local itemData = DECOR_MAP[item.id]
                local expColor = (itemData and itemData.type and itemData.type.exp) and itemData.type.exp.color or "|cffffffff"

                nameLabel:SetText(expColor .. realName .. "|r")
            end)

            nameLabel:SetCallback("OnEnter", function(widget)
                GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
                GameTooltip:SetHyperlink("item:" .. item.id)
                GameTooltip:Show()
            end)
            nameLabel:SetCallback("OnLeave", function() GameTooltip:Hide() end)
            row:AddChild(nameLabel)

            -- 2. STOCK & PRICE
            local stockLabel = AceGUI:Create("Label")
            local countColor = (item.total >= 1) and "|cff00ff00" or "|cff808080"
            stockLabel:SetText(string.format("%s%d units|r", countColor, item.total))
            stockLabel:SetWidth(80)
            row:AddChild(stockLabel)

            local priceLabel = AceGUI:Create("Label")
            local itemCostInCopper = (item.target or 0) * 500 * 10000
            priceLabel:SetText(GetCoinTextureString(itemCostInCopper))
            priceLabel:SetWidth(120)
            priceLabel:SetJustifyH("RIGHT")
            row:AddChild(priceLabel)
        end
    end
end
--#endregion

--#region MARK: BINDPAD SYNC TAB
function Panel:UpdateBindPad(container)
    -- Instant lookup using your new static map
    local config = C.CLASS_PRIORITY[C.myclass]

    -- --- SECTION 1: HEADER & STATUS ---
    local header = AceGUI:Create("Heading")
    header:SetText("BindPad Synchronization")
    header:SetFullWidth(true)
    container:AddChild(header)

    if not config or not C.mynameRealm then
        local errorLabel = AceGUI:Create("Label")
        errorLabel:SetText("\n|cffff0000Error:|r No config found for " .. (C.myclass or "Unknown"))
        errorLabel:SetFullWidth(true)
        container:AddChild(errorLabel)
        return
    end

    -- 1. Status Card (InlineGroup)
    local statusGroup = AceGUI:Create("InlineGroup")
    statusGroup:SetTitle("Character Status")
    statusGroup:SetFullWidth(true)
    statusGroup:SetLayout("Flow")
    container:AddChild(statusGroup)

    -- 2. Character Details
    local myCurrentVer = (C.DB.bindpad.chars and C.DB.bindpad.chars[C.mynameRealm]) or 0
    local targetVer  = (C.DB.bindpad.mainVersions and C.DB.bindpad.mainVersions[C.myclass]) or 1

    local isMain = (C.mynameRealm == config.main)
    local statusText = isMain and "|cff00ff00Main|r" or "|cff00aaffAlt|r"
    local verColor = (myCurrentVer < targetVer) and "|cffff0000" or "|cff00ff00"

    local info = AceGUI:Create("Label")
    info:SetText(string.format("Role: %s  |  Main: |cff00ff00%s|r  |  Version: %sv%d / v%d|r",
        statusText, config.main, verColor, myCurrentVer, targetVer))
    info:SetFontObject(GameFontNormal)
    info:SetFullWidth(true)
    statusGroup:AddChild(info)

    -- 3. Action Row (Buttons)
    local actionRow = AceGUI:Create("SimpleGroup")
    actionRow:SetLayout("Flow")
    actionRow:SetFullWidth(true)
    statusGroup:AddChild(actionRow)

    -- Button: Force Sync (Only for Alts)
    if not isMain then
        local btn = AceGUI:Create("Button")
        btn:SetText("Force Bind Sync")
        btn:SetWidth(140)
        btn:SetCallback("OnClick", function()
            if not C.DB.bindpad.chars then C.DB.bindpad.chars = {} end
            C.DB.bindpad.chars[C.mynameRealm] = targetVer
            BP:SyncBinds()
            self:RefreshContent()
            C:Debug(self, "Manual sync triggered for " .. C.mynameRealm)
        end)
        actionRow:AddChild(btn)
    else
        local btn = AceGUI:Create("Button")
        btn:SetText("Master Version+")
        btn:SetWidth(140)
        btn:SetCallback("OnClick", function()
            targetVer = targetVer + 1
            C.DB.bindpad.mainVersions[C.myclass] = targetVer
            BP:SyncBinds()
            self:RefreshContent()
            C:Debug(self, string.format("Master version updated to (v%d -> v%d).", myCurrentVer, targetVer))
        end)
        actionRow:AddChild(btn)
    end

    -- Button: Mark as Synced (Only if mismatch)
    if myCurrentVer ~= targetVer then
        local syncVerBtn = AceGUI:Create("Button")
        syncVerBtn:SetText("Mark as Synced")
        syncVerBtn:SetWidth(140)
        syncVerBtn:SetCallback("OnClick", function()
            if not C.DB.bindpad.chars then C.DB.bindpad.chars = {} end
            C.DB.bindpad.chars[C.mynameRealm] = targetVer
            C:Print(self, string.format("Version for %s updated to v%d.", C.mynameRealm, targetVer))
            self:RefreshContent()
        end)
        actionRow:AddChild(syncVerBtn)
    end

    -- Toggle: Ignore This Character
    local ignoreChk = AceGUI:Create("CheckBox")
    ignoreChk:SetLabel("Ignore this Char")
    ignoreChk:SetWidth(160)
    -- Ensure table exists before checking value
    ignoreChk:SetValue(C.DB.bindpad.ignore and C.DB.bindpad.ignore[C.mynameRealm] or false)
    ignoreChk:SetCallback("OnValueChanged", function(_, _, value)
        if not C.DB.bindpad.ignore then C.DB.bindpad.ignore = {} end
        C.DB.bindpad.ignore[C.mynameRealm] = value
        C:Print(self, C.mynameRealm .. " is now " .. (value and "|cffff0000Ignored|r" or "|cff00ff00Tracked|r"))
        -- Optional: self:RefreshContent() if other UI elements react to this
    end)
    actionRow:AddChild(ignoreChk)

    -- --- SECTION 2: GLOBAL OPTIONS ---
    local optsHeader = AceGUI:Create("Heading")
    optsHeader:SetText("Global Options")
    optsHeader:SetFullWidth(true)
    container:AddChild(optsHeader)

    local chk = AceGUI:Create("CheckBox")
    chk:SetLabel("Enable Force Sync (Ignores version checks)")
    chk:SetFullWidth(true)
    chk:SetValue(C.DB.bindpad.forceSync)
    chk:SetCallback("OnValueChanged", function(_, _, value)
        C.DB.bindpad.forceSync = value
        C:Print(self, "Force Sync is now " .. (value and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"))
    end)
    container:AddChild(chk)

    -- --- SECTION 3: CLASS VERSIONS (SORTED VIA ARRAY) ---
    local versionGroup = AceGUI:Create("InlineGroup")
    versionGroup:SetTitle("Class Master Versions")
    versionGroup:SetFullWidth(true)
    versionGroup:SetLayout("Flow")
    container:AddChild(versionGroup)

    -- Use ipairs on the array to ensure Mage (1) to Warlock (13) order
    for _, data in ipairs(C.CLASS_MAINS) do
        local class = data.class
        local dbVersion = (C.DB.bindpad.mainVersions and C.DB.bindpad.mainVersions[class]) or 1
        local classColor = RAID_CLASS_COLORS[class] and RAID_CLASS_COLORS[class].colorStr or "ffffffff"

        local row = AceGUI:Create("SimpleGroup")
        row:SetLayout("Flow")
        row:SetFullWidth(true)

        local label = AceGUI:Create("Label")
        label:SetText(string.format("|c%s%s|r (v%d)", classColor, class, dbVersion))
        label:SetWidth(150)
        row:AddChild(label)

        local incBtn = AceGUI:Create("Button")
        incBtn:SetText("+ Increase")
        incBtn:SetWidth(120)
        incBtn:SetCallback("OnClick", function()
            if not C.DB.bindpad.mainVersions then C.DB.bindpad.mainVersions = {} end
            C.DB.bindpad.mainVersions[class] = dbVersion + 1
            C:Debug(self, "Bumped " .. class .. " to v" .. (dbVersion + 1))
            self:RefreshContent()
        end)
        row:AddChild(incBtn)

        local resetBtn = AceGUI:Create("Button")
        resetBtn:SetText("Reset")
        resetBtn:SetWidth(100)
        resetBtn:SetCallback("OnClick", function()
            if not C.DB.bindpad.mainVersions then C.DB.bindpad.mainVersions = {} end
            C.DB.bindpad.mainVersions[class] = 1
            C:Print(self, "Reset version for " .. class)
            self:RefreshContent()
        end)
        row:AddChild(resetBtn)

        versionGroup:AddChild(row)
    end
end
--#endregion

--#region MARK:  WEEKLY VAULT TAB
function Panel:UpdateVault(container)
    local charKey = C.mynameRealm
    
    -- 1. Get processed data from the Vault module
    local sortedNames, thisWeekStart = WV:GetActiveVaultAlts()

    -- 2. Master Rendering Loop
    for _, name in ipairs(sortedNames) do
        local data = C.DB.vault[name]
        if data or name == charKey then
            local isCurrent = (name == charKey)
            local isStale = data and data.lastUpdate and data.lastUpdate < thisWeekStart
            
            -- CARD: AceGUI Setup
            local card = AceGUI:Create("InlineGroup")
            local displayName = isCurrent and ("|cff00ff00" .. name .. "|r") or NORMAL_FONT_COLOR:WrapTextInColorCode(name)
            
            if data and (data.hasReward or isStale) then
                displayName = displayName .. "  |TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14:0:0|t |cff00ff00(REWARD!)|r"
            end
            
            card:SetTitle(displayName)
            card:SetFullWidth(true)
            card:SetLayout("Flow")
            container:AddChild(card)

            local cats = data and data.categories or {}
            
            for _, catName in ipairs(WV.CAT_ORDER) do
                local charCat = cats[catName] or {}
                local t = WV.THRESHOLDS[catName]
                
                local maxP = 0
                for i=1, #charCat do maxP = math.max(maxP, charCat[i].progress or 0) end

                local slotsEarned = 0
                for i=1, 3 do if maxP >= t[i] then slotsEarned = i end end

                if isCurrent or slotsEarned > 0 then
                    local row = AceGUI:Create("SimpleGroup")
                    row:SetFullWidth(true) row:SetLayout("Flow")
                    card:AddChild(row)

                    local bar = ""
                    for i=1, 3 do
                        local icon = (slotsEarned >= i) and "Ready" or "NotReady"
                        bar = bar .. "|TInterface\\RaidFrame\\ReadyCheck-" .. icon .. ":14:14:0:0|t"
                    end

                    local catLabel = AceGUI:Create("Label")
                    catLabel:SetText(bar .. " " .. NORMAL_FONT_COLOR:WrapTextInColorCode(catName))
                    catLabel:SetWidth(140)
                    row:AddChild(catLabel)

                    for i=1, 3 do
                        local slot = charCat[i]
                        local cell = AceGUI:Create("Label")
                        cell:SetWidth(90)

                        local val = "|cff808080Locked|r"
                        if isStale then
                            if maxP >= t[i] then
                                val = string.format("|cff00ff00ilvl: %s|r", slot.level or "??")
                            else
                                val = "|cff444444---|r"
                            end
                        else
                            if maxP >= t[i] then
                                val = string.format("|cff00aaffilvl: %s|r", slot.level or "??")
                            elseif maxP > (t[i-1] or 0) then
                                val = NORMAL_FONT_COLOR:WrapTextInColorCode(string.format("%d/%d", maxP, t[i]))
                            elseif isCurrent and i == 1 then
                                val = "|cff8080800/" .. t[i] .. "|r"
                            end
                        end
                        cell:SetText(val)
                        row:AddChild(cell)
                    end
                end
            end

            -- Spacer
            local p = AceGUI:Create("Label")
            p:SetText(" ") p:SetFullWidth(true)
            container:AddChild(p)
        end
    end
end

--#endregion

--- ELVUI PROFILE TAB
function Panel:UpdateElvProfile(container)
    local currentName = C.mynameRealm
    local currentStatus = EP:GetProfileStatus()

    -- Helper for a clean, visible row
    local function AddCharacterRow(parent, name, status, isCurrent)
        local row = AceGUI:Create("SimpleGroup")
        row:SetFullWidth(true)
        row:SetLayout("Flow")
        parent:AddChild(row)

        -- 1. Name (Left side)
        local nameLabel = AceGUI:Create("Label")
        nameLabel:SetText(isCurrent and "|cff00ff00" .. name .. "|r" or name)
        nameLabel:SetWidth(180) -- Fixed width is safer than Relative for small panels
        nameLabel:SetFontObject(GameFontNormal)
        row:AddChild(nameLabel)

        -- 2. Status (Right side)
        local statusText = "|cff00aaff" .. tostring(status or "Pending") .. "|r"
        if status == "midnight" then statusText = "|cff00ff00midnight|r" end

        local statusLabel = AceGUI:Create("Label")
        statusLabel:SetText(statusText)
        statusLabel:SetWidth(120)
        statusLabel:SetJustifyH("RIGHT")
        statusLabel:SetFontObject(GameFontNormal)
        row:AddChild(statusLabel)
    end

    -- --- SECTION 1: LOCAL CHARACTER ---
    local localGroup = AceGUI:Create("InlineGroup")
    localGroup:SetTitle("Local Status")
    localGroup:SetFullWidth(true)
    localGroup:SetLayout("Flow")
    container:AddChild(localGroup)

    AddCharacterRow(localGroup, currentName, currentStatus, true)

    -- --- SECTION 2: PROFILE DATABASE ---
    local dbGroup = AceGUI:Create("InlineGroup")
    dbGroup:SetTitle("Profile Database")
    dbGroup:SetFullWidth(true)
    dbGroup:SetLayout("Flow")
    container:AddChild(dbGroup)

    if C.DB.elvui then
        -- Correctly gathering keys from the ELVUI table, not the vault
        local names = {}
        for name in pairs(C.DB.elvui) do
            if name ~= currentName then
                table.insert(names, name)
            end
        end
        table.sort(names)

        if #names > 0 then
            for _, name in ipairs(names) do
                AddCharacterRow(dbGroup, name, C.DB.elvui[name], false)
            end
        else
            local empty = AceGUI:Create("Label")
            empty:SetText("\n|cff808080No other profiles found.|r")
            empty:SetFullWidth(true)
            dbGroup:AddChild(empty)
        end
    else
        C:Debug(self, "C.DB.elvui is nil")
    end
end

--- DEV PROFILE TAB
function Panel:UpdateDev(container)
    local dev = C.DB.dev
    if not dev then return end
    dev.moduleFilter = dev.moduleFilter or {}

    -- --- SECTION 1: GLOBAL DEBUG SETTINGS ---
    local globalGroup = AceGUI:Create("InlineGroup")
    globalGroup:SetTitle("Global Debug Mode")
    globalGroup:SetFullWidth(true)
    globalGroup:SetLayout("Flow")
    container:AddChild(globalGroup)

    local debugToggle = AceGUI:Create("CheckBox")
    debugToggle:SetLabel("Enable Master Debug Mode")
    debugToggle:SetValue(dev.debugMode or false)
    debugToggle:SetRelativeWidth(0.5)
    debugToggle:SetCallback("OnValueChanged", function(_, _, value) dev.debugMode = value end)
    globalGroup:AddChild(debugToggle)

    local statusToggle = AceGUI:Create("CheckBox")
    statusToggle:SetLabel("Show Module Load Status")
    statusToggle:SetValue(dev.showModuleStatus or false)
    statusToggle:SetRelativeWidth(0.5)
    statusToggle:SetCallback("OnValueChanged", function(_, _, value) dev.showModuleStatus = value end)
    globalGroup:AddChild(statusToggle)

    -- --- SECTION 2: MODULE DEBUG FILTERS ---
    local filterGroup = AceGUI:Create("InlineGroup")
    filterGroup:SetTitle("Active Module Filters")
    filterGroup:SetFullWidth(true)
    filterGroup:SetLayout("Flow")
    container:AddChild(filterGroup)

    -- Quick Toggle Row
    local filterActions = AceGUI:Create("SimpleGroup")
    filterActions:SetLayout("Flow")
    filterActions:SetFullWidth(true)
    filterGroup:AddChild(filterActions)

    local function SetAllFilters(state)
        for name, _ in C:IterateModules() do dev.moduleFilter[name] = state end
        self:RefreshContent()
    end

    local btnAll = AceGUI:Create("Button")
    btnAll:SetText("Enable All")
    btnAll:SetRelativeWidth(0.5)
    btnAll:SetCallback("OnClick", function() SetAllFilters(true) end)
    filterActions:AddChild(btnAll)

    local btnNone = AceGUI:Create("Button")
    btnNone:SetText("Disable All")
    btnNone:SetRelativeWidth(0.5)
    btnNone:SetCallback("OnClick", function() SetAllFilters(false) end)
    filterActions:AddChild(btnNone)

    -- The Module List
    for name, _ in C:IterateModules() do
        local cb = AceGUI:Create("CheckBox")
        cb:SetLabel(name)
        cb:SetRelativeWidth(0.5) -- Two columns
        cb:SetValue(dev.moduleFilter[name] == true)
        cb:SetCallback("OnValueChanged", function(_, _, value)
            dev.moduleFilter[name] = value
            C:Debug(self, "Filter for " .. name .. " set to " .. tostring(value))
        end)
        filterGroup:AddChild(cb)
    end

    -- --- SECTION 3: MODULE COMMANDS ---
    local cmdGroup = AceGUI:Create("InlineGroup")
    cmdGroup:SetTitle("Quick Commands")
    cmdGroup:SetFullWidth(true)
    cmdGroup:SetLayout("Flow")
    container:AddChild(cmdGroup)

    for _, cmd in ipairs(Dev.COMMAND_MANIFEST) do
        local btn = AceGUI:Create("Button")
        btn:SetText(cmd.name)
        btn:SetRelativeWidth(0.33)
        btn:SetCallback("OnClick", function()
            local action = Dev[cmd.func]
            if type(action) == "function" then
                action(Dev)
                C:Debug(Dev, "Executed Command:", cmd.name)
            else
                C:Print(self, "|cffff0000Error:|r Function " .. tostring(cmd.func) .. " missing.")
            end
        end)
        cmdGroup:AddChild(btn)
    end

    -- --- SECTION 4: APPLY & RELOAD ---
    local reloadBtn = AceGUI:Create("Button")
    reloadBtn:SetText("Apply Changes & Reload UI")
    reloadBtn:SetFullWidth(true)
    reloadBtn:SetCallback("OnClick", function() ReloadUI() end)
    container:AddChild(reloadBtn)
end

--- QUEST TRACKER TAB
function Panel:UpdateQuests(container)
    local allQuestData = C.DB.quests or {}
    local currentCharacter = C.mynameRealm

    -- Helper to create a two-column row matching the ElvUI style
    local function AddQuestRow(parent, name, isDone, isHoliday)
        -- Skip holiday quests that are not activce
        if isHoliday and not C:IsHolidayActive(name) then return end
        local row = AceGUI:Create("SimpleGroup")
        row:SetFullWidth(true)
        row:SetLayout("Flow")
        parent:AddChild(row)

        -- Quest Name Label (Left)
        local nameLabel = AceGUI:Create("Label")
        nameLabel:SetText(name) -- No color formatting
        nameLabel:SetRelativeWidth(0.6)
        row:AddChild(nameLabel)

        -- Status Label (Right-Aligned)
        local statusLabel = AceGUI:Create("Label")
        -- Status colors are kept (Green/Red) for functional readability
        statusLabel:SetText(isDone and "|cff00ff00Done|r" or "|cffff0000Pending|r")
        statusLabel:SetRelativeWidth(0.4)
        statusLabel:SetJustifyH("RIGHT")
        row:AddChild(statusLabel)
    end

    -- 1. Current Character Section
    local topHeader = AceGUI:Create("Heading")
    topHeader:SetText(currentCharacter)
    topHeader:SetFullWidth(true)
    container:AddChild(topHeader)

    local currentData = allQuestData[currentCharacter] or {}
    for _, q in ipairs(C.TRACKED_QUESTS) do
        AddQuestRow(container, q.name, currentData[q.name], q.isHoliday)
    end
    if not next(currentData) then
        local emptyLabel = AceGUI:Create("Label")
        emptyLabel:SetText("  No quest data.")
        emptyLabel:SetFullWidth(true)
        emptyLabel:SetFontObject(GameFontNormal)
        container:AddChild(emptyLabel)
    end

    -- Sort other characters alphabetically
    local otherChars = {}
    for name, quests in pairs(allQuestData) do
        if name ~= currentCharacter and next(quests) then table.insert(otherChars, name) end
    end
    table.sort(otherChars)

    if otherChars and next(otherChars) then
        -- 2. Other Characters Section
        local otherHeader = AceGUI:Create("Heading")
        otherHeader:SetText("Other Characters")
        otherHeader:SetFullWidth(true)
        container:AddChild(otherHeader)



        for _, name in ipairs(otherChars) do
            local shortName = name:match("^([^-]+)") or name

            local charData = allQuestData[name] or {}
            if charData and next(charData) then
                -- Character Identifier Label (No formatting)
                local charLabel = AceGUI:Create("Label")
                -- charLabel:SetText("|cff00AAFF" .. shortName .. "|r")
                charLabel:SetText(NORMAL_FONT_COLOR:WrapTextInColorCode(shortName))
                charLabel:SetFullWidth(true)
                container:AddChild(charLabel)

                for _, q in ipairs(C.TRACKED_QUESTS) do
                    AddQuestRow(container, "  " .. q.name, charData[q.name], q.isHoliday)
                end
            end
        end
    end
end

--- GENERAL TAB
function Panel:UpdateGeneral(container)
    local header = AceGUI:Create("Heading")
    header:SetText("Cobalt Dashboard")
    header:SetFullWidth(true)
    container:AddChild(header)

    -- Custom function to dump table contents safely
    local function DumpTable(t, indent)
        indent = indent or 0
        local spacing = string.rep("  ", indent)

        for k, v in pairs(t) do
            if type(v) == "table" then
                print(spacing .. "|cff00ff00[" .. tostring(k) .. "]|r = {")
                DumpTable(v, indent + 1)
                print(spacing .. "}")
            else
                print(spacing .. "|cff00ff00[" .. tostring(k) .. "]|r = " .. tostring(v))
            end
        end
    end

    local debugButton = AceGUI:Create("Button")
    debugButton:SetText("Print Global Database")
    debugButton:SetFullWidth(true)
    debugButton:SetCallback("OnClick", function()
        if CobaltDB and CobaltDB.global then
            print("|cff00aaff--- CobaltDB.global Dump ---|r")
            DumpTable(CobaltDB.global)
            print("|cff00aaff--- End of Dump ---|r")
        else
            print("|cffff0000Cobalt Error:|r CobaltDB.global is nil!")
        end
    end)
    container:AddChild(debugButton)
end

-- Main Frame Construction
function Panel:Create()
    if self.Frame then return end

    local frame = AceGUI:Create("Window")
    self.Frame = frame
    frame:SetTitle("Cobalt Panel")
    frame:SetLayout("Flow")
    frame:SetWidth(UI_CONFIG.WIDTH)
    frame:SetHeight(UI_CONFIG.HEIGHT)

    -- 1. Enable closing with the ESC key
    -- local frameName = "CobaltMainFrame"
    -- _G[frameName] = frame.frame
    -- tinsert(UISpecialFrames, frameName)

    local f = frame.frame
    if f.SetResizeBounds then
        f:SetResizeBounds(UI_CONFIG.MIN_WIDTH, UI_CONFIG.MIN_HEIGHT, 0, 0)
    elseif f.SetMinResize then
        f:SetMinResize(UI_CONFIG.MIN_WIDTH, UI_CONFIG.MIN_HEIGHT)
    end

    frame:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
        self.Frame = nil -- IMPORTANT: Allows Create() to run again next time
        self.contentFrame = nil
        self.selectedTab = nil
        self.sidebar = nil
    end)

    -- Sidebar
    local sidebar = AceGUI:Create("SimpleGroup")
    sidebar:SetWidth(UI_CONFIG.SIDEBAR_WIDTH)
    sidebar:SetLayout("List")
    frame:AddChild(sidebar)
    self.sidebar = sidebar

    -- Content Area
    local content = AceGUI:Create("InlineGroup")
    content:SetLayout("Fill")
    frame:AddChild(content)
    self.contentFrame = content

    local function UpdateLayout(width, height)
        local usableHeight = height - 70
        local usableWidth = width - UI_CONFIG.SIDEBAR_WIDTH - UI_CONFIG.RIGHT_PADDING
        sidebar:SetHeight(usableHeight)
        content:SetHeight(usableHeight)
        content:SetWidth(usableWidth)
        frame:DoLayout()
    end

    f:SetScript("OnSizeChanged", function(_, w, h) UpdateLayout(w, h) end)

    UpdateLayout(UI_CONFIG.WIDTH, UI_CONFIG.HEIGHT)
    self.selectedTab = "Vault"
    self:RefreshContent()
end

-- Module Visibility
function Panel:Toggle()
    -- If the frame was released (closed via X), recreate it
    if not self.Frame then
        self:Create()
        self.Frame:Show()
        return
    end

    -- Otherwise, just flip visibility
    if self.Frame:IsShown() then
        self.Frame:Hide()
    else
        self.Frame:Show()
    end
end

function Panel:OnInitialize()
    C:Debug(self, C.MODULE_ENABLED)
    self:Create()

    -- Ensure it's hidden on login
    if self.Frame then
        self.Frame:Hide()
    end
end