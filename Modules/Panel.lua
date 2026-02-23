local C, D = unpack(Cobalt)
local Panel = C:GetModule("Panel")
local BP = C:GetModule("BindPad")
local DC = C:GetModule("Decor")
local EP = C:GetModule("ElvProfile")
local L = C:GetModule("Lumber")
local QT = C:GetModule("Quests")
local WV = C:GetModule("Vault")
local Dev = C:GetModule("Dev")
local AceGUI = C.Libs.AceGUI

local _G = _G

local string_format = _G.string.format
local GetItemInfo = _G.C_Item.GetItemInfo
local GetCoinTextureString = _G.C_CurrencyInfo.GetCoinTextureString
local GameTooltip = _G.GameTooltip

-- Reference your updated constants (Panel UpdateDecor)
local DECOR_MAP = C.DECOR_LUMBER_MAP
local DEFAULT_COLOR = "|cffffffff"
local STOCK_COLOR = "|cff00ff00"

----------------------------------------------------
-- Configuration & Constants
----------------------------------------------------
local UI_CONFIG = {
    WIDTH = 650,
    HEIGHT = 550,
    MIN_WIDTH = 600,
    MIN_HEIGHT = 350,
    SIDEBAR_WIDTH = 196, -- Increased for wider buttons
    BUTTON_WIDTH = 176,  -- Wider buttons
    RIGHT_PADDING = 40,  -- Reduced padding to close the gap
}

local NAV_MENU = {
    { name = "General",    method = "UpdateGeneral" },
    { name = "Vault",      method = "UpdateVault" },
    { name = "Quests",     method = "UpdateQuests" },
    { name = "Decor",      method = "UpdateDecor" },
    { name = "Binds",      method = "UpdateBindPad" },
    { name = "ElvUI",      method = "UpdateElvProfile" },
    { name = "Dev",        method = "UpdateDev" }
}

----------------------------------------------------
-- Content Management (The Dispatcher)
----------------------------------------------------
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

----------------------------------------------------
--- DECOR TAB ---
----------------------------------------------------
function Panel:UpdateDecor(container)
    local header = AceGUI:Create("Heading")
    header:SetText("Decor & Price Tracker")
    header:SetFullWidth(true)
    container:AddChild(header)

    local editbox = AceGUI:Create("MultiLineEditBox")
    editbox:SetLabel("Paste Item IDs (comma separated):")
    editbox:SetFullWidth(true)
    editbox:SetNumLines(3)

    -- Safety check for activeIDs
    if DC.activeIDs and #DC.activeIDs > 0 then
        editbox:SetText(table.concat(DC.activeIDs, ", "))
    end

    editbox:SetCallback("OnEnterPressed", function(_, _, value)
        DC:UpdateIDList(value)
        self:RefreshContent() -- Refresh UI after updating IDs
    end)
    container:AddChild(editbox)

    -- INVENTORY CHECK
    if not DC.inventory or next(DC.inventory) == nil then
        local empty = AceGUI:Create("Label")
        empty:SetText("\nNo active IDs tracked or Item IDs not found in Database.")
        empty:SetFullWidth(true)
        container:AddChild(empty)
        return
    end

    -- Main Loop
    for categoryName, items in pairs(DC.inventory) do
        -- Category Heading
        local catHeader = AceGUI:Create("Heading")
        catHeader:SetText(categoryName)
        catHeader:SetFullWidth(true)
        container:AddChild(catHeader)

        for _, item in ipairs(items) do
            -- Use a SimpleGroup to wrap each row
            local row = AceGUI:Create("SimpleGroup")
            row:SetLayout("Flow")
            row:SetFullWidth(true)
            container:AddChild(row)

            -- 1. DATA LOOKUP (Optimized for the new Mapping)
            local itemData = DECOR_MAP[item.id]
            local expColor = DEFAULT_COLOR
            
            if itemData and itemData.type and itemData.type.exp then
                expColor = itemData.type.exp.color or DEFAULT_COLOR
            end

            -- 2. ITEM NAME & TOOLTIP
            local nameLabel = AceGUI:Create("InteractiveLabel")
            local itemName = GetItemInfo(item.id) or item.name or "Unknown Item"

            nameLabel:SetText(expColor .. itemName .. FONT_COLOR_CODE_CLOSE)
            nameLabel:SetRelativeWidth(0.50)

            nameLabel:SetCallback("OnEnter", function(widget)
                GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
                GameTooltip:SetHyperlink("item:" .. item.id)
                GameTooltip:Show()
            end)
            nameLabel:SetCallback("OnLeave", function() GameTooltip:Hide() end)
            row:AddChild(nameLabel)

            -- 3. STOCK COUNT
            local stockLabel = AceGUI:Create("Label")
            local countColor = (item.total >= 1) and STOCK_COLOR or DEFAULT_COLOR
            stockLabel:SetText(string_format("%s%d units" .. FONT_COLOR_CODE_CLOSE, countColor, item.total))
            stockLabel:SetRelativeWidth(0.20)
            row:AddChild(stockLabel)

            -- 4. PRICE CALCULATION (Cleaned up logic)
            local priceLabel = AceGUI:Create("Label")
            -- target * 500 Gold (Converted to Copper: 1g = 10000c)
            local itemCostInCopper = (item.target or 0) * 500 * 10000

            priceLabel:SetText(GetCoinTextureString(itemCostInCopper))
            priceLabel:SetRelativeWidth(0.25)

            -- Safe alignment check
            if priceLabel.label then 
                priceLabel.label:SetJustifyH("RIGHT") 
            end
            row:AddChild(priceLabel)
        end
    end
end

----------------------------------------------------
--- BINDPAD SYNC TAB ---
----------------------------------------------------
function Panel:UpdateBindPad(container)
    local config = C.CLASS_MAINS[C.myclass]
    local header = AceGUI:Create("Heading")
    header:SetText("BindPad Synchronization")
    header:SetFullWidth(true)
    container:AddChild(header)

    if not config then
        container:AddChild(AceGUI:Create("Label")):SetText("\nNo config for " .. C.myclass)
        return
    end

    local currentVer = D.bindPadVersions and D.bindPadVersions[C.mynameRealm] or 0
    local isMain = (C.mynameRealm == config.main)
    local statusText = isMain and "|cff00ff00Main Character|r" or "|cff00aaffAlt Character|r"

    local info = AceGUI:Create("Label")
    info:SetText(string.format("\nRole: %s\nMain: |cff00ff00%s|r\nVersion: |cff00ff00v%d / v%d|r\n\n", 
        statusText, config.main, currentVer, config.version))
    info:SetFontObject(GameFontNormal) 
    info:SetFullWidth(true)
    container:AddChild(info)

    if not isMain then
        local btn = AceGUI:Create("Button")
        btn:SetText("Force Bind Sync")
        btn:SetWidth(180)
        btn:SetCallback("OnClick", function()
            if D.bindPadVersions then D.bindPadVersions[C.mynameRealm] = 0 end
            BP:SyncBinds()
            self:RefreshContent()
        end)
        container:AddChild(btn)
    end
end

----------------------------------------------------
--- WEEKLY VAULT TAB ---
----------------------------------------------------
function Panel:UpdateVault(container)
    local catOrder = {"Raid", "Dungeon", "World"}
    local thresholds = {
        ["Raid"] = {2, 4, 6},
        ["Dungeon"] = {1, 4, 8},
        ["World"] = {2, 4, 8}
    }
    local charKey = C.mynameRealm

    if not D.vault then return end

    -- 1. Gather Alts
    local others = {}
    for name in pairs(D.vault) do
        if name ~= charKey then table.insert(others, name) end
    end

    -- 2. Sort Alts by total aggregate progress
    table.sort(others, function(a, b)
        local function GetTotalProg(name)
            local data = D.vault[name]
            local total = 0
            if type(data) == "table" then
                for _, cat in ipairs(catOrder) do
                    if data[cat] then
                        for i=1, 3 do
                            if data[cat][i] and data[cat][i].progress then
                                total = total + data[cat][i].progress
                            end
                        end
                    end
                end
            end
            return total
        end
        local progA, progB = GetTotalProg(a), GetTotalProg(b)
        if progA == progB then return a < b end
        return progA > progB
    end)

    -- 3. Final List: Current Char -> Sorted Alts
    local sortedNames = { charKey }
    for _, name in ipairs(others) do table.insert(sortedNames, name) end

    -- 4. Display
    for i, name in ipairs(sortedNames) do
        local isCurrent = (name == charKey)
        local charData = D.vault[name]
        local isDummy = (isCurrent and (not charData or charData == "dummy"))

        -- Header: Green for current, default for others
        local charHeader = AceGUI:Create("Heading")
        -- local headerText = isCurrent and ("|cff00ff00" .. name .. "|r") or name
        local headerText = name
        charHeader:SetText(headerText)
        charHeader:SetFullWidth(true)
        container:AddChild(charHeader)

        local visibleCats = {}
        for _, catName in ipairs(catOrder) do
            local charCatData = (not isDummy and charData) and charData[catName] or {}
            local maxProg = 0
            for _, d in ipairs(charCatData) do 
                if type(d) == "table" then maxProg = math.max(maxProg, d.progress or 0) end
            end
            if isCurrent or maxProg > 0 then table.insert(visibleCats, catName) end
        end

        for idx, catName in ipairs(visibleCats) do
            local catThresholds = thresholds[catName]
            local charCatData = (not isDummy and charData) and charData[catName] or {}

            local currentProg = 0
            for _, d in ipairs(charCatData) do
                if type(d) == "table" and d.progress and d.progress > currentProg then 
                    currentProg = d.progress 
                end
            end

            local catLabel = AceGUI:Create("Label")
            catLabel:SetText(_G.NORMAL_FONT_COLOR:WrapTextInColorCode(catName))
            catLabel:SetFontObject(GameFontNormal)
            catLabel:SetFullWidth(true)
            container:AddChild(catLabel)

            local rowGroup = AceGUI:Create("SimpleGroup")
            rowGroup:SetLayout("Flow")
            rowGroup:SetFullWidth(true)
            container:AddChild(rowGroup)

            for slotIdx, threshold in ipairs(catThresholds) do
                local slotData = charCatData[slotIdx]
                local prevThreshold = catThresholds[slotIdx-1] or 0
                local slotLabel = AceGUI:Create("Label")
                slotLabel:SetRelativeWidth(0.33)

                local displayText = ""
                if slotData and slotData.progress and slotData.progress >= threshold then
                    displayText = string.format("|cff00aaffilvl: %s|r", slotData.level or "??")
                elseif currentProg > prevThreshold and currentProg < threshold and currentProg > 0 then
                    displayText = string.format("|cff00ff00%d/%d|r", currentProg, threshold)
                elseif slotIdx == 1 and currentProg == 0 and isCurrent then
                    displayText = string.format("|cff808080%d/%d|r", currentProg, threshold)
                else
                    displayText = "|cff808080Locked|r"
                end

                slotLabel:SetText("  " .. displayText)
                rowGroup:AddChild(slotLabel)
            end

            if idx < #visibleCats then
                local s = AceGUI:Create("Label")
                s:SetText(" ")
                s:SetFullWidth(true)
                container:AddChild(s)
            end
        end
    end
end

----------------------------------------------------
--- ELVUI PROFILE TAB ---
----------------------------------------------------
function Panel:UpdateElvProfile(container)
    local currentName = C.mynameRealm

    -- Helper to create a two-column row with right-aligned status
    local function AddCharacterRow(parent, name, status, isCurrent)
        local row = AceGUI:Create("SimpleGroup")
        row:SetFullWidth(true)
        row:SetLayout("Flow")
        parent:AddChild(row)

        -- Character Name Label (Left)
        local nameLabel = AceGUI:Create("Label")
        nameLabel:SetText(isCurrent and _G.NORMAL_FONT_COLOR:WrapTextInColorCode(name) or name)
        nameLabel:SetRelativeWidth(0.6) -- Takes 60% of the width
        nameLabel:SetFontObject(GameFontNormal)
        row:AddChild(nameLabel)

        -- Status Label (Right)
        local statusText = (status == "midnight") and "|cff00ff00" .. tostring(status) .. "|r" or "|cff00aaff" .. tostring(status) .. "|r"
        if not status then statusText = "|cffff0000Pending|r" end

        local statusLabel = AceGUI:Create("Label")
        statusLabel:SetText(statusText)
        statusLabel:SetRelativeWidth(0.4) -- Takes 40% of the width
        statusLabel:SetJustifyH("RIGHT")  -- Anchors text to the right
        statusLabel:SetFontObject(GameFontNormal)
        row:AddChild(statusLabel)
    end

    -- 1. Current Character Section
    local topHeader = AceGUI:Create("Heading")
    topHeader:SetText("Current Character")
    topHeader:SetFullWidth(true)
    container:AddChild(topHeader)

    local currentStatus = EP:GetProfileStatus()
    AddCharacterRow(container, currentName, currentStatus, true)

    -- 2. Other Characters Section
    local otherHeader = AceGUI:Create("Heading")
    otherHeader:SetText("Other Characters")
    otherHeader:SetFullWidth(true)
    container:AddChild(otherHeader)

    if D.elvui then
        for name, profile in pairs(D.elvui) do
            if name ~= currentName then
                AddCharacterRow(container, name, profile, false)
            end
        end
    end
end

----------------------------------------------------
--- DEV PROFILE TAB ---
----------------------------------------------------
function Panel:UpdateDev(container)
    local dev = D.dev
    if not dev then return end

    -- Ensure the filter table exists in your SavedVariables
    dev.moduleFilter = dev.moduleFilter or {}

    -- 1. Main Header
    local header = AceGUI:Create("Heading")
    header:SetText("Developer Mode Settings")
    header:SetFullWidth(true)
    container:AddChild(header)

    -- 2. Debug Mode Toggle
    local debugToggle = AceGUI:Create("CheckBox")
    debugToggle:SetLabel("Enable Master Debug Mode")
    debugToggle:SetValue(dev.debugMode or false)
    debugToggle:SetCallback("OnValueChanged", function(_, _, value)
        dev.debugMode = value
    end)
    debugToggle:SetFullWidth(true)
    container:AddChild(debugToggle)

    -- 3. Module Status Toggle
    local statusToggle = AceGUI:Create("CheckBox")
    statusToggle:SetLabel("Show Module Load Status")
    statusToggle:SetValue(dev.showModuleStatus or false)
    statusToggle:SetCallback("OnValueChanged", function(_, _, value)
        dev.showModuleStatus = value
    end)
    statusToggle:SetFullWidth(true)
    container:AddChild(statusToggle)

    -- 4. Module Filter Section
    local modHeader = AceGUI:Create("Heading")
    modHeader:SetText("Active Module Debug Filters")
    modHeader:SetFullWidth(true)
    container:AddChild(modHeader)

    local moduleGroup = AceGUI:Create("SimpleGroup")
    moduleGroup:SetFullWidth(true)
    moduleGroup:SetLayout("Flow")
    container:AddChild(moduleGroup)

    -- Dynamically iterate through all registered AceModules
    for name, _ in C:IterateModules() do
        local cb = AceGUI:Create("CheckBox")
        cb:SetLabel(name)
        cb:SetRelativeWidth(0.5) -- Two columns

        -- Set current saved state (default to false if never set)
        cb:SetValue(dev.moduleFilter[name] == true)

        cb:SetCallback("OnValueChanged", function(_, _, value)
            dev.moduleFilter[name] = value
            C:Print(self, "Debug for |cff00aaff" .. name .. "|r set to: " .. (value and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
        end)
        moduleGroup:AddChild(cb)
    end

    -- 5. Spacer & Reload
    local spacer = AceGUI:Create("Label")
    spacer:SetText(" ")
    spacer:SetFullWidth(true)
    container:AddChild(spacer)

    -- Header & Group (Same as before)
    local modHeader = AceGUI:Create("Heading")
    modHeader:SetText("Module Commands")
    modHeader:SetFullWidth(true)
    container:AddChild(modHeader)

    local btnGroup = AceGUI:Create("SimpleGroup")
    btnGroup:SetLayout("Flow")
    btnGroup:SetFullWidth(true)
    container:AddChild(btnGroup)

    -- 1. Point the loop directly to your new manifest
    for _, cmd in ipairs(Dev.COMMAND_MANIFEST) do
        local btn = AceGUI:Create("Button")
        btn:SetText(cmd.name)
        btn:SetRelativeWidth(0.33) -- Three buttons per row

        -- 2. Refactored Callback
        btn:SetCallback("OnClick", function()
            -- Explicitly look for the function name in the Dev module
            local action = Dev[cmd.func]

            if type(action) == "function" then
                -- Execute as Dev:FunctionName(Dev)
                action(Dev) 

                -- Use your framework's Debug (C) to confirm
                C:Debug(Dev, "Executed:", cmd.name)
            else
                print("|cffff0000Error:|r Dev:" .. tostring(cmd.func) .. "() not found!")
            end
        end)
        btnGroup:AddChild(btn)
    end

    local reloadBtn = AceGUI:Create("Button")
    reloadBtn:SetText("Apply Changes & Reload")
    reloadBtn:SetFullWidth(true)
    reloadBtn:SetCallback("OnClick", function() ReloadUI() end)
    container:AddChild(reloadBtn)
end

----------------------------------------------------
--- QUEST TRACKER TAB ---
----------------------------------------------------
function Panel:UpdateQuests(container)
    local allQuestData = D.quests or {}
    local currentCharacter = C.mynameRealm

    -- Helper to create a two-column row matching the ElvUI style
    local function AddQuestRow(parent, name, isDone)
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
    for _, q in ipairs(QT.TRACKED_QUESTS) do
        AddQuestRow(container, q.name, currentData[q.name])
    end

    -- 2. Other Characters Section
    local otherHeader = AceGUI:Create("Heading")
    otherHeader:SetText("Other Characters")
    otherHeader:SetFullWidth(true)
    container:AddChild(otherHeader)

    -- Sort other characters alphabetically
    local otherChars = {}
    for name in pairs(allQuestData) do
        if name ~= currentCharacter then table.insert(otherChars, name) end
    end
    table.sort(otherChars)

    for _, name in ipairs(otherChars) do
        local shortName = name:match("^([^-]+)") or name
        local charData = allQuestData[name] or {}

        -- Character Identifier Label (No formatting)
        local charLabel = AceGUI:Create("Label")
        -- charLabel:SetText("|cff00AAFF" .. shortName .. "|r")
        charLabel:SetText(_G.NORMAL_FONT_COLOR:WrapTextInColorCode(shortName))
        charLabel:SetFullWidth(true)
        container:AddChild(charLabel)

        for _, q in ipairs(QT.TRACKED_QUESTS) do
            AddQuestRow(container, "  " .. q.name, charData[q.name])
        end
    end
end

----------------------------------------------------
--- GENERAL TAB ---
----------------------------------------------------
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

----------------------------------------------------
-- Main Frame Construction
----------------------------------------------------
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
    self.selectedTab = "General"
    self:RefreshContent()
end

----------------------------------------------------
-- Module Visibility
----------------------------------------------------
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

