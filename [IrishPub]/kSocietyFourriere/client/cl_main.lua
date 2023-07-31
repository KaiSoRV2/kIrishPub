ESX = exports["es_extended"]:getSharedObject()

list_vehicles_fourriere = {}
function GetVehicleSociety(JobPlayer)
    ESX.TriggerServerCallback("kSocietyFourriere:VehiculeOut", function(result)
        list_vehicles_fourriere = result 
    end, JobPlayer)
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Ped.Positions) do 
        blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
        SetBlipSprite(blip, Config.Blips.Type)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blips.Size)
        SetBlipColour(blip, Config.Blips.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Blips.Title)
        EndTextCommandSetBlipName(blip)
    end

    for k, v in pairs(Config.Ped.Positions) do
        while not HasModelLoaded(Config.Ped.hash) do
            RequestModel(Config.Ped.hash)
            Wait(1)
        end

        Ped = CreatePed(2, GetHashKey(Config.Ped.hash), v.pos.x, v.pos.y, v.pos.z-0.99, v.pos.w, 0, 0)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)

        exports.ox_target:addBoxZone({
            coords = vec3(v.pos.x, v.pos.y, v.pos.z),
            size = vec3(1, 1.5, 1.5),
            rotation = 60,
            debug = false,
            options = {
                {
                    name = 'Ped',
                    event = 'GestionVF',
                    icon = 'fa-solid fa-car',
                    label = 'Véhicules en Fourrière',  
                },
            }
        })

    end 
end)


AddEventHandler('GestionVF', function() 
    local JobPlayer = ESX.PlayerData.job.name
    GetVehicleSociety(JobPlayer)
    Wait(500)

    if #list_vehicles_fourriere ~= 0 then 
        GestionVehiculesFourriere(list_vehicles_fourriere)
    else 
        lib.notify({
            id = 'NoVeh',
            title = 'Fourrière',
            description = 'Il n\'y aucun véhicule en Fourrière !',
            duration = 5000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = '#eb9534'
                }
            },
            icon = 'fa-solid fa-triangle-exclamation',
            iconColor = '#eb9534'
        })
    end 
end)

function GestionVehiculesFourriere(list_vehicles_fourriere)

    local plyCoords = GetEntityCoords(PlayerPedId())
    DistGive = 100000
    IdGive = 1

    for k, v in pairs(Config.Ped.Positions) do 
        dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z-0.99)
        if dist < DistGive then 
            DistGive = dist 
            IdGive = v.id
        end
    end

    options = {}

    for k , v in pairs(list_vehicles_fourriere) do
        option = {
            title = v.label..' n°'..v.plate,
            icon = 'fa-solid fa-car',
            arrow = true,
            onSelect = function()
                SpawnVehicule(json.decode(v.vehicle).model, v.plate, v.label, json.decode(v.vehicle), IdGive)
            end,
        }
        table.insert(options, option)
    end 

    lib.registerContext({
        id = 'veh_fou',
        title = "Véhicules en Fourrière",
        options = options
    })

    lib.showContext('veh_fou')
end

function SpawnVehicule(model, plate, label, properties, IdGive)

    local VehMaps = ESX.Game.GetVehicles()

    for k , v in pairs(VehMaps) do
        if GetVehicleNumberPlateText(v) == plate then 
            properties = ESX.Game.GetVehicleProperties(v)
            ESX.Game.DeleteVehicle(v)
        end 
    end 

    SpawnPosition = nil
    SpawnHeading = nil

    for k, v in pairs(Config.SpawnPositions) do
        SpawnPositionTemp = vector3(v.pos.x, v.pos.y, v.pos.z)
        if (v.id == IdGive) and ESX.Game.IsSpawnPointClear(SpawnPositionTemp, 5.0) then
            SpawnPosition = vector3(v.pos.x, v.pos.y, v.pos.z)
            SpawnHeading = v.pos.w
            break
        end 
    end 

    if SpawnPosition == nil and SpawnHeading == nil then 
        lib.notify({
            id = 'NoPos',
            title = 'Fourrière',
            description = 'Il n\'y a aucune place de libre pour sortir votre véhicule !',
            duration = 5000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = '#eb9534'
                }
            },
            icon = 'fa-solid fa-triangle-exclamation',
            iconColor = '#eb9534'
        })

    else 

        if not IsModelInCdimage(model) then 
            return
        end

        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(10)
        end

        local car = CreateVehicle(model, SpawnPosition, SpawnHeading, true, false)
        ESX.Game.SetVehicleProperties(car, properties)
        SetVehicleNumberPlateText(car, plate)
        SetPedIntoVehicle(PlayerPedId(), car, -1)
        TriggerServerEvent("kSocietyFourriere:SortieFourriere", label, plate, 1, ESX.Game.GetVehicleProperties(car))
        FreezeEntityPosition(PlayerPedId(), false)
    end
end
