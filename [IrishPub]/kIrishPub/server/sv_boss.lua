ESX = exports["es_extended"]:getSharedObject() 

------------------------ [Boss Menu] ------------------------ 

-- Vérifie tous les véhicules de la société

ESX.RegisterServerCallback("kIrishPub:VehiculeSociety", function(source, cb)
	local society = Config.NameJob
	local list_vehicles = {}

	MySQL.Async.fetchAll("SELECT * FROM society_vehicles WHERE society = @society", {
		['@society'] = Config.NameJob,
	}, function(result)
		if result then
			for _,v in pairs(result) do
				table.insert(list_vehicles, {society = v.society, plate = v.plate, vehicle = v.vehicle, label = v.label, stored = v.stored, pos = v.lieu})
			end
			cb(list_vehicles)
		end
	end)
end)

-- Permet de vendre un véhicule de la société 

RegisterServerEvent('kIrishPub:VenteVehicule')
AddEventHandler('kIrishPub:VenteVehicule', function(infos_vehicule) 

	src_ = source
	local xPlayer = ESX.GetPlayerFromId(src_)

	for k, v in pairs(infos_vehicule) do 
		plate = v.plate
		label = v.label
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
		societyAccount = account 
	end)

	MySQL.Async.execute("DELETE FROM society_vehicles WHERE society = @society and plate = @plate", {
		['@society'] = Config.NameJob,
		['@plate'] = plate,

	}, function(result)
		if result ~= nil then
			for k, v in pairs(Config.VehiculeIrishPub) do 
				if v.label == label then
					PriceVente = Config.PourcentageVente * v.price
					societyAccount.addMoney(PriceVente)
					TriggerClientEvent('ox_lib:notify', src_,
					{
						id = 'VV',
						title = 'Irish Pub',
						description = 'Vous venez de vendre un '..label..' n°'..plate..' pour '..ESX.Math.GroupDigits(PriceVente)..'$',
						duration = 5000,
						position = 'center-left',
						style = {
							['.description'] = {
								color = '#3eb05c',
							}
						},
						icon = 'fa-solid fa-martini-glass-citrus',
						iconColor = '#2a8743'
					})
					TriggerEvent("kIrishJob:LogsSend", "Logs Vente", "Irish Pub", (xPlayer.getName().." vient de ventre un "..label.." n°"..plate.." pour "..ESX.Math.GroupDigits((PriceVente)).."$"), Config.Webhook)
				end
			end 
		end
	end)
end)

-- Permet l'achats d'un véhicule pour la société

RegisterServerEvent('kIrishPub:AchatsVehiculeSociety')
AddEventHandler('kIrishPub:AchatsVehiculeSociety', function(label, price, vehicle, vehicule_plate) 
    
	src_ = source
	local xPlayer = ESX.GetPlayerFromId(src_)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
		societyAccount = account 
	end)

	if societyAccount.money < price then 
		TriggerClientEvent('ox_lib:notify', src_,
		{
			id = 'PB',
			title = 'Bank Société',
			description = 'La société n\'a pas assez d\'argent !',
			duration = 5000,
			position = 'center-left',
			style = {
				['.description'] = {
					color = 'red',
				}
			},
			icon = 'fa-solid fa-building-columns',
		})
	else 
	    MySQL.Async.fetchAll("SELECT * FROM society_vehicles WHERE plate = @plate", {
            ['@plate'] = vehicule_plate,

	    }, function(result) 
		    if result[1] then
				TriggerClientEvent('ox_lib:notify', src_,
				{
					id = 'PB',
					title = 'Problème Technique',
					description = 'Pas de chance la plaque est déjà enregistrée, recommence.',
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
				MySQL.Async.execute("INSERT INTO society_vehicles (society, plate, vehicle, label, stored, lieu) VALUES (@society, @plate, @vehicle, @label, @stored, @lieu)", {
					['@society'] = Config.NameJob,
					['@plate'] = vehicule_plate,
					['@vehicle'] = json.encode(vehicle),
					['@label'] = label,
					['@stored'] = 1,
					['@lieu'] = nil
		
				}, function(result)
					if result ~= nil then
						societyAccount.removeMoney(price)
						TriggerClientEvent('ox_lib:notify', src_,
						{
							id = 'AV',
							title = 'Irish Pub',
							description = 'Vous avez acheté un '..label..' n°'..vehicule_plate..' pour '..ESX.Math.GroupDigits(price)..'$',
							duration = 5000,
							position = 'center-left',
							style = {
								['.description'] = {
									color = '#3eb05c',
								}
							},
							icon = 'fa-solid fa-martini-glass-citrus',
							iconColor = '#2a8743'
						})
						TriggerEvent("kIrishJob:LogsSend", "Logs Achats", "Irish Pub", (xPlayer.getName().." vient d'acheter un "..label.." pour "..ESX.Math.GroupDigits(price).."$"), Config.Webhook)
					end
				end)
		    end 
	    end) 
	end
end)

-- Renvoie l'argent qu'à la société

RegisterServerEvent('kIrishPub:ArgentSociety')
AddEventHandler('kIrishPub:ArgentSociety', function() 
    
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
		societyAccount = account 
	end)

	TriggerClientEvent('ox_lib:notify', source, {
		id = 'AS',
		title = 'Irish Pub',
		description = 'La société a un capital de '..ESX.Math.GroupDigits(societyAccount.money)..'$',
		duration = 6000,
		position = 'center-left',
		icon = 'fa-solid fa-martini-glass-citrus',
		iconColor = '#2a8743'
	})
end)