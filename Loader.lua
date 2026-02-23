local Cobalt = select(2, ...)
local C, D = unpack(Cobalt)

-- =====================================================
-- Constants
-- =====================================================
C.myfaction, C.myLocalizedFaction = UnitFactionGroup('player')
C.myLocalizedClass, C.myclass, C.myClassID = UnitClass('player')
C.myLocalizedRace, C.myrace, C.myRaceID = UnitRace('player')
C.mygender = UnitSex('player')
C.mylevel = UnitLevel('player')
C.myname = UnitName('player')
C.myrealm = GetRealmName()
C.mynameRealm = format('%s - %s', C.myname, C.myrealm) or "?????" -- contains spaces/dashes in realm (for profile keys)

C.MODULE_ENABLED = "|cff0047abModule enabled|r"
C.MODULE_DISABLED = "|cffff0000Module disabled|r"

C.EXPANSIONS = {
    ["CLASSIC"]      = { color = "|cffd9c7a1", label = "Classic" },
    ["OUTLAND"]      = { color = "|cffa3d9a5", label = "Outland" },
    ["NORTHREND"]    = { color = "|cffa0c4ff", label = "Northrend" },
    ["CATACLYSM"]    = { color = "|cffffb3a8", label = "Cataclysm" },
    ["PANDARIA"]     = { color = "|cffc4f4c4", label = "Pandaria" },
    ["DRAENOR"]      = { color = "|cffffd9a8", label = "Draenor" },
    ["LEGION"]       = { color = "|cffd0b3ff", label = "Legion" },
    ["KUL_TIRAN"]    = { color = "|cffb3e0ff", label = "Kul Tiran" },
    ["SHADOWLANDS"]  = { color = "|cffffc6ff", label = "Shadowlands" },
    ["DRAGON_ISLES"] = { color = "|cffffe0b3", label = "Dragon Isles" },
    ["KHAZ_ALGAR"]   = { color = "|cffc4c4c4", label = "Khaz Algar" },
}

C.LUMBER_DATA = {
    ["IRONWOOD"]   = { name = "Ironwood Lumber",    exp = C.EXPANSIONS.CLASSIC },
    ["OLEMBA"]     = { name = "Olemba Lumber",      exp = C.EXPANSIONS.OUTLAND },
    ["COLDWIND"]   = { name = "Coldwind Lumber",    exp = C.EXPANSIONS.NORTHREND },
    ["ASHWOOD"]    = { name = "Ashwood Lumber",     exp = C.EXPANSIONS.CATACLYSM },
    ["BAMBOO"]     = { name = "Bamboo Lumber",      exp = C.EXPANSIONS.PANDARIA },
    ["SHADOWMOON"] = { name = "Shadowmoon Lumber",  exp = C.EXPANSIONS.DRAENOR },
    ["FEL"]        = { name = "Fel-Touched Lumber", exp = C.EXPANSIONS.LEGION },
    ["DARKPINE"]   = { name = "Darkpine Lumber",    exp = C.EXPANSIONS.KUL_TIRAN },
    ["ARDEN"]      = { name = "Arden Lumber",       exp = C.EXPANSIONS.SHADOWLANDS },
    ["DRAGONPINE"] = { name = "Dragonpine Lumber",  exp = C.EXPANSIONS.DRAGON_ISLES },
    ["DORNIC"]     = { name = "Dornic Fir Lumber",  exp = C.EXPANSIONS.KHAZ_ALGAR },
}

C.DECOR_LUMBER_MAP = {
    [246413] = { type = C.LUMBER_DATA.IRONWOOD, count = 40 },
    [246489] = { type = C.LUMBER_DATA.IRONWOOD, count = 20 },
    [246420] = { type = C.LUMBER_DATA.IRONWOOD, count = 50 },
    [246488] = { type = C.LUMBER_DATA.IRONWOOD, count = 30 },
    [246423] = { type = C.LUMBER_DATA.IRONWOOD, count = 45 },
    [258289] = { type = C.LUMBER_DATA.IRONWOOD, count = 30 },
    [245502] = { type = C.LUMBER_DATA.IRONWOOD, count = 25 },
    [246700] = { type = C.LUMBER_DATA.IRONWOOD, count = 25 },
    [263027] = { type = C.LUMBER_DATA.IRONWOOD, count = 30 },
    [246410] = { type = C.LUMBER_DATA.IRONWOOD, count = 40 },
    [253250] = { type = C.LUMBER_DATA.IRONWOOD, count = 20 },
    [257725] = { type = C.LUMBER_DATA.IRONWOOD, count = 18 },
    [246111] = { type = C.LUMBER_DATA.IRONWOOD, count = 10 },
    [257041] = { type = C.LUMBER_DATA.IRONWOOD, count = 10 },
    [246685] = { type = C.LUMBER_DATA.IRONWOOD, count = 25 },
    [243336] = { type = C.LUMBER_DATA.IRONWOOD, count = 18 },
    [242948] = { type = C.LUMBER_DATA.IRONWOOD, count = 15 },
    [245503] = { type = C.LUMBER_DATA.IRONWOOD, count = 15 },
    [257100] = { type = C.LUMBER_DATA.IRONWOOD, count = 40 },
    [258201] = { type = C.LUMBER_DATA.OLEMBA, count = 20 },
    [258193] = { type = C.LUMBER_DATA.OLEMBA, count = 25 },
    [264706] = { type = C.LUMBER_DATA.OLEMBA, count = 16 },
    [257035] = { type = C.LUMBER_DATA.OLEMBA, count = 20 },
    [258195] = { type = C.LUMBER_DATA.OLEMBA, count = 35 },
    [257036] = { type = C.LUMBER_DATA.OLEMBA, count = 25 },
    [258198] = { type = C.LUMBER_DATA.OLEMBA, count = 20 },
    [258194] = { type = C.LUMBER_DATA.OLEMBA, count = 50 },
    [257093] = { type = C.LUMBER_DATA.OLEMBA, count = 40 },
    [258191] = { type = C.LUMBER_DATA.OLEMBA, count = 20 },
    [258215] = { type = C.LUMBER_DATA.OLEMBA, count = 20 },
    [257038] = { type = C.LUMBER_DATA.OLEMBA, count = 20 },
    [258196] = { type = C.LUMBER_DATA.OLEMBA, count = 15 },
    [258202] = { type = C.LUMBER_DATA.OLEMBA, count = 18 },
    [257037] = { type = C.LUMBER_DATA.OLEMBA, count = 20 },
    [258199] = { type = C.LUMBER_DATA.OLEMBA, count = 25 },
    [262347] = { type = C.LUMBER_DATA.OLEMBA, count = 15 },
    [258190] = { type = C.LUMBER_DATA.OLEMBA, count = 12 },
    [257039] = { type = C.LUMBER_DATA.OLEMBA, count = 50 },
    [264705] = { type = C.LUMBER_DATA.OLEMBA, count = 6 },
    [258197] = { type = C.LUMBER_DATA.OLEMBA, count = 12 },
    [258200] = { type = C.LUMBER_DATA.OLEMBA, count = 10 },
    [258192] = { type = C.LUMBER_DATA.OLEMBA, count = 10 },
    [264709] = { type = C.LUMBER_DATA.OLEMBA, count = 8 },
    [258211] = { type = C.LUMBER_DATA.COLDWIND, count = 22 },
    [257040] = { type = C.LUMBER_DATA.COLDWIND, count = 40 },
    [264676] = { type = C.LUMBER_DATA.COLDWIND, count = 30 },
    [264711] = { type = C.LUMBER_DATA.COLDWIND, count = 46 },
    [258203] = { type = C.LUMBER_DATA.COLDWIND, count = 18 },
    [258207] = { type = C.LUMBER_DATA.COLDWIND, count = 45 },
    [258213] = { type = C.LUMBER_DATA.COLDWIND, count = 40 },
    [264708] = { type = C.LUMBER_DATA.COLDWIND, count = 28 },
    [258205] = { type = C.LUMBER_DATA.COLDWIND, count = 18 },
    [258204] = { type = C.LUMBER_DATA.COLDWIND, count = 12 },
    [264707] = { type = C.LUMBER_DATA.COLDWIND, count = 20 },
    [258298] = { type = C.LUMBER_DATA.COLDWIND, count = 40 },
    [258212] = { type = C.LUMBER_DATA.COLDWIND, count = 20 },
    [257101] = { type = C.LUMBER_DATA.COLDWIND, count = 20 },
    [258210] = { type = C.LUMBER_DATA.COLDWIND, count = 10 },
    [257094] = { type = C.LUMBER_DATA.COLDWIND, count = 12 },
    [258206] = { type = C.LUMBER_DATA.COLDWIND, count = 10 },
    [264710] = { type = C.LUMBER_DATA.COLDWIND, count = 8 },
    [258209] = { type = C.LUMBER_DATA.COLDWIND, count = 6 },
    [258208] = { type = C.LUMBER_DATA.COLDWIND, count = 8 },
    [257693] = { type = C.LUMBER_DATA.COLDWIND, count = 12 },
    [249143] = { type = C.LUMBER_DATA.ASHWOOD, count = 12 },
    [257409] = { type = C.LUMBER_DATA.ASHWOOD, count = 35 },
    [264712] = { type = C.LUMBER_DATA.ASHWOOD, count = 12 },
    [257806] = { type = C.LUMBER_DATA.ASHWOOD, count = 40 },
    [257689] = { type = C.LUMBER_DATA.ASHWOOD, count = 50 },
    [245602] = { type = C.LUMBER_DATA.ASHWOOD, count = 40 },
    [245621] = { type = C.LUMBER_DATA.ASHWOOD, count = 25 },
    [257402] = { type = C.LUMBER_DATA.ASHWOOD, count = 26 },
    [257695] = { type = C.LUMBER_DATA.ASHWOOD, count = 35 },
    [257095] = { type = C.LUMBER_DATA.ASHWOOD, count = 20 },
    [245517] = { type = C.LUMBER_DATA.ASHWOOD, count = 30 },
    [264677] = { type = C.LUMBER_DATA.ASHWOOD, count = 14 },
    [245623] = { type = C.LUMBER_DATA.ASHWOOD, count = 25 },
    [245618] = { type = C.LUMBER_DATA.ASHWOOD, count = 35 },
    [245622] = { type = C.LUMBER_DATA.ASHWOOD, count = 10 },
    [257406] = { type = C.LUMBER_DATA.ASHWOOD, count = 8 },
    [257696] = { type = C.LUMBER_DATA.ASHWOOD, count = 8 },
    [257042] = { type = C.LUMBER_DATA.ASHWOOD, count = 8 },
    [257694] = { type = C.LUMBER_DATA.ASHWOOD, count = 10 },
    [257404] = { type = C.LUMBER_DATA.ASHWOOD, count = 8 },
    [258216] = { type = C.LUMBER_DATA.BAMBOO, count = 50 },
    [247661] = { type = C.LUMBER_DATA.BAMBOO, count = 25 },
    [247733] = { type = C.LUMBER_DATA.BAMBOO, count = 30 },
    [247669] = { type = C.LUMBER_DATA.BAMBOO, count = 45 },
    [247752] = { type = C.LUMBER_DATA.BAMBOO, count = 40 },
    [247736] = { type = C.LUMBER_DATA.BAMBOO, count = 50 },
    [247767] = { type = C.LUMBER_DATA.BAMBOO, count = 30 },
    [257097] = { type = C.LUMBER_DATA.BAMBOO, count = 30 },
    [247856] = { type = C.LUMBER_DATA.BAMBOO, count = 40 },
    [247220] = { type = C.LUMBER_DATA.BAMBOO, count = 18 },
    [247731] = { type = C.LUMBER_DATA.BAMBOO, count = 15 },
    [245509] = { type = C.LUMBER_DATA.BAMBOO, count = 15 },
    [245513] = { type = C.LUMBER_DATA.BAMBOO, count = 20 },
    [247735] = { type = C.LUMBER_DATA.BAMBOO, count = 20 },
    [257096] = { type = C.LUMBER_DATA.BAMBOO, count = 8 },
    [258214] = { type = C.LUMBER_DATA.BAMBOO, count = 16 },
    [247738] = { type = C.LUMBER_DATA.BAMBOO, count = 25 },
    [245514] = { type = C.LUMBER_DATA.BAMBOO, count = 25 },
    [247728] = { type = C.LUMBER_DATA.BAMBOO, count = 10 },
    [258302] = { type = C.LUMBER_DATA.BAMBOO, count = 8 },
    [257043] = { type = C.LUMBER_DATA.BAMBOO, count = 6 },
    [245600] = { type = C.LUMBER_DATA.SHADOWMOON, count = 45 },
    [244323] = { type = C.LUMBER_DATA.SHADOWMOON, count = 22 },
    [245432] = { type = C.LUMBER_DATA.SHADOWMOON, count = 40 },
    [245421] = { type = C.LUMBER_DATA.SHADOWMOON, count = 35 },
    [245601] = { type = C.LUMBER_DATA.SHADOWMOON, count = 30 },
    [245534] = { type = C.LUMBER_DATA.SHADOWMOON, count = 25 },
    [257044] = { type = C.LUMBER_DATA.SHADOWMOON, count = 25 },
    [245436] = { type = C.LUMBER_DATA.SHADOWMOON, count = 40 },
    [251546] = { type = C.LUMBER_DATA.SHADOWMOON, count = 30 },
    [251495] = { type = C.LUMBER_DATA.SHADOWMOON, count = 25 },
    [251482] = { type = C.LUMBER_DATA.SHADOWMOON, count = 20 },
    [244314] = { type = C.LUMBER_DATA.SHADOWMOON, count = 25 },
    [244319] = { type = C.LUMBER_DATA.SHADOWMOON, count = 8 },
    [245441] = { type = C.LUMBER_DATA.SHADOWMOON, count = 10 },
    [251550] = { type = C.LUMBER_DATA.SHADOWMOON, count = 8 },
    [244313] = { type = C.LUMBER_DATA.SHADOWMOON, count = 15 },
    [244318] = { type = C.LUMBER_DATA.SHADOWMOON, count = 16 },
    [251655] = { type = C.LUMBER_DATA.SHADOWMOON, count = 10 },
    [245428] = { type = C.LUMBER_DATA.SHADOWMOON, count = 8 },
    [258303] = { type = C.LUMBER_DATA.SHADOWMOON, count = 8 },
    [244317] = { type = C.LUMBER_DATA.SHADOWMOON, count = 6 },
    [247920] = { type = C.LUMBER_DATA.FEL, count = 30 },
    [258224] = { type = C.LUMBER_DATA.FEL, count = 22 },
    [247925] = { type = C.LUMBER_DATA.FEL, count = 20 },
    [256681] = { type = C.LUMBER_DATA.FEL, count = 48 },
    [257400] = { type = C.LUMBER_DATA.FEL, count = 34 },
    [247923] = { type = C.LUMBER_DATA.FEL, count = 34 },
    [247918] = { type = C.LUMBER_DATA.FEL, count = 28 },
    [245408] = { type = C.LUMBER_DATA.FEL, count = 35 },
    [258225] = { type = C.LUMBER_DATA.FEL, count = 28 },
    [258226] = { type = C.LUMBER_DATA.FEL, count = 22 },
    [245406] = { type = C.LUMBER_DATA.FEL, count = 20 },
    [256680] = { type = C.LUMBER_DATA.FEL, count = 50 },
    [245396] = { type = C.LUMBER_DATA.FEL, count = 30 },
    [245557] = { type = C.LUMBER_DATA.FEL, count = 25 },
    [247916] = { type = C.LUMBER_DATA.FEL, count = 35 },
    [257045] = { type = C.LUMBER_DATA.FEL, count = 18 },
    [258227] = { type = C.LUMBER_DATA.FEL, count = 12 },
    [245407] = { type = C.LUMBER_DATA.FEL, count = 15 },
    [247922] = { type = C.LUMBER_DATA.FEL, count = 15 },
    [245459] = { type = C.LUMBER_DATA.FEL, count = 15 },
    [247909] = { type = C.LUMBER_DATA.FEL, count = 10 },
    [258557] = { type = C.LUMBER_DATA.FEL, count = 8 },
    [248010] = { type = C.LUMBER_DATA.FEL, count = 40 },
    [258558] = { type = C.LUMBER_DATA.DARKPINE, count = 22 },
    [245412] = { type = C.LUMBER_DATA.DARKPINE, count = 40 },
    [258559] = { type = C.LUMBER_DATA.DARKPINE, count = 35 },
    [245418] = { type = C.LUMBER_DATA.DARKPINE, count = 35 },
    [246604] = { type = C.LUMBER_DATA.DARKPINE, count = 42 },
    [245499] = { type = C.LUMBER_DATA.DARKPINE, count = 35 },
    [245496] = { type = C.LUMBER_DATA.DARKPINE, count = 20 },
    [252389] = { type = C.LUMBER_DATA.DARKPINE, count = 8 },
    [243101] = { type = C.LUMBER_DATA.DARKPINE, count = 30 },
    [246486] = { type = C.LUMBER_DATA.DARKPINE, count = 45 },
    [246500] = { type = C.LUMBER_DATA.DARKPINE, count = 16 },
    [245414] = { type = C.LUMBER_DATA.DARKPINE, count = 40 },
    [245416] = { type = C.LUMBER_DATA.DARKPINE, count = 10 },
    [252397] = { type = C.LUMBER_DATA.DARKPINE, count = 18 },
    [252399] = { type = C.LUMBER_DATA.DARKPINE, count = 20 },
    [245415] = { type = C.LUMBER_DATA.DARKPINE, count = 15 },
    [258560] = { type = C.LUMBER_DATA.DARKPINE, count = 6 },
    [257047] = { type = C.LUMBER_DATA.DARKPINE, count = 12 },
    [252035] = { type = C.LUMBER_DATA.DARKPINE, count = 6 },
    [252401] = { type = C.LUMBER_DATA.DARKPINE, count = 8 },
    [245484] = { type = C.LUMBER_DATA.DARKPINE, count = 8 },
    [257046] = { type = C.LUMBER_DATA.DARKPINE, count = 5 },
    [257048] = { type = C.LUMBER_DATA.ARDEN, count = 45 },
    [258248] = { type = C.LUMBER_DATA.ARDEN, count = 30 },
    [258242] = { type = C.LUMBER_DATA.ARDEN, count = 50 },
    [258252] = { type = C.LUMBER_DATA.ARDEN, count = 42 },
    [260699] = { type = C.LUMBER_DATA.ARDEN, count = 30 },
    [258247] = { type = C.LUMBER_DATA.ARDEN, count = 20 },
    [264713] = { type = C.LUMBER_DATA.ARDEN, count = 45 },
    [258250] = { type = C.LUMBER_DATA.ARDEN, count = 35 },
    [258244] = { type = C.LUMBER_DATA.ARDEN, count = 24 },
    [262663] = { type = C.LUMBER_DATA.ARDEN, count = 18 },
    [258238] = { type = C.LUMBER_DATA.ARDEN, count = 18 },
    [258237] = { type = C.LUMBER_DATA.ARDEN, count = 30 },
    [258235] = { type = C.LUMBER_DATA.ARDEN, count = 28 },
    [258240] = { type = C.LUMBER_DATA.ARDEN, count = 18 },
    [258245] = { type = C.LUMBER_DATA.ARDEN, count = 16 },
    [257051] = { type = C.LUMBER_DATA.ARDEN, count = 9 },
    [264678] = { type = C.LUMBER_DATA.ARDEN, count = 16 },
    [258561] = { type = C.LUMBER_DATA.ARDEN, count = 14 },
    [257050] = { type = C.LUMBER_DATA.ARDEN, count = 12 },
    [258239] = { type = C.LUMBER_DATA.ARDEN, count = 10 },
    [246705] = { type = C.LUMBER_DATA.ARDEN, count = 8 },
    [257049] = { type = C.LUMBER_DATA.ARDEN, count = 8 },
    [257098] = { type = C.LUMBER_DATA.ARDEN, count = 6 },
    [256430] = { type = C.LUMBER_DATA.DRAGONPINE, count = 46 },
    [257053] = { type = C.LUMBER_DATA.DRAGONPINE, count = 28 },
    [248657] = { type = C.LUMBER_DATA.DRAGONPINE, count = 40 },
    [248113] = { type = C.LUMBER_DATA.DRAGONPINE, count = 25 },
    [258253] = { type = C.LUMBER_DATA.DRAGONPINE, count = 50 },
    [256170] = { type = C.LUMBER_DATA.DRAGONPINE, count = 50 },
    [256427] = { type = C.LUMBER_DATA.DRAGONPINE, count = 42 },
    [248114] = { type = C.LUMBER_DATA.DRAGONPINE, count = 45 },
    [247224] = { type = C.LUMBER_DATA.DRAGONPINE, count = 22 },
    [248654] = { type = C.LUMBER_DATA.DRAGONPINE, count = 26 },
    [248121] = { type = C.LUMBER_DATA.DRAGONPINE, count = 35 },
    [248106] = { type = C.LUMBER_DATA.DRAGONPINE, count = 10 },
    [247222] = { type = C.LUMBER_DATA.DRAGONPINE, count = 28 },
    [264679] = { type = C.LUMBER_DATA.DRAGONPINE, count = 18 },
    [248108] = { type = C.LUMBER_DATA.DRAGONPINE, count = 14 },
    [248118] = { type = C.LUMBER_DATA.DRAGONPINE, count = 15 },
    [247225] = { type = C.LUMBER_DATA.DRAGONPINE, count = 25 },
    [257052] = { type = C.LUMBER_DATA.DRAGONPINE, count = 7 },
    [248107] = { type = C.LUMBER_DATA.DRAGONPINE, count = 10 },
    [248120] = { type = C.LUMBER_DATA.DRAGONPINE, count = 16 },
    [248119] = { type = C.LUMBER_DATA.DRAGONPINE, count = 16 },
    [248110] = { type = C.LUMBER_DATA.DRAGONPINE, count = 10 },
    [248111] = { type = C.LUMBER_DATA.DRAGONPINE, count = 28 },
    [256171] = { type = C.LUMBER_DATA.DRAGONPINE, count = 16 },
    [248109] = { type = C.LUMBER_DATA.DRAGONPINE, count = 15 },
    [253253] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 25 },
    [253252] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 42 },
    [253169] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 26 },
    [239214] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 38 },
    [252755] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 30 },
    [253022] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 50 },
    [243327] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 30 },
    [239170] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 15 },
    [245326] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 25 },
    [253171] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 40 },
    [253036] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 35 },
    [245323] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 30 },
    [245559] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 16 },
    [253167] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 18 },
    [252758] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 34 },
    [245312] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 15 },
    [246708] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 10 },
    [246066] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 12 },
    [253165] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 10 },
    [253164] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 15 },
    [245305] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 20 },
    [253039] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 10 },
    [257102] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 8 },
    [246709] = { type = C.LUMBER_DATA.DORNIC_FIR, count = 5 },
}

C.CLASS_MAINS = {
    ["MAGE"]         = { main = "Burin - Bloodhoof",    version = 1 },
    ["DEATHKNIGHT"]  = { main = "Bari - Bloodhoof",     version = 1 },
    ["SHAMAN"]       = { main = "Borr - Bloodhoof",     version = 1 },
    ["DEMONHUNTER"]  = { main = "Mihoki - Argent Dawn", version = 1 },
    ["DRUID"]        = { main = "Mokuroa - Moonglade",  version = 1 },
    ["WARRIOR"]      = { main = "Jaiya - Bloodhoof",    version = 1 },
    ["MONK"]         = { main = "Gurabu - Tarren Mill", version = 1 },
    ["PALADIN"]      = { main = "Burr - Bloodhoof",     version = 1 },
    ["PRIEST"]       = { main = "Jinrami - Silvermoon", version = 1 },
    ["EVOKER"]       = { main = "Fiyonse - Silvermoon", version = 1 },
    ["ROGUE"]        = { main = "Sumoka - Tarren Mill", version = 1 },
    ["HUNTER"]       = { main = "Brokk - Bloodhoof",    version = 1 },
    ["WARLOCK"]      = { main = "Kinbo - Tarren Mill",  version = 1 },
}

C.ROSTER_DATA = {
    ["Burin - Bloodhoof"]           = { index = 1,  priority = 1,   class = "MAGE" },
    ["Bari - Bloodhoof"]            = { index = 2,  priority = 2,   class = "DEATHKNIGHT" },
    ["Borr - Bloodhoof"]            = { index = 3,  priority = 3,   class = "SHAMAN" },
    ["Mihoki - Argent Dawn"]        = { index = 4,  priority = 4,   class = "DEMONHUNTER" },
    ["Mokuroa - Moonglade"]         = { index = 5,  priority = 5,   class = "DRUID" },
    ["Jaiya - Bloodhoof"]           = { index = 6,  priority = 6,   class = "WARRIOR" },
    ["Gurabu - Tarren Mill"]        = { index = 7,  priority = 7,   class = "MONK" },
    ["Burr - Bloodhoof"]            = { index = 8,  priority = 8,   class = "PALADIN" },
    ["Jinrami - Silvermoon"]        = { index = 9,  priority = 9,   class = "PRIEST" },
    ["Fiyonse - Silvermoon"]        = { index = 10, priority = 10,  class = "EVOKER" },
    ["Sumoka - Tarren Mill"]        = { index = 11, priority = 11,  class = "ROGUE" },
    ["Brokk - Bloodhoof"]           = { index = 12, priority = 12,  class = "HUNTER" },
    ["Kinbo - Tarren Mill"]         = { index = 13, priority = 13,  class = "WARLOCK" },
    ["Jayax - Bloodhoof"]           = { index = 14, priority = 999, class = "DEMONHUNTER" },
    ["Hipnox - Bloodhoof"]          = { index = 15, priority = 999, class = "DRUID" },
    ["Hypnox - Bloodhoof"]          = { index = 16, priority = 999, class = "MONK" },
    ["Soniya - Bloodhoof"]          = { index = 17, priority = 999, class = "PRIEST" },
    ["Cygnoxi - Bloodhoof"]         = { index = 18, priority = 999, class = "EVOKER" },
    ["Cygnox - Bloodhoof"]          = { index = 19, priority = 999, class = "ROGUE" },
    ["Barador - Bloodhoof"]         = { index = 20, priority = 999, class = "WARLOCK" },
    ["Mizeru - Stormscale"]         = { index = 21, priority = 999, class = "MAGE" },
    ["Yamakaji - Stormscale"]       = { index = 22, priority = 999, class = "MAGE" },
    ["Nojiko - Stormscale"]         = { index = 23, priority = 999, class = "DEATHKNIGHT" },
    ["Harudin - Stormscale"]        = { index = 24, priority = 999, class = "DEATHKNIGHT" },
    ["Rinaria - Stormscale"]        = { index = 25, priority = 999, class = "SHAMAN" },
    ["Rokkusuta - Stormscale"]      = { index = 26, priority = 999, class = "SHAMAN" },
    ["Jaxi - Stormscale"]           = { index = 27, priority = 999, class = "DEMONHUNTER" },
    ["Cygnux - Stormscale"]         = { index = 28, priority = 999, class = "DRUID" },
    ["Roshio - Stormscale"]         = { index = 29, priority = 999, class = "DRUID" },
    ["Cygnax - Stormscale"]         = { index = 30, priority = 999, class = "WARRIOR" },
    ["Nokotti - Stormscale"]        = { index = 31, priority = 999, class = "WARRIOR" },
    ["Sonixa - Stormscale"]         = { index = 32, priority = 999, class = "MONK" },
    ["Kasutado - Stormscale"]       = { index = 33, priority = 999, class = "MONK" },
    ["Sonyia - Stormscale"]         = { index = 34, priority = 999, class = "PALADIN" },
    ["Askle - Stormscale"]          = { index = 35, priority = 999, class = "PRIEST" },
    ["Cygnix - Stormscale"]         = { index = 36, priority = 999, class = "EVOKER" },
    ["Burokka - Stormscale"]        = { index = 37, priority = 999, class = "ROGUE" },
    ["Roji - Stormscale"]           = { index = 38, priority = 999, class = "HUNTER" },
    ["Beretto - Stormscale"]        = { index = 39, priority = 999, class = "HUNTER" },
    ["Shipusuheddo - Stormscale"]   = { index = 40, priority = 999, class = "WARLOCK" },
    ["Mizeruka - Stormscale"]       = { index = 41, priority = 999, class = "WARLOCK" },
    ["Howaitibei - Silvermoon"]     = { index = 42, priority = 999, class = "MAGE" },
    ["Karibu - Silvermoon"]         = { index = 43, priority = 999, class = "DEATHKNIGHT" },
    ["Esusuneku - Silvermoon"]      = { index = 44, priority = 999, class = "SHAMAN" },
    ["Mihoku - Silvermoon"]         = { index = 45, priority = 999, class = "DEMONHUNTER" },
    ["Neferutari - Silvermoon"]     = { index = 46, priority = 999, class = "DRUID" },
    ["Kozaburo - Silvermoon"]       = { index = 47, priority = 999, class = "WARRIOR" },
    ["Kunyun - Silvermoon"]         = { index = 48, priority = 999, class = "MONK" },
    ["Komurasaka - Silvermoon"]     = { index = 49, priority = 999, class = "PALADIN" },
    ["Ipponmatsu - Silvermoon"]     = { index = 50, priority = 999, class = "ROGUE" },
    ["Jurakyuru - Silvermoon"]      = { index = 51, priority = 999, class = "HUNTER" },
    ["Kazuria - Tarren Mill"]       = { index = 52, priority = 999, class = "MAGE" },
    ["Korugan - Tarren Mill"]       = { index = 53, priority = 999, class = "DEATHKNIGHT" },
    ["Rinami - Tarren Mill"]        = { index = 54, priority = 999, class = "DEMONHUNTER" },
    ["Rykuna - Tarren Mill"]        = { index = 55, priority = 999, class = "WARRIOR" },
    ["Sokaru - Tarren Mill"]        = { index = 56, priority = 999, class = "PALADIN" },
    ["Vaesthra - Tarren Mill"]      = { index = 57, priority = 999, class = "PRIEST" },
    ["Jujiro - Tarren Mill"]        = { index = 58, priority = 999, class = "HUNTER" },
    ["Jisumi - Argent Dawn"]        = { index = 59, priority = 999, class = "MAGE" },
    ["Miruki - Argent Dawn"]        = { index = 60, priority = 999, class = "DRUID" },
    ["Enzeru - Moonglade"]          = { index = 61, priority = 999, class = "DRUID" },
    ["Rinashu - Moonglade"]         = { index = 62, priority = 999, class = "DRUID" },
    ["Bogado - Moonglade"]          = { index = 63, priority = 999, class = "MONK" },
    ["Erumi - Moonglade"]           = { index = 64, priority = 999, class = "EVOKER" },
    ["Akudai - Moonglade"]          = { index = 65, priority = 999, class = "HUNTER" },
    ["Hiramera - Moonglade"]        = { index = 66, priority = 999, class = "HUNTER" },
    ["Kozetto - Moonglade"]         = { index = 67, priority = 999, class = "HUNTER" },
    ["Kujaku - Moonglade"]          = { index = 68, priority = 999, class = "HUNTER" },
    ["Dizeru - Moonglade"]          = { index = 69, priority = 999, class = "HUNTER" },
    ["Melios - Bloodhoof"]          = { index = 70, priority = 999, class = "PRIEST" },
}

C.TRACKED_QUESTS = {
    -- Case 1: Universal ID (Same for everyone)
    -- { name = "Special Assignment", id = 82689 },

    -- Case 2: Faction-Specific, NOT a holiday (e.g. Intro quests)
    -- { name = "Faction Intro", horde = 12345, alliance = 67890 }, 

    -- Case 3: Faction-Specific AND a holiday
    { name = "Love is in the Air", horde = 78985, alliance = 78379, isHoliday = true },
    -- { name = "Lunar Festival",    horde = 12345, alliance = 67890, isHoliday = true },
}

-- =====================================================
-- Loader Functions (Filtered Debugging with Fallback)
-- =====================================================
local function Log(prefix, hex, module, ...)
    local name = (type(module) == "table" and module.GetName) and module:GetName() or tostring(module or "CX")
    print(prefix, string.format("[|cff%s%s|r]", hex, name), ...)
end

function C:Print(module, ...)
    Log("|cff00AAFF[Cobalt]|r", "00FF00", module, ...)
end

function C:Debug(module, ...)
    if not (D and D.dev and D.dev.debugMode) then return end

    local name = (type(module) == "table" and module.GetName) and module:GetName() or tostring(module or "CX")
    local msg = ...

    if D.dev.showModuleStatus == false and (msg == C.MODULE_ENABLED or msg == C.MODULE_DISABLED) then 
        return 
    end

    local filter = D.dev.moduleFilter

    if not filter or next(filter) == nil or filter[name] then
        Log("|cffFF79AC[Cobalt]|r", "00FF00", module, ...)
    end
end

-- Utility function: returns true if the holiday name is found for today
function C:IsHolidayActive(holidayName)
    local day = tonumber(date("%d")) or 0
    local numEvents = C_Calendar.GetNumDayEvents(0, day)

    for i = 1, numEvents do
        local info = C_Calendar.GetHolidayInfo(0, day, i)
        if info and info.name == holidayName then
            return true
        end
    end

    return false
end

function C:SlashHandler(input)
    -- Since 'C' (the main addon) has AceConsole-3.0, GetArgs works here!
    local command = self:GetArgs(input, 1)
    command = (command and command:lower()) or ""

    if command == "toggle" or command == "" then
        local P = self:GetModule("Panel", true)
        if P and P.Toggle then
            P:Toggle()
        else
            self:Print("Error: Panel module not found.")
        end
    else
        self:Print("Usage: /cobalt [toggle]")
    end
end

-- =====================================================
-- Lifecycle
-- =====================================================
function C:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)
end