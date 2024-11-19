local spawnedPeds = {}

local function NearNPC(npcmodel, npccoords, heading)
    local spawnedPed = CreatePed(npcmodel, npccoords.x, npccoords.y, npccoords.z - 1.0, heading, false, false, 0, 0)
    SetEntityAlpha(spawnedPed, 0, false)
    SetRandomOutfitVariation(spawnedPed, true)
    SetEntityCanBeDamaged(spawnedPed, false)
    SetEntityInvincible(spawnedPed, true)
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    -- set relationship group between npc and player
    SetPedRelationshipGroupHash(spawnedPed, GetPedRelationshipGroupHash(spawnedPed))
    SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(spawnedPed), `PLAYER`)

    if Config.FadeIn then
        for i = 0, 255, 51 do
            Wait(50)
            SetEntityAlpha(spawnedPed, i, false)
        end
    end

    return spawnedPed
end

CreateThread(function()
    for k, v in pairs(Config.SellWildHorseLocations) do
        local coords = v.npccoords
        local newpoint = lib.points.new({
            coords = coords,
            heading = coords.w,
            distance = Config.DistanceSpawn,
            model = v.npcmodel,
            ped = nil,
            name = v.name,
            location = v.location,
            targetOptions = {
                {
                    name = 'npc_wild_horse',
                    icon = 'far fa-eye',
                    targeticon = 'fa-solid fa-eye',
                    label = v.name,
                    onSelect = function()
                        TriggerEvent('hdrp-sellwildhorse:client:menu', v.location)
                    end,
                    canInteract = function(_, distance)
                        return distance < 4.0
                    end
                }
            }
        })

        newpoint.onEnter = function(self)
            if not self.ped then
                lib.requestModel(self.model, 10000)
                self.ped = NearNPC(self.model, self.coords, self.heading)

                pcall(function ()
                    if Config.UseTarget == true then
                        exports.ox_target:addLocalEntity(self.ped, self.targetOptions)
                    end
                end)
            end
        end

        newpoint.onExit = function(self)
            exports.ox_target:removeLocalEntity(self.ped, 'npc_wild_horse')
            if self.ped and DoesEntityExist(self.ped) then
                if Config.FadeIn then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(self.ped, i, false)
                    end
                end
                DeleteEntity(self.ped)
                self.ped = nil
            end
        end

        spawnedPeds[k] = newpoint
    end
end)

-- cleanup
AddEventHandler("onResourceStop", function(resourceName)
    local r = GetCurrentResourceName()
    if r ~= resourceName then return end
    for k, v in pairs(spawnedPeds) do
        exports.ox_target:removeLocalEntity(v.ped, 'npc_wild_horse')
        if v.ped and DoesEntityExist(v.ped) then
            DeleteEntity(v.ped)
        end

        spawnedPeds[k] = nil
    end
end)