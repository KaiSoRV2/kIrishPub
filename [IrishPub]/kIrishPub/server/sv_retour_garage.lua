
RegisterNetEvent("kIrishPub:SaveStatsEntrer")
AddEventHandler("kIrishPub:SaveStatsEntrer", function(plate, stored, properties, pos)
    MySQL.Async.fetchAll("UPDATE society_vehicles SET stored = @stored, vehicle = @vehicle, lieu = @lieu WHERE plate = @plate", {
		["@stored"] = stored,
		["@vehicle"] = json.encode(properties),
		["@plate"] = plate,
		["@lieu"] = json.encode(pos)
	}, function() end)
end)