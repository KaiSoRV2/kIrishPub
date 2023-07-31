ESX = exports["es_extended"]:getSharedObject() 

RegisterServerEvent('kIrishPub:AnnonceOuverture')
AddEventHandler('kIrishPub:AnnonceOuverture', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('ox_lib:notify', xPlayers[i], {
			id = 'AO',
			title = 'Irish Pub',
			description = 'Irish Pub est maintenant Ouvert !',
			duration = 6000,
			position = 'center-left',
			style = {
				['.title'] = {
					color = '#32a852'
				},
				['.description'] = {
					color = '#FFFFFF'
				}
			},
			icon = 'fa-solid fa-martini-glass-citrus',
			iconColor = '#2a8743'
		})
	end
end)

RegisterServerEvent('kIrishPub:AnnonceFermeture')
AddEventHandler('kIrishPub:AnnonceFermeture', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('ox_lib:notify', xPlayers[i], {
			id = 'AF',
			title = 'Irish Pub',
			description = 'Irish Pub ferme ses portes pour aujourd\'hui !',
			duration = 6000,
			position = 'center-left',
			style = {
				['.title'] = {
					color = '#32a852'
				},
				['.description'] = {
					color = '#FF0000'
				}
			},
			icon = 'fa-solid fa-martini-glass-citrus',
			iconColor = '#2a8743'
		})
	end
end)

RegisterServerEvent('kIrishPub:AnnonceRecrutement')
AddEventHandler('kIrishPub:AnnonceRecrutement', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		TriggerClientEvent('ox_lib:notify', xPlayers[i], {
			id = 'AR',
			title = 'Irish Pub',
			description = 'Recrutement en cours, rendez-vous au Irish Pub !',
			duration = 6000,
			position = 'center-left',
			style = {
				['.title'] = {
					color = '#32a852'
				},
				['.description'] = {
					color = '#989c24'
				}
			},
			icon = 'fa-solid fa-martini-glass-citrus',
			iconColor = '#2a8743'
		})
	end
end)








