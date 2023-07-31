ESX = exports["es_extended"]:getSharedObject()

list_vehicles = {}
function GetVehicleSociety()
    ESX.TriggerServerCallback("kIrishPub:VehiculeSociety", function(result)
        list_vehicles = result 
    end)
end

RegisterNetEvent('VenteVehIrish', function(args)
    lib.registerContext({
        id = 'VenteVehIrish',
        menu = 'Veh_Gar_IRISH',
        title = "Vente du Véhicule", 
        options = {
            {
            title = "Confirmer la vente",
            arrow = true,
            onSelect = function()
                TriggerServerEvent('kIrishPub:VenteVehicule', args.Value)
            end
            },
            {
                title = "Annuler la vente",
                arrow = true,
                onSelect = function()
                    lib.hideContext('VenteVehIrish')
                end
            },
        }
    })

    lib.showContext('VenteVehIrish')
end)

function GestionDesVehicules()

    options = {}

    if #list_vehicles > 0 then
        for k, v in pairs(list_vehicles) do
            infos_vehicule = {}
            if v.stored == 1 then 
                table.insert(infos_vehicule, {society = v.society, plate = v.plate, vehicle = v.vehicle, label = v.label, stored = v.stored, pos = v.lieu}) 
                option = {
                    title = v.label..' n°'..v.plate,
                    icon = 'fa-solid fa-car',
                    arrow = true,
                    event = 'VenteVehIrish',
                    args = {
                        Value = infos_vehicule
                    }
                }
                table.insert(options, option)
            else 
                option = {
                    title = v.label..' n°'..v.plate,
                    icon = 'fa-solid fa-lock',
                    description = 'Véhicule Sortie',
                    disabled = true,
                }
                table.insert(options, option)
            end
        end 

        lib.registerContext({
            id = 'Veh_Gar_IRISH',
            title = "Véhicules Disponibles",  
            options = options
        })

        lib.showContext('Veh_Gar_IRISH')

    else 
        lib.notify({
            id = 'NVE',
            title = 'Irish Pub',
            description = 'Vous n\'avez aucun véhicule de société !',
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

function AchatsDesVehicules()
    SpawnTemporyBuyVehicle = vector3(135.44, -622.44, 262.85) -- Ne pas toucher
    options = {}

    for k, v in pairs(Config.VehiculeIrishPub) do
        option = {
            title = v.label,
            description = ESX.Math.GroupDigits(v.price).."$",
            icon = 'fa-solid fa-sack-dollar',
            arrow = true,
            onSelect = function()
                SpawnVehicule(v.name, v.label, SpawnTemporyBuyVehicle, Config.Positions.Heading, v.price)  
            end,
        }
        table.insert(options, option)
    end 

    lib.registerContext({
        id = 'Veh_Achats_IRISH',
        title = "Achats Disponibles",  
        canClose = true,
        options = options
    })

    lib.showContext('Veh_Achats_IRISH')

end 


function SpawnVehicule(car, label, car_spawn, car_heading, price)

    RequestModel(car)
    while not HasModelLoaded(car) do
        Wait(1)
    end 

    veh = CreateVehicle(car, car_spawn, car_heading, true, false)
    veh_plate = 'IRISH'..math.random(100,999)
    SetVehicleNumberPlateText(veh, veh_plate)

    TriggerServerEvent('kIrishPub:AchatsVehiculeSociety', label, price, ESX.Game.GetVehicleProperties(veh), veh_plate)
    DeleteEntity(veh)
end

AddEventHandler('GestionV', function() 
    GetVehicleSociety()
    Wait(500)
    GestionDesVehicules()
end)

AddEventHandler('AchatsV', function()
    AchatsDesVehicules()
end)

AddEventHandler('GestionE', function()
    TriggerEvent('esx_society:openBossMenu', 'irishpub', function(data, menu)
        menu.close()
    end, {wash = false})
end)

AddEventHandler('Commander', function()
    lib.showContext('Livraison')
    
end)

AddEventHandler('ArgentSociety', function()
    TriggerServerEvent('kIrishPub:ArgentSociety')
end)

lib.registerContext({
    id = 'Livraison',
    title = 'Livraison',
    options = {
        {            
            title  = 'Boisson',
            icon = 'fa-wine-bottle',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                LivraisonBoisson()
            end
        },
    }
})

Citizen.CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.Positions.Boss,
        size = vec3(1, 1.5, 1.5),
        rotation = 60,
        debug = false,
        options = {
            {
                groups = {[Config.NameJob] = 4},
                name = 'Ordinateur',
                event = 'GestionV',
                icon = 'fa-solid fa-car',
                label = 'Gestion des Véhicules',  
            },
            {
                groups = {[Config.NameJob] = 4},
                name = 'Ordinateur',
                event = 'AchatsV',
                icon = 'fa-solid fa-truck-fast',
                label = 'Achats des Véhicules',
            },
            {
                groups = {[Config.NameJob] = 4},
                name = 'Ordinateur',
                event = 'GestionE',
                icon = 'fa-solid fa-users',
                label = 'Gestion de l\'Entreprise',
            },
            {
                groups = {[Config.NameJob] = 4},
                name = 'Ordinateur',
                event = 'Commander',
                icon = 'fa-solid fa-cart-plus',
                label = 'Passer une Commande',
            },
            {
                groups = {[Config.NameJob] = 4},
                name = 'Ordinateur',
                event = 'ArgentSociety',
                icon = 'fa-solid fa-landmark',
                label = 'Argent Société',
            },
        }
    })
end)
