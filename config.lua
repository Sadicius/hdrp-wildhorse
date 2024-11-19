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
    {
	name = locale('cf_lang_1'),
	location = 'rodeo-sellwildhorse',
	coords = vector3(1405.91, 244.23, 89.77),
	npcmodel = `a_m_m_rhdforeman_01`,
	npccoords = vector4(1405.91, 244.23, 89.77, 160.27),
	blipsprite = 'blip_shop_horse_fencing',
	blipscale = 0.2,
	showblip = true
    },
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
