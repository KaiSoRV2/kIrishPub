
Citizen.CreateThread(function()
    if Config.ActiveBlipsRaduis then
        Raduis = Config.Blips.Raduis
        BlipsZone = AddBlipForRadius(Config.BlipsPositions.Batiment.pos.x, Config.BlipsPositions.Batiment.pos.y, Config.BlipsPositions.Batiment.pos.z, Raduis)
        SetBlipColour(BlipsZone, 2)
        SetBlipAlpha(BlipsZone, 50)
    end
end)


Citizen.CreateThread(function()
    while true do 
        local wait = 750
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.BlipsPositions.Batiment.pos.x, Config.BlipsPositions.Batiment.pos.y, Config.BlipsPositions.Batiment.pos.z)
        local VehUse = GetVehiclePedIsIn(PlayerPedId(), true)

        if dist <= Config.Blips.Raduis and IsPedSittingInVehicle(PlayerPedId(), VehUse) and (ESX.PlayerData.job and ESX.PlayerData.job.name == Config.NameJob) then
            wait = 0

            lib.showTextUI('Appuyez sur [E]', {
                borderRadius = 100,
                position = "left-center",
            })
            
            if IsControlJustPressed(1,51) then
                GetVehicleSociety()
                Wait(2000)
                for k , v in pairs(list_vehicles) do
                    if v.plate == GetVehicleNumberPlateText(VehUse) then
                        PlateVeh = v.plate
                    end 
                end 

                if PlateVeh == GetVehicleNumberPlateText(VehUse) then
                    local Pos = GetEntityCoords(VehUse)
                    local HeadingPos = GetEntityHeading(VehUse)
                    VehPos = vector4(Pos.x, Pos.y, Pos.z, HeadingPos)
                    TriggerServerEvent("kIrishPub:SaveStatsEntrer", PlateVeh, 1, ESX.Game.GetVehicleProperties(VehUse), VehPos)            
                    DeleteEntity(VehUse)
                    lib.notify({
                        id = 'notif_rentrer',
                        title = 'Garage Irish Pub',
                        description = 'Vous venez de ranger votre véhicule !',
                        duration = 2500,
                        position = 'center-left',
                        style = {
                            ['.description'] = {
                                color = '#FF0000'
                            }
                        },
                        icon = 'fa-solid fa-car',
                        iconColor = '#FFFFFF'
                    })

                else 
                    lib.notify({
                        id = 'notif_notsociety',
                        title = 'Garage Irish Pub',
                        description = 'Ce véhicule n\'appartient pas à la société !',
                        duration = 2500,
                        position = 'center-left',
                        style = {
                            ['.description'] = {
                                color = '#FF0000'
                            }
                        },
                        icon = 'fa-solid fa-car',
                        iconColor = '#FFFFFF'
                    })
                end
            end
        else 
            lib.hideTextUI()
        end
    Citizen.Wait(wait)
    end
end)


