local C = select(2, ...)
local Dev = C:GetModule("Dev")

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


-- =====================================================
-- Dev MANIFEST
-- =====================================================
Dev.COMMAND_MANIFEST = {
    { name = "Clear Holidays", func = "CleanupInactiveHolidays", slash = "holidays" },
    { name = "Test Data", func = "AddTestData", slash = "addtest" },
    { name = "Wipe Test Data", func = "WipeTestData", slash = "wipetest" },
    { name = "testdb", func = "Testdb", slash = "testdb" },
    { name = "lovecheck", func = "CheckLoveHoliday", slash = "love" },

}

function Dev:SlashHandler(input)
    -- If no input, show help
    if not input or input == "" then
        print("|cff00aaffCobalt Dev Commands:|r")
        for _, cmd in ipairs(Dev.COMMAND_MANIFEST) do
            print(string.format("  /cdev |cff00ff00%s|r - %s", cmd.slash, cmd.name))
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

