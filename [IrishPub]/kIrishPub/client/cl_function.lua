ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    for k, v in pairs(Config.BlipsPositions) do 
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.NameJob then 
            blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
            SetBlipSprite(blip, Config.Blips.Type)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.Blips.Size)
            SetBlipColour(blip, Config.Blips.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(v.title)
            EndTextCommandSetBlipName(blip)
        else 
            blip = AddBlipForCoord(Config.BlipsPositions.Batiment.pos.x, Config.BlipsPositions.Batiment.pos.y, Config.BlipsPositions.Batiment.pos.z)
            SetBlipSprite(blip, Config.Blips.Type)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.Blips.Size)
            SetBlipColour(blip, Config.Blips.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.BlipsPositions.title)
            EndTextCommandSetBlipName(blip)
        end 
    end
end)