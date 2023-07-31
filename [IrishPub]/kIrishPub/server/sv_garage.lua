ESX = exports["es_extended"]:getSharedObject() 

ESX.RegisterServerCallback("kIrishPub:VehiculeSocietyDispo", function(source, cb)
	local society = Config.NameJob
	local list_vehicles_dispo = {}

	MySQL.Async.fetchAll("SELECT * FROM society_vehicles WHERE society = @society and stored = @stored", {
		['@society'] = Config.NameJob,
        ['@stored'] = 1,
	}, function(result)
		if result then
			for _,v in pairs(result) do
				table.insert(list_vehicles_dispo, {society = v.society, plate = v.plate, vehicle = v.vehicle, label = v.label, stored = v.stored, pos = v.lieu})
			end
			cb(list_vehicles_dispo)
		end
	end)
end)

RegisterNetEvent("kIrishPub:SaveStatsSortie")
AddEventHandler("kIrishPub:SaveStatsSortie", function(plate, stored, properties)

    MySQL.Async.fetchAll("UPDATE society_vehicles SET stored = @stored, vehicle = @vehicle WHERE plate = @plate", {
		["@stored"] = stored,
		["@vehicle"] = json.encode(properties),
		["@plate"] = plate 
	}, function() end)
end)

