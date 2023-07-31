local ox_inventory = exports.ox_inventory

ESX.RegisterServerCallback("kIrishPub:CheckMoney", function(source, cb, PriceLivraison)

    local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
		societyAccount = account 
	end)

    if societyAccount.money >= PriceLivraison then
        societyAccount.removeMoney(PriceLivraison)
        TriggerEvent("kIrishJob:LogsSend", "Logs Livraison", "Irish Pub", (xPlayer.getName().." vient de commander une livraison pour "..PriceLivraison).."$", Config.Webhook)
        cb(true)
    else 
        cb(false)
    end
end)

RegisterNetEvent("kIrishPub:Livraison")
AddEventHandler("kIrishPub:Livraison", function(TableLivraison)
    for k, v in pairs(TableLivraison) do
        exports.ox_inventory:AddItem('society_irishpub', v.item, v.count)
    end 
end)