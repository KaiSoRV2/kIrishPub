ESX = exports["es_extended"]:getSharedObject() 

function Facture()
    ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'facture',
        {
            title = 'Donner une facture'
        },
        function(data, menu)
    
            local amount = tonumber(data.value)
    
            if amount == nil or amount <= 0 then
                lib.notify({
                    id = 'InvalidMoney',
                    title = 'Facture',
                    description = 'Montant Invalide !',
                    duration = 6000,
                    position = 'center-left',
                    style = {
                        ['.description'] = {
                            color = 'red',
                        }
                    },
                    icon = 'fa-regular fa-clipboard',
                })
            else
                menu.close()
    
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                if closestPlayer == -1 or closestDistance > 3.0 then
                    lib.notify({
                        id = 'NoPlayerClose',
                        title = 'Facture',
                        description = 'Pas de joueur à proximiter !',
                        duration = 6000,
                        position = 'center-left',
                        style = {
                            ['.description'] = {
                                color = 'red',
                            }
                        },
                        icon = 'fa-regular fa-clipboard',
                    })
                else
                    local playerPed = GetPlayerPed(-1)
    
                    Citizen.CreateThread(function()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                        Citizen.Wait(5000)
                        ClearPedTasks(playerPed)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_irishpub', 'irishpub', amount)
                        lib.notify({
                            id = 'FactureSend',
                            title = 'Facture',
                            description = 'Vous avez bien envoyé la facture !',
                            duration = 6000,
                            position = 'center-left',
                            style = {
                                ['.description'] = {
                                    color = 'red',
                                }
                            },
                            icon = 'fa-regular fa-clipboard',
                        })
                    end)
                end
            end
        end,
        function(data, menu)
            menu.close()
    end)
end


Citizen.CreateThread(function() 
    while true do 
        if IsControlJustPressed(1,167) and (ESX.PlayerData.job and ESX.PlayerData.job.name == "irishpub") then
            lib.showContext('MenuF6')
        end
        Citizen.Wait(1)  
    end
end)

lib.registerContext({
    id = 'MenuF6',
    title = 'Menu F6',
    options = {
        {            
            title  = 'Facture',
            icon = 'fa-solid fa-file-signature',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                Facture()
            end
        },
        {
            title  = 'Annonces',
            icon = 'fa-solid fa-share-nodes',
            iconColor = '#FFFFFF',
            arrow = true,
            menu = 'MenuAnnonces',
        },
        {
            title  = 'Points de Farm',
            icon = 'fa-solid fa-leaf',
            iconColor = '#FFFFFF',
            arrow = true,
            menu = 'MenuFarm',
        },
    }
})

lib.registerContext({
    id = 'MenuAnnonces',
    title = 'Menu Annonces',
    menu = 'MenuF6',
    options = {
        {
            title  = 'Ouverture',
            icon = 'fa-solid fa-lock-open',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('kIrishPub:AnnonceOuverture')
            end
        },
        {
            title  = 'Fermeture',
            icon = 'fa-solid fa-lock',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('kIrishPub:AnnonceFermeture')  
            end
        },
        {
            title  = 'Recrutement',
            icon = 'fa-solid fa-user-pen',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('kIrishPub:AnnonceRecrutement')  
            end
        },
    }
})

lib.registerContext({
    id = 'MenuFarm',
    title = 'Points de Farm',
    menu = 'MenuF6',
    options = {
        {
            title  = 'Récolte',
            icon = 'fa-brands fa-pagelines',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                SetNewWaypoint(Config.BlipsPositions.Recolte.pos.x, Config.BlipsPositions.Recolte.pos.y, Config.BlipsPositions.Recolte.pos.z)
            end
        },
        {
            title  = 'Traitement',
            icon = 'fa-solid fa-wine-glass',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                SetNewWaypoint(Config.BlipsPositions.Traitement.pos.x, Config.BlipsPositions.Traitement.pos.y, Config.BlipsPositions.Traitement.pos.z)
            end
        },
        {
            title  = 'Vente',
            icon = 'fa-solid fa-money-bill-trend-up',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                SetNewWaypoint(Config.BlipsPositions.Vente.pos.x, Config.BlipsPositions.Vente.pos.y, Config.BlipsPositions.Vente.pos.z)
            end
        },
    }
})

