local C, D = unpack(Cobalt)
local M = C:GetModule("Quests")

function M:UpdateQuestStatus()
    local charKey = C.mynameRealm
    if not charKey then return end

    D.quests = D.quests or {}
    D.quests[charKey] = D.quests[charKey] or {}
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
            D.quests[charKey][q.name] = C_QuestLog.IsQuestFlaggedCompleted(questID)
        else
            -- Clean up data for inactive holidays or missing IDs
            D.quests[charKey][q.name] = nil
        end
    end

    C:Debug(self, "Quest status synced for", charKey)
end

function M:OnEnable()
    self:RegisterEvent("QUEST_TURNED_IN", "UpdateQuestStatus")

    self:UpdateQuestStatus()
    C:Debug(self, C.MODULE_ENABLED)
end