ESX = exports["es_extended"]:getSharedObject()

local CompteurMission = true

function LivraisonBoisson()
    ESX.TriggerServerCallback("kIrishPub:CheckMoney", function(SocietyHasEnoughMoney, PriceLivraison, societyAccount)
        if CompteurMission then
            if SocietyHasEnoughMoney then
                CompteurMission = false
                SpawnPedLivraison() 
            else 
                lib.notify({
                    id = 'NM',
                    title = 'Irish Pub',
                    description = 'La société n\'a pas assez d\'argent !',
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
            end
        else 
            lib.notify({
                id = 'CMF',
                title = 'Irish Pub',
                description = 'Une livraison est déjà en cours !',
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
        end
    end, Config.PriceLivraison)
end 

function SpawnPedLivraison() 

    CheckLivraison = 0
    local TypeVehiculeLivraison = GetHashKey("boxville4")  

	RequestModel(TypeVehiculeLivraison)
	while not HasModelLoaded(TypeVehiculeLivraison) do
		Wait(1)
	end
	RequestModel('s_m_m_gardener_01')
	while not HasModelLoaded('s_m_m_gardener_01') do
		Wait(1)
	end 

    SpawnVehiculePed = vector3(Config.SpawnLivraison.x, Config.SpawnLivraison.y, Config.SpawnLivraison.z)

    VehiculeLivraison = CreateVehicle(TypeVehiculeLivraison, SpawnVehiculePed, Config.SpawnLivraison.w, true, false)                        
    ClearAreaOfVehicles(GetEntityCoords(VehiculeLivraison), 5000, false, false, false, false, false);  
    SetVehicleOnGroundProperly(VehiculeLivraison)
	SetVehicleNumberPlateText(VehiculeLivraison, "Post OP")
	SetEntityAsMissionEntity(VehiculeLivraison, true, true)
	SetVehicleEngineOn(VehiculeLivraison, true, true, false)
    SetVehicleDoorsLockedForAllPlayers(VehiculeLivraison, true)
        
    PedInVehicle = CreatePedInsideVehicle(VehiculeLivraison, 26, GetHashKey('s_m_m_gardener_01'), -1, true, false)    
    SetEntityInvincible(PedInVehicle, true)
    SetBlockingOfNonTemporaryEvents(PedInVehicle, 1)          	
        
    BlipVehiculeLivraison = AddBlipForEntity(VehiculeLivraison)                                                        	
    SetBlipFlashes(BlipVehiculeLivraison, true)  
    SetBlipColour(BlipVehiculeLivraison, 5)

    TaskVehicleDriveToCoord(PedInVehicle, VehiculeLivraison, Config.PointLivraison.x, Config.PointLivraison.y, Config.PointLivraison.z, 7.5, 0, GetEntityModel(VehiculeLivraison), 63, 2.0)	
    Wait(5000)
    lib.notify({
        id = 'LEC',
        title = 'Post OP',
        description = 'Votre livraison est en cours d\'expédition !',
        duration = 6000,
        position = 'center-left',
        style = {
            ['.description'] = {
                color = '#c98a2a',
            }
        },
        icon = 'fa-solid fa-truck-ramp-box',
        iconColor = '#c98a2a'
    }) 
    CheckLivraison = 1
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)    

        local CoordsPed = GetEntityCoords(PedInVehicle)
        local plyCoords = GetEntityCoords(PlayerPedId())

        local dist0 = Vdist(CoordsPed.x, CoordsPed.y, CoordsPed.z, Config.PointLivraison.x, Config.PointLivraison.y, Config.PointLivraison.z)
        local dist1 = Vdist(CoordsPed.x, CoordsPed.y, CoordsPed.z, Config.LivraisonPorteVehicule.x, Config.LivraisonPorteVehicule.y, Config.LivraisonPorteVehicule.z)
        local dist2 = Vdist(CoordsPed.x, CoordsPed.y, CoordsPed.z, Config.DepotLivraison.x, Config.DepotLivraison.y, Config.DepotLivraison.z)
        local dist3 = Vdist(CoordsPed.x, CoordsPed.y, CoordsPed.z, plyCoords.x, plyCoords.y, plyCoords.z)

        if CheckLivraison == 1 and dist0 <= 5.0 then
            Wait(1500)
            SetEntityCoords(VehiculeLivraison, Config.PointLivraison.x, Config.PointLivraison.y, Config.PointLivraison.z)
            SetEntityHeading(VehiculeLivraison, Config.PointLivraison.w) 
            SetVehicleDoorOpen(VehiculeLivraison, 2, false, false)
            SetVehicleDoorOpen(VehiculeLivraison, 3, false, false) 
            Wait(1500)     
            TaskGoToCoordAnyMeans(PedInVehicle, Config.LivraisonPorteVehicule.x, Config.LivraisonPorteVehicule.y, Config.LivraisonPorteVehicule.z, 1.0, 0, 0, 786603, 0xbf800000)  
            CheckLivraison = 2            
        end 

        if CheckLivraison == 2 and dist1 <= 2.5 then
            Wait(1500)
            SetEntityCoords(PedInVehicle, Config.LivraisonPorteVehicule.x, Config.LivraisonPorteVehicule.y, Config.LivraisonPorteVehicule.z-0.99)
            SetEntityHeading(PedInVehicle, Config.LivraisonPorteVehicule.w)
            RequestAnimDict('anim@heists@box_carry@')
            while not HasAnimDictLoaded('anim@heists@box_carry@') do
               Wait(100)
            end

            TaskPlayAnim(PedInVehicle, 'anim@heists@box_carry@', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            prop_boite = CreateObject(GetHashKey("hei_prop_heist_box"), CoordsPed.x, CoordsPed.y, CoordsPed.z,  true,  true, true)
            AttachEntityToEntity(prop_boite, PedInVehicle, GetPedBoneIndex(PedInVehicle, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
            Wait(2500)
            SetVehicleDoorShut(VehiculeLivraison, 2, true)
            SetVehicleDoorShut(VehiculeLivraison, 3, true)
            Wait(500)
            TaskGoToCoordAnyMeans(PedInVehicle, Config.DepotLivraison.x, Config.DepotLivraison.y, Config.DepotLivraison.z, 1.0, 0, 0, 786603, 0xbf800000)
            CheckLivraison = 3
        end

        if CheckLivraison == 3 and dist2 <= 1.0 then 
            Wait(1000)
            SetEntityHeading(PedInVehicle, Config.DepotLivraison.w) 
            TriggerServerEvent('kIrishPub:Livraison', Config.Livraison)
            Wait(2000)
            DeleteEntity(prop_boite)
            ClearPedTasks(PedInVehicle)
            TaskVehicleDriveToCoord(PedInVehicle, VehiculeLivraison, Config.SpawnLivraison.x, Config.SpawnLivraison.y, Config.SpawnLivraison.z, 7.5, 0, GetEntityModel(VehiculeLivraison), 63, 2.0)
            CheckLivraison = 4
        end

        if CheckLivraison == 4 and IsPedInAnyVehicle(PedInVehicle, true) and dist3 > 100 then 
            Wait(1500)
            RemovePedElegantly(PedInVehicle)
            DeleteEntity(VehiculeLivraison)
            
            CheckLivraison = 0
            CompteurMission = true
        end
    end
end)
