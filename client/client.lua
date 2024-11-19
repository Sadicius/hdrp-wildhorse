local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()
local createdEntries = {}
local selling = false
local cooldown = false
local cooldowntimer = 0
local gender = nil
local namehorse =  nil

-- delete entity
local DeleteThis = function(horse)
    NetworkRequestControlOfEntity(horse)
    SetEntityAsMissionEntity(riding, true, true)
    Wait(100)
    DeleteEntity(horse)
    Wait(500)

    local ped = PlayerPedId()
    local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
    local ridingcheck = GetPedType(entitycheck)

    if ridingcheck == 0 then return true end

    return false
end

-- prompts and blips
CreateThread(function()
    for _, v in pairs(Config.SellWildHorseLocations) do
        if not Config.UseTarget then
            exports['rsg-core']:createPrompt(v.location, v.coords, RSGCore.Shared.Keybinds[Config.KeyShop], v.name, {
                type = 'client',
                event = 'hdrp-sellwildhorse:client:menu',
                args = { v.location },
            })
        end
        if v.showblip == true then
            local SellWildHorseBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(SellWildHorseBlip, joaat(v.blipsprite), true)
            SetBlipScale(SellWildHorseBlip, v.blipscale)
            SetBlipName(SellWildHorseBlip, v.name)
        end
    end
end)

-- sell wild horse menu
RegisterNetEvent('hdrp-sellwildhorse:client:menu', function(nameMenu)
    if selling then return end

    if Config.EnableCooldown and cooldowntimer > 0 then
        local time = locale('cl_lang_1_a')
        local timer = cooldowntimer
        if cooldowntimer > 60 then
            timer = math.floor(cooldowntimer / 60)
            time = locale('cl_lang_1_b')
        end
        lib.notify({ title = locale('cl_lang_1'), description = locale('cl_lang_2')..timer..' '..time..locale('cl_lang_3'), type = 'inform', duration = 5000  })
        return
    end

    lib.registerContext(
        {   id = 'sellhorse_menu',
            title = nameMenu,
            position = 'top-right',
            options = {
                {   title = locale('cl_lang_4'),
                    description = locale('cl_lang_5'),
                    icon = 'fas fa-horse',
                    event = 'hdrp-sellwildhorse:client:sellhorse',
                },
                {   title = locale('cl_lang_6'),
                    description = locale('cl_lang_7'),
                    icon = 'fas fa-horse',
                    iconColor = "yellow",
                    event = 'hdrp-wildhorsestable:client:wildhorsestable',
                },
            }
        }
    )
    lib.showContext('sellhorse_menu')
end)

-- sell horse event
AddEventHandler('hdrp-sellwildhorse:client:sellhorse', function()
    local horse = Citizen.InvokeNative(0xE7E11B8DCBED1058, cache.ped)
    local myhorse = exports['rsg-horses']:CheckActiveHorse()
    local model = GetEntityModel(horse)
    local owner = Citizen.InvokeNative(0xF103823FFE72BB49, horse)
    selling = true

    if Config.Debug then print(locale('cl_lang_8_a')..": "..tostring(cache.ped)) print(locale('cl_lang_8_b')..": "..tostring(horse)) print(locale('cl_lang_8_c')..": "..tostring(model)) print(locale('cl_lang_8_d')..": "..tostring(owner)) end

    if not horse or horse == 0 then
        lib.notify({ title = locale('cl_lang_8'), description = locale('cl_lang_9'), type = 'error', duration = 5000  })
        Wait(3000)
        selling = false
        return
    end

    if not owner or owner ~= cache.ped then
        lib.notify({ title = locale('cl_lang_10'), description = locale('cl_lang_11'), type = 'error', duration = 5000  })
        Wait(3000)
        selling = false
        return
    end

    if myhorse and myhorse ~= 0 then
        lib.notify({ title = locale('cl_lang_12'), description = locale('cl_lang_13'), type = 'error', duration = 5000  })
        Wait(3000)
        selling = false
        return
    end

    for i = 1, #Config.Horse do
        local horses = Config.Horse[i]
        local models = horses.model

        if model == models then
            local name = horses.name
            local rewardmoney = horses.rewardmoney
            local rewarditem = horses.rewarditem

            if Config.Debug then print(locale('cl_lang_8_c')..": "..tostring(model)) print(locale('cl_lang_8_e')..": "..tostring(rewardmoney)) print(locale('cl_lang_8_f').." : "..tostring(rewarditem)) end

            if lib.progressBar({
                duration = Config.SellTime,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disableControl = true,
                disable = {
                    move = true,
                    mouse = true,
                },
                label = locale('cl_lang_14')..name,
            }) then

                local deleted = DeleteThis(horse)
                if deleted then
                    TriggerServerEvent('hdrp-sellwildhorse:server:reward', rewardmoney, rewarditem)
                    Wait(3000)
                    selling = false
                    if Config.EnableCooldown then
                        TriggerEvent('hdrp-sellwildhorse:client:Cooldown')
                    end
                    return
                end

            end
        end
    end
    selling = false
end)

AddEventHandler('hdrp-sellwildhorse:client:Cooldown', function()
    if cooldown then return end
    CreateThread(function()
        cooldowntimer = Config.Cooldown
        cooldown = true
        while true do
            Wait(1000)
            cooldowntimer = cooldowntimer - 1
            if cooldowntimer <= 0 then
                cooldowntimer = 0
                cooldown = false
                return
            end
        end
    end)
end)

if Config.Debug then
    RegisterNetEvent('hdrp-sellwildhorse:client:SetHorseAsWild')
    AddEventHandler('hdrp-sellwildhorse:client:SetHorseAsWild', function()
        local mount = GetMount(cache.ped)
        if mount then
            Citizen.InvokeNative(0xAEB97D84CDF3C00B, mount, true)
        end
    end)
end

-----------------------------
-- save wild horse to stables
-----------------------------
function CheckIfHorseIsWildAndUntamed(model) -- Function to check if the horse is wild and untamed
    -- Add your logic here to check if the horse is wild and untamed (e.g., check horse attributes)
    return true -- Return true if wild and untamed, false if not
end

--------------------------------------
-- save wild horse event (client-side)
--------------------------------------

AddEventHandler('hdrp-wildhorsestable:client:wildhorsestable', function()
    local horse = Citizen.InvokeNative(0xE7E11B8DCBED1058, cache.ped)
    local myhorse = exports['rsg-horses']:CheckActiveHorse()
    local model = GetEntityModel(horse)
    local owner = Citizen.InvokeNative(0xF103823FFE72BB49, horse)
    local hasItem = RSGCore.Functions.HasItem('saddlebag', 1)

    if Config.Debug then print(locale('cl_lang_8_a')..": "..tostring(cache.ped)) print(locale('cl_lang_8_b')..": "..tostring(horse)) print(locale('cl_lang_8_c')..": "..tostring(model)) print(locale('cl_lang_8_d')..": "..tostring(owner)) end

    if not hasItem then
        lib.notify({ title = locale('cl_lang_15'), description = locale('cl_lang_16'), type = 'error', duration = 5000  })
        Wait(3000)
        return
    end

    if not horse or horse == 0 then
        lib.notify({ title = locale('cl_lang_15'), description = locale('cl_lang_16'), type = 'error', duration = 5000  })
        Wait(3000)
        return
    end

    if not owner or owner ~= cache.ped then
        lib.notify({ title = locale('cl_lang_17'), description = locale('cl_lang_18'), type = 'error', duration = 5000  })
        Wait(3000)
        return
    end

    if myhorse and myhorse ~= 0 then
        lib.notify({ title = locale('cl_lang_19'), description = locale('cl_lang_20'), type = 'error', duration = 5000  })
        Wait(3000)
        return
    end

    for i = 1, #Config.Horse do
        local horses = Config.Horse[i]
        if horse.model == model then
            namehorse = horses.name
        end
    end

    lib.progressBar({
        duration = Config.SellTime,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disableControl = true,
        disable = {
            move = true,
            mouse = true,
        },
        label = locale('cl_lang_14')..namehorse,
    })

    if not CheckIfHorseIsWildAndUntamed(model) then    -- Check if the horse is wild and untamed before saving
        lib.notify({ title = locale('cl_lang_21'), description = locale('cl_lang_22'), type = 'error', duration = 5000  })
        Wait(3000)
        return
    end

    local horsegender = IsPedMale(horse)    -- get horse gender
    if horsegender == 1 then
        gender = 'male'
    else
        gender = 'female'
    end

    TriggerEvent('hdrp-wildhorse:client:setname', model, gender)
end)

RegisterNetEvent('hdrp-wildhorse:client:setname', function(model, genderA)
    local input = lib.inputDialog(locale('cl_lang_23'), {
        {   label = locale('cl_lang_24'),
            type = 'input',
            required = true,
        },
    })
    if not input then return end
    TriggerServerEvent('hdrp-wildhorsestable:server:WildHorseStable', model, input[1], genderA)
end)

------------
-- cleanup
------------

AddEventHandler('onResourceStop', function(resourceName)
    local r = GetCurrentResourceName()
    if r ~= resourceName then return end
    FreezeEntityPosition(PlayerPedId(), false)

    for i = 1, #createdEntries do
        if createdEntries[i].type == 'PROMPT' then
            if createdEntries[i].handle then
                exports['rsg-core']:deletePrompt(createdEntries[i].handle)
            end
        end
    end
end)