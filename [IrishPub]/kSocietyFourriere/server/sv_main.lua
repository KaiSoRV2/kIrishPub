ESX = exports["es_extended"]:getSharedObject() 

ESX.RegisterServerCallback("kSocietyFourriere:VehiculeOut", function(source, cb, JobPlayer)
	local list_vehicles_fourriere = {}

	MySQL.Async.fetchAll("SELECT * FROM society_vehicles WHERE society = @society and stored = @stored", {
		['@society'] = JobPlayer,
        ['@stored'] = 0,
	}, function(result)
		if result then
			for _,v in pairs(result) do
				table.insert(list_vehicles_fourriere, {society = v.society, plate = v.plate, vehicle = v.vehicle, label = v.label, stored = v.stored, pos = v.lieu})
			end
			cb(list_vehicles_fourriere)
		end
	end)
end)

RegisterNetEvent("kSocietyFourriere:SortieFourriere")
AddEventHandler("kSocietyFourriere:SortieFourriere", function(Label, Plate, stored, properties)
	
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('ox_lib:notify', source,
        {
            id = 'PayeFourriere',
            title = 'Fourrière',
            description = 'Vous venez de sortir un '..Label..' n°'..Plate,
            duration = 5000,
            position = 'center-left',
            style = {
                ['.description'] = {
                    color = '#eb9534',
                }
            },
            icon = 'fa-solid fa-car-rear',
            iconColor = '#eb9534'
        })
	TriggerEvent("kSocietyFourriere:LogsSend", "Logs Fourrière", "Fourrière", xPlayer.getName()..' vient de sortir un '..Label..' n°'..Plate.." de la fourrière.", Config.Webhook)
	
	MySQL.Async.fetchAll("UPDATE society_vehicles SET stored = @stored, vehicle = @vehicle WHERE plate = @plate", {
		["@stored"] = stored,
		["@vehicle"] = json.encode(properties),
		["@plate"] = Plate 
	}, function() end)

end)

local function sendToDiscordWithSpecialURL(Name, Title, Description, Webhook)
	local date = os.date('*t')

	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local Content = {
	        {
	            ["color"] = 0,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	            ["text"] = ("%s/%s/%s | %s h %s m %s s"):format(date.day, date.month, date.year, date.hour, date.min, date.sec),
	            ["icon_url"] = nil,
	            },
	        }
	    }
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("kSocietyFourriere:LogsSend")
AddEventHandler("kSocietyFourriere:LogsSend", function(Name, Title, Description, Webhook)
    sendToDiscordWithSpecialURL(Name, Title, Description, Webhook)
end)
