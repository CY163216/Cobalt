local C = select(2, ...)
local M = C:GetModule("Transfer")

local COMM_PREFIX = "COBALT_NET"

function M:OnInitialize()
    C.DB.transfer = C.DB.transfer or {}
    C.DB.transfer[C.mynameRealm] = C.DB.transfer[C.mynameRealm] or {}

    -- Register for AceComm traffic
    self:RegisterComm(COMM_PREFIX, "OnCommReceived")
end

function M:OnCommReceived(prefix, text, distribution, sender)
    if prefix ~= COMM_PREFIX then return end

    -- 1. HANDSHAKE CHECK (Immediate Notification)
    if text:sub(1, 7) == "START::" then
        local label = text:sub(8)
        C:Print(self, string.format("Receiving payload: '%s' from %s...", label, sender))
        return
    end

    -- 2. DATA PROCESSING (Full Message Reassembled)
    local label, body = text:match("^(.-)\n(.*)$")
    if not label or not body then
        label = "Unnamed"
        body = text
    end

    local charKey = C.mynameRealm
    C.DB.transfer[charKey][label] = {
        text = body,
        sender = sender,
        timestamp = time()
    }

    C:Print(self, string.format("Transfer Complete: Received '%s'", label))

    -- Refresh UI if Inbox is open
    local Panel = C:GetModule("Panel", true)
    if Panel and Panel.contentFrame and Panel.selectedTab == "Inbox" then
        Panel:RefreshContent()
    end
end

function M:Send(label, message)
    if not IsInGroup() then
        C:Print(self, "Broadcast failed: You must be in a group.")
        return
    end

    local chatType = IsInRaid() and "RAID" or "PARTY"

    -- STEP 1: Send the Handshake (ALERT priority ensures it arrives first)
    self:SendCommMessage(COMM_PREFIX, "START::" .. label, chatType, nil, "ALERT")

    -- STEP 2: Send the Data
    local payload = label .. "\n" .. message
    local lastSentStep = -1 -- Start at -1 so 0% prints

    C:Print(self, string.format("Starting Broadcast: %s", label))

    self:SendCommMessage(COMM_PREFIX, payload, chatType, nil, "BULK", function(_, sent, total)
        local progress = math.floor((sent / total) * 100)

        -- Logic: Print every 20% on the SENDER side only
        local step = math.floor(progress / 20) * 20
        if step > lastSentStep and step <= 100 then
            lastSentStep = step
            C:Print(self, string.format("Sending %s: %d%%", label, step))
        end

        if sent == total then
            C:Print(self, "Broadcast Complete!")
        end
    end)
end