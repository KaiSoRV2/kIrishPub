ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()

    while not HasModelLoaded(Config.PedGarage.hash) do
        RequestModel(Config.PedGarage.hash)
        Wait(1)
    end

    Ped = CreatePed(2, GetHashKey(Config.PedGarage.hash), Config.PedGarage.Pos.x, Config.PedGarage.Pos.y, Config.PedGarage.Pos.z-0.99, Config.PedGarage.Pos.w, 0, 0)
    FreezeEntityPosition(Ped, true)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, true)

    exports.ox_target:addBoxZone({
        coords = vec3(Config.PedGarage.Pos.x, Config.PedGarage.Pos.y, Config.PedGarage.Pos.z),
        size = vec3(1, 1, 1.5),
        rotation = 60,
        debug = false,
        options = {
            {
                name = 'PedGarageIrish',
                groups = Config.NameJob,
                event = 'OGSI',
                icon = 'fa-solid fa-car',
                label = 'Véhicules de Société',  
            },
        }
    })
end)

AddEventHandler('OGSI', function()  
    GetVehicleSocietyDispo()
    Wait(1000)
    GarageIrishPub()
end)
 

list_vehicles_dispo = {}
function GetVehicleSocietyDispo()
    ESX.TriggerServerCallback("kIrishPub:VehiculeSocietyDispo", function(result)
        list_vehicles_dispo = result 
    end)
end

function GarageIrishPub()

    options = {}

    if #list_vehicles_dispo > 0 then
        for k, v in pairs(list_vehicles_dispo) do
            option = {
                title = v.label..' n°'..v.plate,
                icon = 'fa-solid fa-car',
                arrow = true,
                onSelect = function()
                    if v.pos == nil then 
                        SpawnVehicleGarage(nil, nil, json.decode(v.vehicle).model, v.plate, json.decode(v.vehicle))
                    else 
                        Pos = json.decode(v.pos)
                        PosSpawn = vector3(Pos.x, Pos.y, Pos.z)
                        PosHeading = Pos.w 
                        SpawnVehicleGarage(PosSpawn, PosHeading, json.decode(v.vehicle).model, v.plate, json.decode(v.vehicle))
                    end
                end,
            }
            table.insert(options, option)
        end 

        lib.registerContext({
            id = 'Veh_GarDispo_IRISH',
            title = "Véhicules Disponibles",
            options = options
        })

        lib.showContext('Veh_GarDispo_IRISH')

    else 
        lib.notify({
            id = 'NVE',
            title = 'Irish Pub',
            description = 'Il n\'y a aucun véhicule dans le garage !',
            duration = 6000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = '#eb9534',
                }
            },
            icon = 'fa-solid fa-triangle-exclamation',
            iconColor = '#eb9534'
        })
    end
end

function SpawnVehicleGarage(PosSpawn, PosHeading, ModelVeh, Plate, Properties)

    SpawnVehiculeNotSave = vector3(825.77, -88.32, 80.48)
    HeadingVehiculeNotSave = 234.52

    if PosSpawn == nil and ESX.Game.IsSpawnPointClear(SpawnVehiculeNotSave, 5.0) then 

        local VehMaps = ESX.Game.GetVehicles()

        for k , v in pairs(VehMaps) do
            if GetVehicleNumberPlateText(v) == Plate then 
                Properties = ESX.Game.GetVehicleProperties(v)
                ESX.Game.DeleteVehicle(v)
            end 
        end 


        if not IsModelInCdimage(ModelVeh) then 
            return
        end

        RequestModel(ModelVeh)

        while not HasModelLoaded(ModelVeh) do
            Citizen.Wait(10)
        end

        local car = CreateVehicle(ModelVeh, SpawnVehiculeNotSave, HeadingVehiculeNotSave, true, false)
        ESX.Game.SetVehicleProperties(car, Properties)
        SetVehicleNumberPlateText(car, Plate)
        SetPedIntoVehicle(PlayerPedId(), car, -1)
        TriggerServerEvent("kIrishPub:SaveStatsSortie", Plate, 0, ESX.Game.GetVehicleProperties(car))
        FreezeEntityPosition(PlayerPedId(), false)

    elseif PosSpawn == nil and not ESX.Game.IsSpawnPointClear(SpawnVehiculeNotSave, 5.0) then 
        lib.notify({
            id = 'NEP1',
            title = 'Irish Pub',
            description = 'Il n\'y a pas assez de place pour sortir le véhicule !',
            duration = 6000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = 'red',
                }
            },
            icon = 'fa-solid fa-martini-glass-citrus',
            iconColor = '#2a8743'
        })
    
    elseif PosSpawn ~= nil and not ESX.Game.IsSpawnPointClear(PosSpawn, 5.0) then
        lib.notify({
            id = 'NEP2',
            title = 'Irish Pub',
            description = 'Il n\'y a pas assez de place pour sortir le véhicule !',
            duration = 6000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = 'red',
                }
            },
            icon = 'fa-solid fa-martini-glass-citrus',
            iconColor = '#2a8743'
        })

    else 

        local VehMaps = ESX.Game.GetVehicles()

        for k , v in pairs(VehMaps) do
            if GetVehicleNumberPlateText(v) == Plate then 
                Properties = ESX.Game.GetVehicleProperties(v)
                ESX.Game.DeleteVehicle(v)
            end 
        end 

        if not IsModelInCdimage(ModelVeh) then 
            return
        end

        RequestModel(ModelVeh)

        while not HasModelLoaded(ModelVeh) do
            Citizen.Wait(10)
        end

        local car = CreateVehicle(ModelVeh, PosSpawn, PosHeading, true, false)
        ESX.Game.SetVehicleProperties(car, Properties)
        SetVehicleNumberPlateText(car, Plate)
        SetPedIntoVehicle(PlayerPedId(), car, -1)
        TriggerServerEvent("kIrishPub:SaveStatsSortie", GetVehicleNumberPlateText(car), 0, ESX.Game.GetVehicleProperties(car))
        FreezeEntityPosition(PlayerPedId(), false)
    end 

end
