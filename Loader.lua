local C = select(2, ...)
--#region MARK: CONSTANTS
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
    ["MIDNIGHT"]     = { color = "|cff7a8cff", label = "Midnight" },
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
    ["THALASSIAN"] = { name = "Thalassian Lumber",  exp = C.EXPANSIONS.MIDNIGHT },
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
    [246460] = { type = C.LUMBER_DATA.THALASSIAN, count = 30 }, -- Ambient Aethercharged Crystal
    [262459] = { type = C.LUMBER_DATA.THALASSIAN, count = 14 }, -- Animated Sin'dorei Hammer
    [262458] = { type = C.LUMBER_DATA.THALASSIAN, count = 14 }, -- Animated Sin'dorei Pick
    [262471] = { type = C.LUMBER_DATA.THALASSIAN, count = 24 }, -- Bejeweled Sin'dorei Lyre
    [262469] = { type = C.LUMBER_DATA.THALASSIAN, count = 36 }, -- Brilliant Phoenix Harp
    [262491] = { type = C.LUMBER_DATA.THALASSIAN, count = 8  }, -- Chic Silvermoon Pillow
    [262483] = { type = C.LUMBER_DATA.THALASSIAN, count = 24 }, -- Embossed Sin'dorei Fur Rug
    [262461] = { type = C.LUMBER_DATA.THALASSIAN, count = 50 }, -- Endless Codex of Blooming Light
    [262462] = { type = C.LUMBER_DATA.THALASSIAN, count = 50 }, -- Endless Codex of Nature's Grace
    [262463] = { type = C.LUMBER_DATA.THALASSIAN, count = 50 }, -- Endless Codex of the Voidtouched
    [262464] = { type = C.LUMBER_DATA.THALASSIAN, count = 22 }, -- Ensorcelled Broom
    [262355] = { type = C.LUMBER_DATA.THALASSIAN, count = 6  }, -- Entropic Illuminant
    [262473] = { type = C.LUMBER_DATA.THALASSIAN, count = 22 }, -- Floating Void-Touched Tome
    [262455] = { type = C.LUMBER_DATA.THALASSIAN, count = 14 }, -- Font of Gleaming Water
    [262474] = { type = C.LUMBER_DATA.THALASSIAN, count = 6  }, -- Gilded Eversong Book
    [262451] = { type = C.LUMBER_DATA.THALASSIAN, count = 26 }, -- Gilded Silvermoon Anvil
    [262457] = { type = C.LUMBER_DATA.THALASSIAN, count = 18 }, -- Gilded Silvermoon Hanger
    [262475] = { type = C.LUMBER_DATA.THALASSIAN, count = 18 }, -- Harandar Signpost
    [262484] = { type = C.LUMBER_DATA.THALASSIAN, count = 24 }, -- Haranir Canopy Bed
    [262356] = { type = C.LUMBER_DATA.THALASSIAN, count = 6  }, -- Haranir Preserving Agents
    [262476] = { type = C.LUMBER_DATA.THALASSIAN, count = 24 }, -- Homely Sin'dorei Shelf
    [262477] = { type = C.LUMBER_DATA.THALASSIAN, count = 24 }, -- Homely Wall Shelves
    [262485] = { type = C.LUMBER_DATA.THALASSIAN, count = 5  }, -- Leather-Bound Haranir Wall Shelf
    [262478] = { type = C.LUMBER_DATA.THALASSIAN, count = 18 }, -- Lively Songwriter's Quill
    [262492] = { type = C.LUMBER_DATA.THALASSIAN, count = 31 }, -- Lush Telogrus Carpet
    [262493] = { type = C.LUMBER_DATA.THALASSIAN, count = 12 }, -- Luxurious Silvermoon Lounge Cushion
    [262479] = { type = C.LUMBER_DATA.THALASSIAN, count = 50 }, -- Magnificent Towering Bookcase
    [262452] = { type = C.LUMBER_DATA.THALASSIAN, count = 12 }, -- Masterwork Crafting Hammer
    [262480] = { type = C.LUMBER_DATA.THALASSIAN, count = 6  }, -- Opened Sin'dorei Scroll
    [262456] = { type = C.LUMBER_DATA.THALASSIAN, count = 18 }, -- Ornamental Silvermoon Hanger
    [262486] = { type = C.LUMBER_DATA.THALASSIAN, count = 10 }, -- Plush Haranir Leather Pillow
    [262494] = { type = C.LUMBER_DATA.THALASSIAN, count = 34 }, -- Plush Silvermoon Bed
    [262460] = { type = C.LUMBER_DATA.THALASSIAN, count = 26 }, -- Ren'dorei Anvil
    [262466] = { type = C.LUMBER_DATA.THALASSIAN, count = 24 }, -- Ren'dorei Crafting Framework
    [262467] = { type = C.LUMBER_DATA.THALASSIAN, count = 26 }, -- Ren'dorei Lightpost
    [262468] = { type = C.LUMBER_DATA.THALASSIAN, count = 10 }, -- Ren'dorei Postal Repository
    [262465] = { type = C.LUMBER_DATA.THALASSIAN, count = 32 }, -- Ren'dorei Stargazer
    [262470] = { type = C.LUMBER_DATA.THALASSIAN, count = 20 }, -- Spellbound Tome of Thalassian Magics
    [262618] = { type = C.LUMBER_DATA.THALASSIAN, count = 22 }, -- Ren'dorei Void Projector
    [262602] = { type = C.LUMBER_DATA.THALASSIAN, count = 28 }, -- Ren'dorei Warp Orb
    [262481] = { type = C.LUMBER_DATA.THALASSIAN, count = 48 }, -- Replica Haranir Mural
    [262453] = { type = C.LUMBER_DATA.THALASSIAN, count = 50 }, -- Resplendent Highborne Statue
    [262482] = { type = C.LUMBER_DATA.THALASSIAN, count = 22 }, -- Restful Bronze Bench
    [262354] = { type = C.LUMBER_DATA.THALASSIAN, count = 8  }, -- Riftstone
    [253506] = { type = C.LUMBER_DATA.THALASSIAN, count = 63 }, -- Rootbound Vat
    [262590] = { type = C.LUMBER_DATA.THALASSIAN, count = 10 }, -- Rootflame Campfire
    [262495] = { type = C.LUMBER_DATA.THALASSIAN, count = 18 }, -- Self-Pouring Thalassian Sunwine
    [262454] = { type = C.LUMBER_DATA.THALASSIAN, count = 18 }, -- Shining Sin'dorei Hourglass
    [262487] = { type = C.LUMBER_DATA.THALASSIAN, count = 32 }, -- Silvermoon Curtains
    [262500] = { type = C.LUMBER_DATA.THALASSIAN, count = 66 }, -- Silvermoon Spire Fountain
    [262501] = { type = C.LUMBER_DATA.THALASSIAN, count = 20 }, -- Simple Haranir Table
}

C.CLASS_MAINS = {
    { class = "MAGE",         main = "Burin - Bloodhoof"    },
    { class = "DEATHKNIGHT",  main = "Bari - Bloodhoof"     },
    { class = "SHAMAN",       main = "Borr - Bloodhoof"     },
    { class = "DEMONHUNTER",  main = "Mihoki - Argent Dawn" },
    { class = "DRUID",        main = "Mokuroa - Moonglade"  },
    { class = "WARRIOR",      main = "Jaiya - Bloodhoof"    },
    { class = "MONK",         main = "Gurabu - Tarren Mill" },
    { class = "PALADIN",      main = "Burr - Bloodhoof"     },
    { class = "PRIEST",       main = "Jinrami - Silvermoon" },
    { class = "EVOKER",       main = "Fiyonse - Silvermoon" },
    { class = "ROGUE",        main = "Sumoka - Tarren Mill" },
    { class = "HUNTER",       main = "Brokk - Bloodhoof"    },
    { class = "WARLOCK",      main = "Kinbo - Tarren Mill"  },
}

C.CLASS_PRIORITY = {
    ["MAGE"]         = C.CLASS_MAINS[1],
    ["DEATHKNIGHT"]  = C.CLASS_MAINS[2],
    ["SHAMAN"]       = C.CLASS_MAINS[3],
    ["DEMONHUNTER"]  = C.CLASS_MAINS[4],
    ["DRUID"]        = C.CLASS_MAINS[5],
    ["WARRIOR"]      = C.CLASS_MAINS[6],
    ["MONK"]         = C.CLASS_MAINS[7],
    ["PALADIN"]      = C.CLASS_MAINS[8],
    ["PRIEST"]       = C.CLASS_MAINS[9],
    ["EVOKER"]       = C.CLASS_MAINS[10],
    ["ROGUE"]        = C.CLASS_MAINS[11],
    ["HUNTER"]       = C.CLASS_MAINS[12],
    ["WARLOCK"]      = C.CLASS_MAINS[13],
}

C.ROSTER = {
    ["Burin - Bloodhoof"]           = { index = 1,  priority = 1,   class = "MAGE",         roles = { main = true } },
    ["Bari - Bloodhoof"]            = { index = 2,  priority = 2,   class = "DEATHKNIGHT",  roles = { main = true } },
    ["Borr - Bloodhoof"]            = { index = 3,  priority = 3,   class = "SHAMAN",       roles = { main = true } },
    ["Mihoki - Argent Dawn"]        = { index = 4,  priority = 4,   class = "DEMONHUNTER",  roles = { main = true } },
    ["Mokuroa - Moonglade"]         = { index = 5,  priority = 5,   class = "DRUID",        roles = { main = true } },
    ["Jaiya - Bloodhoof"]           = { index = 6,  priority = 6,   class = "WARRIOR",      roles = { main = true } },
    ["Gurabu - Tarren Mill"]        = { index = 7,  priority = 7,   class = "MONK",         roles = { main = true } },
    ["Burr - Bloodhoof"]            = { index = 8,  priority = 8,   class = "PALADIN",      roles = { main = true } },
    ["Jinrami - Silvermoon"]        = { index = 9,  priority = 9,   class = "PRIEST",       roles = { main = true } },
    ["Fiyonse - Silvermoon"]        = { index = 10, priority = 10,  class = "EVOKER",       roles = { main = true } },
    ["Sumoka - Tarren Mill"]        = { index = 11, priority = 11,  class = "ROGUE",        roles = { main = true } },
    ["Brokk - Bloodhoof"]           = { index = 12, priority = 12,  class = "HUNTER",       roles = { main = true } },
    ["Kinbo - Tarren Mill"]         = { index = 13, priority = 13,  class = "WARLOCK",      roles = { main = true } },
    ["Jayax - Bloodhoof"]           = { index = 14, priority = 999, class = "DEMONHUNTER",  roles = {} },
    ["Hipnox - Bloodhoof"]          = { index = 15, priority = 999, class = "DRUID",        roles = {} },
    ["Hypnox - Bloodhoof"]          = { index = 16, priority = 999, class = "MONK",         roles = {} },
    ["Soniya - Bloodhoof"]          = { index = 17, priority = 999, class = "PRIEST",       roles = {} },
    ["Cygnoxi - Bloodhoof"]         = { index = 18, priority = 999, class = "EVOKER",       roles = {} },
    ["Cygnox - Bloodhoof"]          = { index = 19, priority = 999, class = "ROGUE",        roles = {} },
    ["Barador - Bloodhoof"]         = { index = 20, priority = 999, class = "WARLOCK",      roles = {} },
    ["Mizeru - Stormscale"]         = { index = 21, priority = 999, class = "MAGE",         roles = {} },
    ["Yamakaji - Stormscale"]       = { index = 22, priority = 999, class = "MAGE",         roles = {} },
    ["Nojiko - Stormscale"]         = { index = 23, priority = 999, class = "DEATHKNIGHT",  roles = {} },
    ["Harudin - Stormscale"]        = { index = 24, priority = 999, class = "DEATHKNIGHT",  roles = {} },
    ["Rinaria - Stormscale"]        = { index = 25, priority = 999, class = "SHAMAN",       roles = {} },
    ["Rokkusuta - Stormscale"]      = { index = 26, priority = 999, class = "SHAMAN",       roles = {} },
    ["Jaxi - Stormscale"]           = { index = 27, priority = 999, class = "DEMONHUNTER",  roles = {} },
    ["Cygnux - Stormscale"]         = { index = 28, priority = 999, class = "DRUID",        roles = {} },
    ["Roshio - Stormscale"]         = { index = 29, priority = 999, class = "DRUID",        roles = {} },
    ["Cygnax - Stormscale"]         = { index = 30, priority = 999, class = "WARRIOR",      roles = { banker = true } },
    ["Nokotti - Stormscale"]        = { index = 31, priority = 999, class = "WARRIOR",      roles = {} },
    ["Sonixa - Stormscale"]         = { index = 32, priority = 999, class = "MONK",         roles = {} },
    ["Kasutado - Stormscale"]       = { index = 33, priority = 999, class = "MONK",         roles = {} },
    ["Sonyia - Stormscale"]         = { index = 34, priority = 999, class = "PALADIN",      roles = {} },
    ["Askle - Stormscale"]          = { index = 35, priority = 999, class = "PRIEST",       roles = {} },
    ["Cygnix - Stormscale"]         = { index = 36, priority = 999, class = "EVOKER",       roles = {} },
    ["Burokka - Stormscale"]        = { index = 37, priority = 999, class = "ROGUE",        roles = {} },
    ["Roji - Stormscale"]           = { index = 38, priority = 999, class = "HUNTER",       roles = {} },
    ["Beretto - Stormscale"]        = { index = 39, priority = 999, class = "HUNTER",       roles = {} },
    ["Shipusuheddo - Stormscale"]   = { index = 40, priority = 999, class = "WARLOCK",      roles = { banker = true } },
    ["Mizeruka - Stormscale"]       = { index = 41, priority = 999, class = "WARLOCK",      roles = {} },
    ["Howaitibei - Silvermoon"]     = { index = 42, priority = 999, class = "MAGE",         roles = {} },
    ["Karibu - Silvermoon"]         = { index = 43, priority = 999, class = "DEATHKNIGHT",  roles = {} },
    ["Esusuneku - Silvermoon"]      = { index = 44, priority = 999, class = "SHAMAN",       roles = {} },
    ["Mihoku - Silvermoon"]         = { index = 45, priority = 999, class = "DEMONHUNTER",  roles = {} },
    ["Neferutari - Silvermoon"]     = { index = 46, priority = 999, class = "DRUID",        roles = {} },
    ["Kozaburo - Silvermoon"]       = { index = 47, priority = 999, class = "WARRIOR",      roles = { banker = true } },
    ["Kunyun - Silvermoon"]         = { index = 48, priority = 999, class = "MONK",         roles = {} },
    ["Komurasaka - Silvermoon"]     = { index = 49, priority = 999, class = "PALADIN",      roles = {} },
    ["Ipponmatsu - Silvermoon"]     = { index = 50, priority = 999, class = "ROGUE",        roles = {} },
    ["Jurakyuru - Silvermoon"]      = { index = 51, priority = 999, class = "HUNTER",       roles = {} },
    ["Kazuria - Tarren Mill"]       = { index = 52, priority = 999, class = "MAGE",         roles = {} },
    ["Korugan - Tarren Mill"]       = { index = 53, priority = 999, class = "DEATHKNIGHT",  roles = { banker = true } },
    ["Rinami - Tarren Mill"]        = { index = 54, priority = 999, class = "DEMONHUNTER",  roles = {} },
    ["Rykuna - Tarren Mill"]        = { index = 55, priority = 999, class = "WARRIOR",      roles = {} },
    ["Sokaru - Tarren Mill"]        = { index = 56, priority = 999, class = "PALADIN",      roles = {} },
    ["Vaesthra - Tarren Mill"]      = { index = 57, priority = 999, class = "PRIEST",       roles = {} },
    ["Jujiro - Tarren Mill"]        = { index = 58, priority = 999, class = "HUNTER",       roles = {} },
    ["Jisumi - Argent Dawn"]        = { index = 59, priority = 999, class = "MAGE",         roles = { banker = true } },
    ["Miruki - Argent Dawn"]        = { index = 60, priority = 999, class = "DRUID",        roles = {} },
    ["Enzeru - Moonglade"]          = { index = 61, priority = 999, class = "DRUID",        roles = {} },
    ["Rinashu - Moonglade"]         = { index = 62, priority = 999, class = "DRUID",        roles = {} },
    ["Bogado - Moonglade"]          = { index = 63, priority = 999, class = "MONK",         roles = {} },
    ["Erumi - Moonglade"]           = { index = 64, priority = 999, class = "EVOKER",       roles = {} },
    ["Akudai - Moonglade"]          = { index = 65, priority = 999, class = "HUNTER",       roles = {} },
    ["Hiramera - Moonglade"]        = { index = 66, priority = 999, class = "HUNTER",       roles = {} },
    ["Kozetto - Moonglade"]         = { index = 67, priority = 999, class = "HUNTER",       roles = {} },
    ["Kujaku - Moonglade"]          = { index = 68, priority = 999, class = "HUNTER",       roles = { banker = true } },
    ["Dizeru - Moonglade"]          = { index = 69, priority = 999, class = "HUNTER",       roles = {} },
    ["Melios - Bloodhoof"]          = { index = 70, priority = 999, class = "PRIEST",       roles = { banker = true } },
}

C.TRACKED_QUESTS = {
    -- Darkmoon Faire: Primary Professions
    -- { name = "Alchemy | A Fizzy Fusion", id = 29506 },
    -- { name = "Blacksmithing | Baby Needs Two Pair of Shoes", id = 29508 },
    -- { name = "Enchanting | Putting Trash to Good Use", id = 29510 },
    -- { name = "Engineering | Talkin' Tonks", id = 29511 },
    -- { name = "Herbalism | Herbs for Healing", id = 29514 },
    -- { name = "Inscription | Writing the Future", id = 29515 },
    -- { name = "Jewelcrafting | Keeping the Faire Sparkling", id = 29516 },
    -- { name = "Leatherworking | Eyes on the Prizes", id = 29517 },
    -- { name = "Mining | Rearm, Reuse, Recycle", id = 29518 },
    -- { name = "Skinning | Tan My Hide", id = 29519 },
    -- { name = "Tailoring | Banners, Banners Everywhere!", id = 29520 },

    -- -- Darkmoon Faire: Secondary Professions
    -- { name = "Archaeology | Fun for the Little Ones", id = 29507 },
    -- { name = "Cooking | Putting the Crunch in the Frog", id = 29509 },
    -- { name = "Fishing | Spoilin' for Salty Sea Dogs", id = 29513 },

    -- Case 1: Universal ID (Same for everyone)
    -- { name = "Special Assignment", id = 82689 },
    { name = "Crafter's Needed", id = 93723 },

    -- Case 2: Faction-Specific, NOT a holiday (e.g. Intro quests)
    -- { name = "Faction Intro", horde = 12345, alliance = 67890 },

    -- Case 3: Faction-Specific AND a holiday
    { name = "Love is in the Air", horde = 78985, alliance = 78379, isHoliday = true },
    -- { name = "Lunar Festival",    horde = 12345, alliance = 67890, isHoliday = true },
}
--#endregion

--#region MARK: LOADER FUNCTIONS
local function Log(prefix, hex, module, ...)
    local name = (type(module) == "table" and module.GetName) and module:GetName() or tostring(module or "CX")
    print(prefix, string.format("[|cff%s%s|r]", hex, name), ...)
end

function C:Print(module, ...)
    Log("|cff00AAFF[Cobalt]|r", "00FF00", module, ...)
end

function C:Debug(module, ...)
    if not (C.DB and C.DB.dev and C.DB.dev.debugMode) then return end

    local name = (type(module) == "table" and module.GetName) and module:GetName() or tostring(module or "CX")
    local msg = ...

    if C.DB.dev.showModuleStatus == false and (msg == C.MODULE_ENABLED or msg == C.MODULE_DISABLED) then
        return
    end

    local filter = C.DB.dev.moduleFilter

    if name == "Cobalt" or (not filter or next(filter) == nil or filter[name]) then
        Log("|cffFF79AC[Cobalt]|r", "00FF00", module, ...)
    end
end

--- Highly robust table printer for WoW 12.0.1
-- @param module The module instance (self) to pass to C:Print
-- @param tbl The table to inspect
-- @param label (Optional) A string to identify this print job
function C:PrintTable(module, tbl, label)
    local header = label and ("[" .. label .. "] ") or ""

    -- 1. Handle nil input
    if tbl == nil then
        C:Print(module, header .. "|cffff0000Error: Input is nil|r")
        return
    end

    -- 2. Handle non-table input (Strings, Numbers, Booleans, etc.)
    if type(tbl) ~= "table" then
        C:Print(module, header .. "Value: " .. tostring(tbl) .. " (|cff808080Type: " .. type(tbl) .. "|r)")
        return
    end

    -- 3. Handle empty table
    if next(tbl) == nil then
        C:Print(module, header .. "{ } |cff808080(Empty Table)|r")
        return
    end

    -- 4. Internal Recursive Processor
    local function dump(t, indent, visited)
        visited = visited or {}
        indent = indent or ""

        -- Prevent infinite recursion (Circular References)
        if visited[t] then
            C:Print(module, indent .. "|cff808080[Circular Reference detected]|r")
            return
        end
        visited[t] = true

        for k, v in pairs(t) do
            local keyStr = "|cff00ccff" .. tostring(k) .. "|r"

            if type(v) == "table" then
                C:Print(module, indent .. keyStr .. " = {")
                dump(v, indent .. "  ", visited)
                C:Print(module, indent .. "}")
            else
                local valStr = tostring(v)
                -- Apply syntax highlighting based on data type
                if type(v) == "string" then
                    valStr = "|cffce9178'" .. valStr .. "'|r"
                elseif type(v) == "number" then
                    valStr = "|cffb5cea8" .. valStr .. "|r"
                elseif type(v) == "boolean" then
                    valStr = "|cff569cd6" .. valStr .. "|r"
                end

                C:Print(module, indent .. keyStr .. " = " .. valStr)
            end
        end
    end

    -- Initial trigger
    C:Print(module, header .. "Dumping Table Contents:")
    dump(tbl, "  ")
end

-- Utility function: returns true if the holiday name is found for today
function C:IsHolidayActive(holidayName)
    local day = tonumber(date("%d")) or 0
    local monthOffset = 0 -- 0 is current month
    local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)

    for i = 1, numEvents do
        -- 1. Check Holiday Info (Standard Holidays)
        local holidayInfo = C_Calendar.GetHolidayInfo(monthOffset, day, i)
        if holidayInfo and holidayInfo.name == holidayName then
            return true
        end

        -- 2. Check Day Event (DMF and recurring events)
        local eventInfo = C_Calendar.GetDayEvent(monthOffset, day, i)
        if eventInfo and eventInfo.title == holidayName then
            return true
        end
    end

    return false
end

function C:CheckAllCalendarEvents()
    local date = C_DateAndTime.GetCurrentCalendarTime()
    C_Calendar.SetAbsMonth(date.month, date.year)

    local numEvents = C_Calendar.GetNumDayEvents(0, date.monthDay)
    for i = 1, numEvents do
        local event = C_Calendar.GetDayEvent(0, date.monthDay, i)
        if event then
            C:Print(self, "Event Name: " .. event.title)
            C:Print(self, "Event ID: " .. event.eventID)
        end
    end
end

function C:CheckCalendarEvent(holidayNameOrID)
    local date = C_DateAndTime.GetCurrentCalendarTime()
    C_Calendar.SetAbsMonth(date.month, date.year)

    -- 2. Determine the type of input once to save processing
    local inputType = type(holidayNameOrID)

    local numEvents = C_Calendar.GetNumDayEvents(0, date.monthDay)
    for i = 1, numEvents do
        local event = C_Calendar.GetDayEvent(0, date.monthDay, i)
        if event then
            if inputType == "string" then
                if event.title == holidayNameOrID then
                    C:Debug(self, "Holiday: " .. event.title)
                    return true, event
                end
            elseif inputType == "number" then
                if event.eventID == holidayNameOrID then
                    C:Debug(self, "Holiday: " .. event.title)
                    return true, event
                end
            end
        end
    end
    C:Debug(self, string.format("(%s) Holiday not found.", holidayNameOrID))
    return false
end

-- Usage: if C:HasRole(C.mynameRealm, role) then ...
function C:HasRole(charKey, roleName)
    local char = self.ROSTER[charKey]
    return char and char.roles and char.roles[roleName] or false
end

function C:SetModuleState(name, state)
    local module = self:GetModule(name)
    if not module then return end

    -- 1. Actual Module State
    if state then
        module:Enable()
    else
        module:Disable()
    end

    -- 2. Persistence (Matches your Init.lua logic)
    self.database.profile.modules = self.database.profile.modules or {}
    self.database.profile.modules[name] = state

    -- 3. Feedback
    C:Debug(self, string.format("Module %s is now %s", name, state and "|cff00ff00Enabled|r" or "|cffff0000Off|r"))
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
--#endregion

function C:OnEnable()
    C:Debug(self, C.MODULE_ENABLED)
end