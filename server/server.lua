local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

--------------------
-- send To Discord
-------------------

local function sendToDiscord(color, name, message, footer, type)
    local embed = {
        {   ['color'] = color,
            ['title'] = '**'.. name ..'**',
            ['description'] = message,
            ['footer'] = {
                ['text'] = footer
            }
        }
    }
    if type == 'wildhorse' then
        PerformHttpRequest(Config['Webhooks']['wildhorse'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif type == 'trader' then
        PerformHttpRequest(Config['Webhooks']['trader'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
end

-------------
-- REWARDS
-------------

RegisterServerEvent('hdrp-sellwildhorse:server:reward')
AddEventHandler('hdrp-sellwildhorse:server:reward', function(rewardmoney, rewarditem)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    if Config.Debug then print('Money    : '..tostring(rewardmoney)) end

    local reward = rewardmoney * Config.SaleMultiplier
    Player.Functions.AddMoney(Config.PaymentType, reward, 'sellvendor-sold')

    if Config.PaymentReward then
        local amount = 1
        Player.Functions.AddItem(rewarditem, amount)

        TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem], 'add')
        TriggerClientEvent('ox_lib:notify', src, {title =  locale('sv_lang_1')..reward, type = 'inform', duration = 5000 })

        local discordMessage = string.format( locale('sv_lang_9')..':** %s\n**'..locale('sv_lang_10')..':** %d\n**'..locale('sv_lang_11')..':** %s %s\n**'..locale('sv_lang_12')..' $:** %.2f x %s \n**'..locale('sv_lang_13')..':** %d x %s**', Player.PlayerData.citizenid, Player.PlayerData.cid, Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname, reward, RSGCore.Shared.Items[Config.PaymentType].label, amount, RSGCore.Shared.Items[rewarditem].label )
        sendToDiscord(16753920,	locale('sv_lang_14'), discordMessage, locale('sv_lang_15'), 'trader')
    else
        TriggerClientEvent('ox_lib:notify', src, {title =  locale('sv_lang_2')..reward, type = 'inform', duration = 5000 })
        local discordMessage = string.format( locale('sv_lang_9')..':** %s\n**'..locale('sv_lang_10')..':** %d\n**'..locale('sv_lang_11')..':** %s %s\n**'..locale('sv_lang_12')..' $:** %.2f x %s**', Player.PlayerData.citizenid, Player.PlayerData.cid, Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname, reward, RSGCore.Shared.Items[Config.PaymentType].label)
        sendToDiscord(16753920,	locale('sv_lang_14'), discordMessage, locale('sv_lang_15'), 'trader')
    end

end)

-----------------------------------------------
-- Mapping of horse model hashes to their names --save to stables
-----------------------------------------------

local horseModels = {
    [1772321403] = 'a_c_donkey_01',
    [-1963397600] = 'A_C_Horse_AmericanPaint_Greyovero',
    [-450053710] = 'A_C_Horse_AmericanPaint_Overo',
    [1792770814] = 'A_C_Horse_AmericanPaint_SplashedWhite',

    -- Add more mappings for other horse models here
}

-------
-- main
-------

RegisterServerEvent('hdrp-wildhorsestable:server:WildHorseStable')
AddEventHandler('hdrp-wildhorsestable:server:WildHorseStable', function(modelHash, horsename, gender)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Define the required job and item
    local requiredJob = Config.requiredJob -- Change this to your desired job name or identifier
    local requiredItem = Config.requiredItem -- Change this to the item name or identifier

    -- Check if the player has the required job 'horsetrainer'
    if Player.PlayerData.job.name ~= requiredJob then
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_3'), type = 'error', duration = 5000 })
        return
    end

    if Player.Functions.RemoveItem(requiredItem, 1) then
        local modelName = horseModels[modelHash]    -- Check if the provided modelHash exists in the mapping table

        if not modelName then
            TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_4'), type = 'error', duration = 5000 })
            return
        end

        -- Function to generate a unique horse ID
        local function GenerateHorseid()
            local seed = tonumber(tostring(os.time()):reverse():sub(1, 6)) -- Get a 6-digit timestamp-based seed
            math.randomseed(seed)
            local randomNum = math.random(10000, 99999)
            return tostring(seed) .. tostring(randomNum)
        end

        local horseid = GenerateHorseid()

        local stableid = {'colter', 'vanhorn', 'saintdenis', 'rhodes', 'valentine', 'strawberry', 'blackwater','tumbleweed'}
        local stable = stableid[math.random(#stableid)]

        MySQL.insert('INSERT INTO player_horses(stable, citizenid, horseid, name, horse, gender, active, wild, born) VALUES(@stable, @citizenid, @horseid, @name, @horse, @gender, @active, @wild, @born)', {
            ['@stable'] = stable,
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@horseid'] = horseid,
            ['@name'] = horsename,
            ['@horse'] = modelName,
            ['@gender'] = gender,
            ['@active'] = false,
            ['@wild'] = true,
            ['@born'] = os.time()
        }, function(inserted)
            if inserted then
                TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_5'), description = stable.. ' '.. horsename, type = 'inform', duration = 5000 })
                sendToDiscord(16753920, locale('sv_lang_16'), locale('sv_lang_9')..':** '..Player.PlayerData.citizenid.. '\n**'..locale('sv_lang_10')..':** '..Player.PlayerData.cid..'\n**'..locale('sv_lang_11')..':** '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname.. '\n**'..locale('sv_lang_18')..': **'.. horseid..'\n**'..locale('sv_lang_19')..': **'..  horseid..' - '..horsename..' - '..modelName..' - '..gender..'**', locale('sv_lang_17'), 'wildhorse')
                TriggerClientEvent('RSGCore:Command:DeleteVehicle', src)    -- Trigger the client event to delete the horse entity

            else
                TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_6'), type = 'error', duration = 5000 })
                -- Add code for handling the case where the horse insertion fails, such as returning the item to the player.
            end
        end)
    else
        TriggerClientEvent('ox_lib:notify', src, {title = locale('sv_lang_7'), type = 'error', duration = 5000 })
    end
end)

----------
-- Debug
----------

if Config.Debug then    -- Debug Command to Set Any Horse as Wild Horse
    RSGCore.Commands.Add('sethorsewild', locale('sv_lang_8'), {}, false, function(source)
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        if not Player then return end
        TriggerClientEvent('hdrp-sellwildhorse:client:SetHorseAsWild', src)
    end, 'admin')
end