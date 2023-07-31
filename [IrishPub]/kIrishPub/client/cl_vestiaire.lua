ESX = exports["es_extended"]:getSharedObject()

function TenueService()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = 10,  ['tshirt_2'] = 11,
                ['torso_1'] = 23,   ['torso_2'] = 0,
                ['arms'] = 4,
                ['pants_1'] = 20,   ['pants_2'] = 3,
                ['shoes_1'] = 3,    ['shoes_2'] = 2,
                ['helmet_1'] = 26,  ['helmet_2'] = 4,
                ['chain_1'] = 22,   ['chain_2'] = 0,
                ['ears_1'] = -1,    ['ears_2'] = 0
            }

        else
            clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 8,
                ['torso_1']  = 24,  ['torso_2']  = 11,
                ['arms']     = 1,
                ['pants_1']  = 23,  ['pants_2']  = 0,
                ['shoes_1']  = 6,   ['shoes_2']  = 0,
                ['helmet_1'] = 26,  ['helmet_2'] = 4,
                ['chain_1']  = 23,  ['chain_2']  = 1,
                ['ears_1']   = -1,  ['ears_2']   = 0
            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end
    
function TenueCivil()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

function TenuePatron()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = 21,  ['tshirt_2'] = 4,
                ['torso_1'] = 24,   ['torso_2'] = 1,
                ['arms'] = 4,
                ['pants_1'] = 24,   ['pants_2'] = 5,
                ['shoes_1'] = 3,    ['shoes_2'] = 2,
                ['helmet_1'] = 26,  ['helmet_2'] = 4,
                ['chain_1'] = 22,   ['chain_2'] = 0,
                ['ears_1'] = -1,    ['ears_2'] = 0
            }

        else
            clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 8,
                ['torso_1']  = 24,  ['torso_2']  = 11,
                ['arms']     = 1,
                ['pants_1']  = 23,  ['pants_2']  = 0,
                ['shoes_1']  = 20,   ['shoes_2']  = 0,
                ['helmet_1'] = 7,  ['helmet_2'] = 0,
                ['chain_1']  = 22,  ['chain_2']  = 3,
                ['ears_1']   = -1,  ['ears_2']   = 0
            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end

AddEventHandler('EventVestiaire', function()  
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        lib.showContext('MenuVestiaireBoss')

    else
        lib.showContext('MenuVestiaire')
    end     
end)

Citizen.CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.Positions.Vestiaire,
        size = vec3(1.1, 1.6, 2),
        rotation = 60,
        debug = false,
        options = {
            {
                groups = Config.NameJob,
                name = 'Vestiaire',
                event = 'EventVestiaire',
                icon = 'fa-solid fa-shirt',
                label = 'Vestiaire',  
            },
        }
    })
end)


lib.registerContext({
    id = 'MenuVestiaireBoss',
    title = 'Vestiaire',
    options = {
        {
            title  = 'Tenue Civil',
            icon = 'fa-solid fa-shirt',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TenueCivil()
                lib.hideContext('MenuVestiaireBoss')
            end
        },

        {
            title  = 'Tenue Service',
            icon = 'fa-solid fa-shirt',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TenueService()
                lib.hideContext('MenuVestiaireBoss')
            end 
        },

        {
            title  = 'Tenue Patron',
            icon = 'fa-solid fa-user-tie',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TenuePatron()
                lib.hideContext('MenuVestiaireBoss')
            end
        },
    }
})

lib.registerContext({
    id = 'MenuVestiaire',
    title = 'Vestiaire',
    options = {
        {
            title  = 'Tenue Civil',
            icon = 'fa-solid fa-shirt',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TenueCivil()
                lib.hideContext('MenuVestiaire')
            end
        },
    
        {
            title  = 'Tenue Service',
            icon = 'fa-solid fa-shirt',
            iconColor = '#FFFFFF',
            arrow = true,
            onSelect = function()
                TenueService()
                lib.hideContext('MenuVestiaire')
            end 
        },
    }
})