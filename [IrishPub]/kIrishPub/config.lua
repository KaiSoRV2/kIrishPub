Config = {

    Webhook = "https://discord.com/api/webhooks/1130890640738226248/vGuQ9N3DgvIOZ1OKAKgkK4wKXEv3ya9apbr35QouRQ-nUfbx7HkVjRpNhDTYq120HPEC",
    NameJob = 'irishpub', -- Nom du Job (majoritairement config à vérifier parfois)
    ActiveBlipsRaduis = true,
    PourcentageVente = 0.65, -- Pourcentage que l'entreprise touche sur la vente d'un véhicule par rapport au prix d'achat

    PriceLivraison = 2000, --  Prix de la livraison
    SpawnLivraison = vector4(1218.50, -309.61, 68.92, 18.56), -- Si un de modifier, il faut tous les modifier !
    PointLivraison = vector4(825.28, -86.46, 80.44, 54.76),
    LivraisonPorteVehicule = vector4(829.52, -89.20, 80.54, 54.01),
    DepotLivraison = vector4(814.25, -109.08, 80.60, 245.72),

    Livraison = { 
        {item = 'whisky', label = 'Whisky', count = 50}, --> Liste de ce qui est livré 
        {item = 'tequila', label = 'Tequila', count = 50},
        {item = 'vodka', label = 'Vodka', count = 50},
        {item = 'beer', label = 'Bière', count = 50},
        {item = 'coffe', label = 'Café', count = 50},
        {item = 'rhum', label = 'Rhum', count = 50},
        {item = 'martini', label = 'Martini', count = 50}
    },
    
    PedGarage = {
        hash = 's_m_m_gardener_01',
        Pos = vector4(814.81, -109.51, 80.60, 58.30)
    },
    
    Blips = {
        Title = "~g~Irish ~s~Pub",
        Type = 547,
        Color = 2,
        Raduis = 50.01,
        Size = 0.65,
    },

    BlipsPositions = {
        Batiment = {pos = vector3(842.18, -112.14, 80.01), title = '~g~Irish ~s~Pub', ox_target = nil},
        Recolte = {pos = vector3(340.81, 775.86, 186.20), title = '~g~Irish Pub~s~ | Récolte', ox_target = {label = "Récolter des Pommes", icon = 'fa-solid fa-apple-whole', event = 'RecoltePomme', size = vec3(4, 4, 2)}},
        Traitement = {pos = vector3(246.59, 372.90, 105.78), title = '~g~Irish Pub~s~ | Traitement', ox_target = {label = "Traiter vos Pommes", icon = 'fa-solid fa-wine-bottle', event = 'TraitementPomme', size = vec3(2.5, 2.5, 2)}},
        Vente = {pos = vector3(1129.14, -468.43, 66.48), title = '~g~Irish Pub~s~ | Vente', ox_target = {label = "Vendre vos Pommes", icon = 'fa-solid fa-sack-dollar', event = 'VentePomme', size = vec3(5, 2, 3)}},
    },

    Farm = {
        PommeParRecolte = {item = 'pomme', count = 10},
        CidreParTraitement = {item = 'cidre', count = 5},
        CidreParVente = {item = 'cidre', PriceCidre = 250},
        PourcentageSociety = 0.8, -- Pourcentage reçu par l'entreprise
        PourcentagePlayer = 0.2, -- Pourcentage reçu par le joueur
        TimeRecolte = 5, -- en secondes
        TimeTraitement = 5, -- en secondes
        TimeVente = 10, -- en secondes
    },

    Positions = {                  
        Vestiaire = vec3(824.60, -111.93, 80.43),      
        Boss = vec3(831.051, -117.12, 80.43),      

        Frigo_ox_target = {
            event = 'OpenInvSociety',
            icon = 'fa-brands fa-dropbox',
            label = 'Ouvrir le Frigo',  
            rotation = 60,  

            CoordsFrigo = {
                {coords = vec3(836.68, -114.59, 79.47), size = vec3(1, 1.3, 0.9)}, 
                {coords = vec3(833.98, -115.53, 79.35), size = vec3(1, 4.5, 0.9)},
            },
        },
    },

    VehiculeIrishPub = { 
        {name = 'hustler', label = "Hustler", price = 2000}, 
        {name = 'baller6', label = "Baller", price = 4000}, 
        {name = 'schafter4', label = "Schafter", price = 6000}, 
        {name = 'gburrito2', label = "Burrito", price = 8000}, 
    },

}

