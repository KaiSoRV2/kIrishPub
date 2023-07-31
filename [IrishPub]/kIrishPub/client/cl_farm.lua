
AddEventHandler('RecoltePomme', function()
     if lib.progressCircle({
        label = 'Récolte en cours..',
        duration = (Config.Farm.TimeRecolte * 1000),
        position = 'middle',
        useWhileDead = false,
        allowRagdoll = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 
            clip = 'machinic_loop_mechandplayer'
        },
    })
    then TriggerServerEvent("kIrishPub:Recolte", Config.Farm.PommeParRecolte.item,  Config.Farm.PommeParRecolte.count) end
end)

AddEventHandler('TraitementPomme', function()
    if lib.progressCircle({
        label = 'Traitement en cours..',
        duration = (Config.Farm.TimeTraitement * 1000),
        position = 'middle',
        useWhileDead = false,
        allowRagdoll = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'rcmnigel1a', 
            clip = 'base'
        },
   })
   then TriggerServerEvent("kIrishPub:Traitement", Config.Farm.PommeParRecolte.item,  Config.Farm.PommeParRecolte.count, Config.Farm.CidreParTraitement.item, Config.Farm.CidreParTraitement.count) end
end)

AddEventHandler('VentePomme', function()
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, true)
    if lib.progressCircle({
        label = 'Vente en cours..',
        duration = (Config.Farm.TimeVente * 1000),
        position = 'middle',
        useWhileDead = false,
        allowRagdoll = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        }
   }) then
        ClearPedTasks(PlayerPedId()) 
        TriggerServerEvent("kIrishPub:Vente", Config.Farm.CidreParVente.item, Config.Farm.CidreParVente.PriceCidre)
    end
end)



Citizen.CreateThread(function()
    for k, v in pairs(Config.BlipsPositions) do
        if v.ox_target ~= nil then
            exports.ox_target:addBoxZone({
                coords = vec3(v.pos.x, v.pos.y, v.pos.z),
                size = v.ox_target.size,
                rotation = 75,
                debug = false,
                distance = 10,
                options = {
                    {
                        groups = Config.NameJob,
                        event = v.ox_target.event,
                        icon = v.ox_target.icon,
                        label = v.ox_target.label,  
                    },
                }
            })
        end
    end
end)