local _G = _G

local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
local CallbackHandler = _G.LibStub('CallbackHandler-1.0')

local AddOnName, Engine = ...

local C = AceAddon:NewAddon(Engine, AddOnName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
C.DF = {profile = { modules = { ["Warmode"] = true }}, global = {}}; C.privateVars = {profile = {}} -- Defaults

C.callbacks = C.callbacks or CallbackHandler:New(C)
C.wowpatch, C.wowbuild, C.wowdate, C.wowtoc = GetBuildInfo()
C.locale = GetLocale()

C.AH                = C:NewModule("AH", "AceEvent-3.0")
C.BindPad           = C:NewModule("BindPad")
C.Decor             = C:NewModule("Decor")
C.Dev               = C:NewModule("Dev", "AceEvent-3.0", "AceConsole-3.0")
C.ElvProfile        = C:NewModule("ElvProfile", "AceEvent-3.0")
C.Lumber            = C:NewModule("Lumber")
C.Minimap           = C:NewModule('Minimap','AceHook-3.0','AceEvent-3.0','AceTimer-3.0', "AceConsole-3.0")
C.Panel             = C:NewModule("Panel", "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0")
C.Quests            = C:NewModule("Quests", "AceEvent-3.0")
C.SharedMedia       = C:NewModule("SharedMedia")
C.Vault             = C:NewModule("Vault", "AceEvent-3.0")
C.Warmode           = C:NewModule("Warmode", "AceEvent-3.0")

C.Libs      = {}
C.LibsMinor = {}

function C:AddLib(name, major, minor)
    if not name then return end
    if type(major) == "table" and type(minor) == "number" then
        C.Libs[name], C.LibsMinor[name] = major, minor
    else
        C.Libs[name], C.LibsMinor[name] = _G.LibStub(major, minor)
    end
end

C:AddLib("AceAddon", AceAddon, AceAddonMinor)
C:AddLib("AceGUI", "AceGUI-3.0")
C:AddLib("AceDB", "AceDB-3.0")
C:AddLib("LSM", "LibSharedMedia-3.0")
C:AddLib("LDB", "LibDataBroker-1.1")
C:AddLib("LDBI", "LibDBIcon-1.0")

function C:OnInitialize()
    local AceDB = C.Libs.AceDB
    self.database = AceDB:New("CobaltDB", self.DF, true)

    -- Ensure the modules table exists to avoid nil errors later
    self.database.profile.modules = self.database.profile.modules or {}

    -- self.DB is pointing to global as per your setup
    self.DB = self.database.global

    -- Iterate and sync module states with the saved profile
    for name, module in self:IterateModules() do
        -- If the saved setting is explicitly 'false', turn the module off
        if self.database.profile.modules[name] == false then
            module:Disable()
        else
            -- Optional: If it's not in the DB, default it to true
            if self.database.profile.modules[name] == nil then
                self.database.profile.modules[name] = true
            end
        end
    end

    self:RegisterChatCommand("cobalt", "SlashHandler")
end