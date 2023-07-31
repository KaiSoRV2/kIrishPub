ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory

AddEventHandler('OpenInvSociety', function()
    exports.ox_inventory:openInventory('stash', 'society_irishpub')
end)

Citizen.CreateThread(function()
    for k , v in pairs(Config.Positions.Frigo_ox_target.CoordsFrigo) do
        exports.ox_target:addBoxZone({
            coords = v.coords,
            size = v.size,
            rotation = Config.Positions.Frigo_ox_target.rotation,
            debug = false,
            distance = 10,
            options = {
                {
                    groups = Config.NameJob,
                    event = Config.Positions.Frigo_ox_target.event,
                    icon = Config.Positions.Frigo_ox_target.icon,
                    label = Config.Positions.Frigo_ox_target.label,  
                },
            }
        })
    end 
end)