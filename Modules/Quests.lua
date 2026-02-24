local C = select(2, ...)
local M = C:GetModule("Quests")

function M:UpdateQuestStatus()
    local charKey = C.mynameRealm
    if not charKey then return end

    C.DB.quests = C.DB.quests or {}
    C.DB.quests[charKey] = C.DB.quests[charKey] or {}
    local faction = C.myfaction -- Cache "Horde" or "Alliance"

    for _, q in ipairs(C.TRACKED_QUESTS) do
        -- 1. Resolve the ID first (Universal > Faction Specific)
        local questID = q.id or (faction == "Horde" and q.horde) or (faction == "Alliance" and q.alliance)

        -- 2. Determine if we should track it (Always true unless it's an inactive holiday)
        local isAvailable = true
        if q.isHoliday then
            isAvailable = C:IsHolidayActive(q.name)
        end

        -- 3. Update status in SavedVariables (D)
        if isAvailable and questID then
            C.DB.quests[charKey][q.name] = C_QuestLog.IsQuestFlaggedCompleted(questID)
        else
            -- Clean up data for inactive holidays or missing IDs
            C.DB.quests[charKey][q.name] = nil
        end
    end


    C:Debug(self, "Quest status synced for", charKey)
end

function M:CleanupInactiveHolidays()
    local questDB = C.DB and C.DB.quests
    if not questDB then return end

    local toRemove = {}
    local hasInactive = false

    -- 1. Identify inactive holidays once
    for _, q in ipairs(C.TRACKED_QUESTS) do
        if q.isHoliday and not C:IsHolidayActive(q.name) then
            toRemove[q.id or q.name] = true
            hasInactive = true
        end
    end

    -- 2. Exit early if everything is active
    if not hasInactive then return end

    -- 3. Cleanup: Remove specific holiday keys, but leave the character tables intact
    for _, charQuests in pairs(questDB) do
        for holidayKey in pairs(toRemove) do
            charQuests[holidayKey] = nil
        end
    end
end

function M:OnInitialize()
    M:CleanupInactiveHolidays()
end

function M:OnEnable()
    self:RegisterEvent("QUEST_TURNED_IN", "UpdateQuestStatus")

    self:UpdateQuestStatus()
    C:Debug(self, C.MODULE_ENABLED)
end