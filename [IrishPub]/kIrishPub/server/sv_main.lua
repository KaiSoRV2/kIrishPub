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

RegisterNetEvent("kIrishJob:LogsSend")
AddEventHandler("kIrishJob:LogsSend", function(Name, Title, Description, Webhook)
    sendToDiscordWithSpecialURL(Name, Title, Description, Webhook)
end)
