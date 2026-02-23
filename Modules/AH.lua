local C, D = unpack(Cobalt)
local M = C:GetModule("AH")

function M:IsCleared()
    return D.AH and D.AH[C.mynameRealm] == true
end

function M:MarkAsDone(reason)
    D.AH = D.AH or {}
    D.AH[C.mynameRealm] = true
    
    self:UnregisterAllEvents()

    if reason == "WIPED" then
        C:Print(self, "|cff00FFC0Success:|r AH favorites have been cleared.")
    else
        C:Debug(self, "No favorites found. Module detached.")
    end
    self:Disable() 
end

function M:OnAHOpen()
    C:Print(self, "Scanning for AH favorites...")
    C_AuctionHouse.SearchForFavorites({})
end

function M:OnResultsUpdated()
    local results = C_AuctionHouse.GetBrowseResults()
    if results and #results > 0 then
        for _, item in ipairs(results) do
            if item.itemKey then C_AuctionHouse.SetFavoriteItem(item.itemKey, false) end
        end
        self:MarkAsDone("WIPED")
    else
        self:MarkAsDone("EMPTY")
    end
end

function M:OnSearchFailed()
    C:Print(self, "|cffff0000Warning:|r Search failed. Marking as cleared to prevent loops.")
    self:MarkAsDone("FAILED")
end

function M:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)  

    if self:IsCleared() then
        C:Debug(self, "AH status: |cff00ff00Cleared|r")
        C:Debug(self, C.MODULE_DISABLED)
        self:Disable() 
        return 
    end

    C:Print(self, "Please |cff00ff00Open the Auction House|r to auto-wipe favorites.")

    self:RegisterEvent("AUCTION_HOUSE_SHOW", "OnAHOpen")
    self:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED", "OnResultsUpdated")
    self:RegisterEvent("AUCTION_HOUSE_BROWSE_FAILURE", "OnSearchFailed")
end
