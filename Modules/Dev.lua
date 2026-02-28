local C = select(2, ...)
local Dev = C:GetModule("Dev")
local WM = C:GetModule("Warmode")

----------------------------------------------------
--- DEV FUNCTIONS
----------------------------------------------------
function Dev:CleanupInactiveHolidays()
    if not C.DB.quests then return end

    -- 1. Create a quick lookup for active holidays to avoid redundant API calls
    local activeHolidays = {}
    for _, q in ipairs(C.TRACKED_QUESTS) do
        if q.isHoliday then
            activeHolidays[q.name] = C:IsHolidayActive(q.name)
        end
    end

    -- 2. Iterate through every character in your SavedVariables
    for charKey, questList in pairs(C.DB.quests) do
        -- 3. Check every quest stored for that character
        for questName, _ in pairs(questList) do

            -- Find the quest definition in your master table
            for _, qDef in ipairs(C.TRACKED_QUESTS) do
                if qDef.name == questName and qDef.isHoliday then
                    -- 4. If it's a holiday and NOT active, wipe it from the DB
                    if not activeHolidays[questName] then
                        C.DB.quests[charKey][questName] = nil
                        C:Debug(self, "Cleaned up", questName, "for", charKey)
                    end
                end
            end
        end
    end
    C:Debug(self, "Holiday clearing finished")
end

function Dev:AddTestData()
    C.DB.testData = C.DB.testData or {}

    local index = #C.DB.testData + 1

    C.DB.testData[index] = {
        time = time(),
        value = math.random(1, 100),
    }

    C:Print(self, "|cff00ff00Added test entry #" .. index .. "|r")
end

function Dev:WipeTestData()
    C.DB.testData = nil

    C:Print(self, "|cffff0000Test data has been completely wiped.|r")
end

function Dev:Testdb()
    C.DB = C.DB or {}
    C.DB.count = C.DB.count or 0
    C.DB.count = C.DB.count+1
    C:Print(self, "COUNTER:", C.DB.count)
end

function Dev:CheckLoveHoliday()
    local holiday = "Love is in the Air"
    local result = tostring(C:IsHolidayActive(holiday))
    C:Print(self, holiday, "is active:", result)
end

function Dev:MigrateBindPadDB()
    -- 1. Ensure the old data exists and the new table is initialized
    if C.DB.bindPadVersions and not C.DB.bindpad then
        C.DB.bindpad = { chars = {} }
    end

    -- 2. Check if migration is actually needed
    if C.DB.bindPadVersions then
        C:Print(self, "|cff00ff00AddonName:|r Migrating BindPad settings to new format...")

        -- 3. Move the data (assuming bindPadVersions was indexed by character/version)
        for key, value in pairs(C.DB.bindPadVersions) do
            C.DB.bindpad.chars[key] = value
        end

        -- 4. Cleanup old data so this doesn't run again
        C.DB.bindPadVersions = nil
        C:Print(self, "|cff00ff00AddonName:|r Migration complete.")
    else
        C:Print(self, "No C.DB.bindpadVersions")
    end
end

function Dev:SetupNewBindPadDB()
    C.DB.bindpad.mainVersions = {}
    for _, data in ipairs(C.CLASS_MAINS) do
        local class = data.class
        C.DB.bindpad.mainVersions[class] = 1
    end
    C:Print(self, "Initial BP versions DB setup done.")
end

function Dev:SetupIgnoreBindPadDB()
    C.DB.bindpad.ignore = {}
    C:Print(self, "Initial BP ignore db setup.")
end

function Dev:ResetBindPadVersion()
    local myCurrentVer = 0
    local targetVer  = (C.DB.bindpad.mainVersions and C.DB.bindpad.mainVersions[C.myclass]) or 1
    C.DB.bindpad.chars[C.mynameRealm] = myCurrentVer
    C:Print(self, string.format("Reset BindPad version to (v%d -> v%d).", myCurrentVer, targetVer))
end

function Dev:PrintVault()
    C:PrintTable(self, C.DB.vault)
end

function Dev:ForceOldVaultData()
    -- Use C.mynameRealm directly as defined in your setup
    local charKey = C.mynameRealm

    if not C.DB.vault or not C.DB.vault[charKey] then
        C:Print(self, "|cffff0000Error:|r No vault data found for |cff00ccff" .. tostring(charKey) .. "|r")
        return
    end

    -- Calculate 8 days ago in seconds
    local eightDaysAgo = time() - (8 * 24 * 60 * 60)

    -- Override the timestamp in the current character's table
    C.DB.vault[charKey].lastUpdate = eightDaysAgo

    -- Optional: Clear any existing archive to ensure a fresh test of the 'move' logic
    C.DB.vault[charKey].lastReset = nil

    C:Print(self, "Success! |cff00ccff" .. charKey .. "|r lastUpdate set to 8 days ago.")
    C:Print(self, "LastReset cleared for fresh testing.")
end

function Dev:CleanupOldData()
    -- Remove the C.DB.vault.lastReset table since its no longer used
    if C.DB and C.DB.vault and C.DB.vault.lastReset then
        C.DB.vault.lastReset = nil
        C:Print(self, "|cffff0000[Cleanup]|r Removed legacy global lastReset table.")
    else
        C:Debug(self, "No legacy lastReset table found to clean up.")
    end

    -- Remove the fake testing character
    local charKey = "Fake - Test"
    if C.DB.vault[charKey] then
        C.DB.vault[charKey] = nil
        C:Debug(self, "Removed |cffff0000" .. charKey .. "|r from database.")
    else
        C:PrinDebugt(self, "No fake character found to wipe.")
    end
end

function Dev:CreateFakeCharacter()
    local charKey = "Fake - Test"
    local eightDaysAgo = time() - (8 * 24 * 60 * 60)

    C.DB.vault[charKey] = {
        lastUpdate = eightDaysAgo,
        hasReward = false, -- Requirement: reward false for archive test
        categories = {
            ["Dungeon"] = {
                { progress = 4, level = 10, threshold = 1 }, -- Hit!
                { progress = 4, level = 10, threshold = 4 }, -- Hit!
                { progress = 4, level = 10, threshold = 8 }, -- Miss
            },
            ["World"] = {
                { progress = 5, level = 80, threshold = 2 }, -- Hit!
                { progress = 5, level = 80, threshold = 4 }, -- Hit!
                { progress = 5, level = 80, threshold = 8 }, -- Miss
            },
            ["Raid"] = {
                { progress = 0, level = 0, threshold = 2 }, -- Miss
                { progress = 0, level = 0, threshold = 4 }, -- Miss
                { progress = 0, level = 0, threshold = 6 }, -- Miss
            }
        }
    }

    C:Print(self, "Created |cff00ccff" .. charKey .. "|r with 8-day-old progress.")
end

function Dev:ToggleWarmodeModule()
    -- Flip the current state
    local newState = not WM:IsEnabled()

    -- Call the core setter
    C:SetModuleState("Warmode", newState)
end

-- =====================================================
-- Dev MANIFEST
-- =====================================================
Dev.COMMAND_MANIFEST = {
    { name = "Clear Holidays", func = "CleanupInactiveHolidays", slash = "holidays" },
    { name = "Test Data", func = "AddTestData", slash = "addtest" },
    { name = "Wipe Test Data", func = "WipeTestData", slash = "wipetest" },
    { name = "testdb", func = "Testdb", slash = "testdb" },
    { name = "lovecheck", func = "CheckLoveHoliday", slash = "love", desc = "check if Love is in the Air is active"},
    { name = "migrate bp", func = "MigrateBindPadDB", slash = "bp" },
    { name = "new bp", func = "SetupNewBindPadDB", slash = "newbp" },
    { name = "ignore bp", func = "SetupIgnoreBindPadDB", slash = "ignorebp" },
    { name = "resetbp", func = "ResetBindPadVersion", slash = "resetbp", desc = "Set BindPad version to v0"},
    { name = "vault", func = "PrintVault", slash = "vault", desc = "Print C.DB.vault table"},
    { name = "oldvault", func = "ForceOldVaultData", slash = "oldvault", desc = "DEBUG: Set current vault DB.lastUpdate to a week ago."},
    { name = "clean", func = "CleanupOldData", slash = "clean", desc = "Cleanup old database entries."},
    { name = "fake", func = "CreateFakeCharacter", slash = "fake", desc = "Create fake vault character."},
    { name = "wm", func = "ToggleWarmodeModule", slash = "wm", desc = "Toggle warmode module."},
}

function Dev:SlashHandler(input)
    -- If no input, show help
    if not input or input == "" then
        print("|cff00aaffCobalt Dev Commands:|r")
        for _, cmd in ipairs(Dev.COMMAND_MANIFEST) do
            print(string.format("  /cdev |cff00ff00%s|r - %s", cmd.slash, (cmd.desc or cmd.name)))
        end
        return
    end

    -- Split input to find the sub-command
    local command = input:lower():trim()

    for _, cmd in ipairs(Dev.COMMAND_MANIFEST) do
        if command == cmd.slash then
            -- Find the function in the Dev module
            local action = self[cmd.func]
            if type(action) == "function" then
                action(self) -- Run it!
                return
            end
        end
    end

    print("|cffff0000Error:|r Command '" .. command .. "' not found. Type /cdev for help.")
end

-- =====================================================
-- OnEnable
-- =====================================================
function Dev:OnEnable()
    C:RegisterChatCommand("cdev", function(input)
        Dev:SlashHandler(input)
    end)

    C:Debug(self, "Dev Module: /cdev registered via Manual Handler")
end

