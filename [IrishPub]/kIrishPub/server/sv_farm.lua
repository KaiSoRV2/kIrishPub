

RegisterServerEvent("kIrishPub:Recolte")
AddEventHandler("kIrishPub:Recolte", function(OldItem, OldCount)

    local CanCarryPomme = exports.ox_inventory:CanCarryItem(source, OldItem, OldCount)

    if not CanCarryPomme then

        TriggerClientEvent('ox_lib:notify', source,
        {
            id = 'TP',
            title = 'Irish Pub',
            description = 'Vous ne pouvez pas en porter d\'avantage !',
            duration = 5000,
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
        exports.ox_inventory:AddItem(source, OldItem, OldCount)
    end
end)

----------[ CONFIG Traitement ]----------

RegisterServerEvent("kIrishPub:Traitement")
AddEventHandler("kIrishPub:Traitement", function(OldItem, OldCount, NewItem, NewCount)
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local ComptPomme = exports.ox_inventory:GetItemCount(source, OldItem)
    local CanCarryCidre = exports.ox_inventory:CanCarryItem(source, NewItem, NewCount)
    
    if not CanCarryCidre then
        TriggerClientEvent('ox_lib:notify', source,
        {
            id = 'TP',
            title = 'Irish Pub',
            description = 'Vous ne pouvez pas en porter d\'avantage !',
            duration = 5000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = 'red',
                }
            },
            icon = 'fa-solid fa-martini-glass-citrus',
            iconColor = '#2a8743'
        })
    elseif ComptPomme < OldCount then
        TriggerClientEvent('ox_lib:notify', source,
        {
            id = 'NEP',
            title = 'Irish Pub',
            description = "Vous n'avez plus assez de "..OldItem.." pour traiter",
            duration = 5000,
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
        exports.ox_inventory:RemoveItem(source, OldItem, OldCount)
        exports.ox_inventory:AddItem(source, NewItem, NewCount)
    end
end)

----------[ CONFIG Vente ]----------

RegisterServerEvent("kIrishPub:Vente")
AddEventHandler("kIrishPub:Vente", function(NewItem, PriceCidre)

    local xPlayer = ESX.GetPlayerFromId(source)
    local ComptCidre = exports.ox_inventory:GetItemCount(source, NewItem)

    PriceTotal = ComptCidre * PriceCidre
    PriceSociety = PriceTotal * Config.Farm.PourcentageSociety
    PricePlayer = PriceTotal * Config.Farm.PourcentagePlayer

    if ComptCidre > 0 then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
            societyAccount = account
        end)

        societyAccount.addMoney(PriceSociety)
        xPlayer.addAccountMoney('bank', PricePlayer)
        exports.ox_inventory:RemoveItem(source, NewItem, ComptCidre)

        TriggerClientEvent('ox_lib:notify', source,
        {
            id = 'NEP',
            title = 'Irish Pub',
            description = "Votre entreprise a gagné "..ESX.Math.GroupDigits(PriceSociety).."$",
            duration = 10000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = '#3eb05c',
                }
            },
            icon = 'fa-solid fa-martini-glass-citrus',
            iconColor = '#2a8743'
        })

        TriggerClientEvent('ox_lib:notify', source,
        {
            id = 'BV',
            title = 'Irish Pub',
            description = "Vous venez de recevoir un virement de "..ESX.Math.GroupDigits(PricePlayer).."$",
            duration = 10000,
            position = 'center-left',

            icon = 'fa-solid fa-building-columns',
        })
    else
        TriggerClientEvent('ox_lib:notify', source,
        {
            id = 'NC',
            title = 'Irish Pub',
            description = 'Vous n\'avez rien à vendre !',
            duration = 5000,
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
end)