Config = {}
lib.locale()

Config.Debug = false

--------------
-- SETTINGS
--------------

Config.KeyShop          = 'J'
Config.UseTarget	    = true -- 'true' or 'false'
Config.requiredJob      = "" -- horse_trainer
Config.requiredItem     = "saddlebag"
Config.PaymentType      = 'cash' -- Payment = money you can select 'cash' or 'bloodmoney' / Payment = item you can select 'cash' or 'bloodmoney'
Config.PaymentReward    = true -- on/off rewards extra item for horse
Config.EnableCooldown   = true
Config.Cooldown         = 900 -- 15 mins cooldown by default
Config.SellTime         = 20000

Config.FadeIn           = true -- 'true' or 'false' npc Fade In
Config.DistanceSpawn    = 20 -- number distance npc

-------------------
-- SELL 
------------------

Config.SaleMultiplier = 1

Config.SellWildHorseLocations = {
    {name = locale('cf_lang_1'),  location = 'rodeo-sellwildhorse',         coords = vector3(1405.91, 244.23, 89.77),    npcmodel = `a_m_m_rhdforeman_01`,    npccoords = vector4(1405.91, 244.23, 89.77, 160.27),    blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, --
    {name = locale('cf_lang_2'),  location = 'stdenis-sellwildhorse',       coords = vector3(-1829.47, -590.66, 155.13),  npcmodel = `a_m_m_rhdtownfolk_01`,   npccoords = vector4(-1829.47, -590.66, 155.13, 300.05),  blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, --
    {name = locale('cf_lang_3'),  location = 'westelizabeth-sellwildhorse', coords = vector3(-862.87, -1402.82, 43.48),   npcmodel = `u_m_m_bwmstablehand_01`, npccoords = vector4(-862.87, -1402.82, 43.48, 300.05),   blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, --
    {name = locale('cf_lang_4'),  location = 'stawberry-sellwildhorse',     coords = vector3(2970.63, 1429.33, 43.72),    npcmodel = `a_m_m_rhdforeman_01`,    npccoords = vector4(2970.63, 1429.33, 43.72, 300.05),    blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = true}, --
    {name = locale('cf_lang_5'),  location = 'tumbleweed-sellwildhorse',    coords = vector3(1217.66, -200.20, 101.33),   npcmodel = `a_m_m_rhdtownfolk_01`,   npccoords = vector4(1217.66, -200.20, 101.33, 300.05),   blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, --
    {name = locale('cf_lang_6'),  location = 'blackwater-sellwildhorse',    coords = vector3(2379.24, -1280.15, 45.69),   npcmodel = `u_m_m_bwmstablehand_01`, npccoords = vector4(2379.24, -1280.15, 45.69, 300.05),   blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, --
    {name = locale('cf_lang_7'),  location = 'rhodes-sellwildhorse',        coords = vector3(1434.89, -1291.61, 77.82),   npcmodel = `a_m_m_rhdforeman_01`,    npccoords = vector4(1434.89, -1291.61, 77.82, 300.05),   blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = true}, -- rhodes
    {name = locale('cf_lang_8'),  location = 'vanhorn-sellwildhorse',       coords = vector3(1582.18, 2195.63, 323.92),   npcmodel = `a_m_m_rhdtownfolk_01`,   npccoords = vector4(1582.18, 2195.63, 323.92, 300.05),   blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, --
    {name = locale('cf_lang_9'),  location = 'rhodes2-sellwildhorse',       coords = vector3(-1305.70, 2478.05, 310.02),  npcmodel = `a_m_o_waptownfolk_01`,   npccoords = vector4(-1305.70, 2478.05, 310.02, 300.05),  blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, --
    {name = locale('cf_lang_10'), location = 'vanhorn2-sellwildhorse',      coords = vector3(-3699.75, -2568.12, -13.68), npcmodel = `u_m_m_bwmstablehand_01`, npccoords = vector4(-3699.75, -2568.12, -13.68, 300.05), blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = true}, --
    {name = locale('cf_lang_11'), location = 'armadillo-sellwildhorse',     coords = vector3(-3699.63, -2568.44, -13.65), npcmodel = `a_m_m_rhdforeman_01`,    npccoords = vector4(-3699.63, -2568.44, -13.65, 300.05), blipsprite = 'blip_shop_horse_fencing', blipscale = 0.2, showblip = false}, -- armadillo
}

-------------------
-- SAVE STABLE
------------------

Config.Horse = { -- reward item false or 'itemname'
    {
        name        = 'Donkey',
        model       = `A_C_Donkey_01`,
        rewardmoney = math.random(15, 30),
        rewarditem  = 'consumable_water_filtered'
    },
    {
        name        = 'Greyovero',
        model       = `A_C_Horse_AmericanPaint_Greyovero`,
        rewardmoney = math.random(15, 30),
        rewarditem  = 'consumable_water_filtered'
    },
    {
        name        = 'Overo',
        model       = `A_C_Horse_AmericanPaint_Overo`,
        rewardmoney = math.random(15, 30),
        rewarditem  = 'consumable_water_filtered'
    },
    {
        name        = 'SplashedWhite',
        model       = `A_C_Horse_AmericanPaint_SplashedWhite`,
        rewardmoney = math.random(15, 30),
        rewarditem  = 'consumable_water_filtered'
    },
}

Config.HorseModels = { -- mapping of horse model hashes to their names
    [1772321403] = 'a_c_donkey_01',
    [1792770814] = 'A_C_Horse_AmericanPaint_SplashedWhite',
    [-450053710] = 'A_C_Horse_AmericanPaint_Overo',
    [-1963397600] = 'A_C_Horse_AmericanPaint_Greyovero',
    -- Add more mappings for other horse models here
}

-------------------------
-- EXTRA Webhooks / RANKING
-----------------------

Config.Webhooks = {
	["wildhorse"] = "https://discord.com/api/webhooks/1248940878056394823/f_lq_PeslXPN0_k4ooRB0UJJNEdgpqCz04y911SfpOzfeciEh_rvKEt6TVxHishQbTa7",
    ["trader"] = "https://discord.com/api/webhooks/1248299675400929290/sHnbVwQMuInW1YqyA2U_2KJKKKZCbostdPjAssvX8nl2DTZ_Hz5y8DEJZwGSTpquEcvU",
}