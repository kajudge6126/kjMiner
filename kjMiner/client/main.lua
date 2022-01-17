local PlayerData = {}
QBCore = nil

local blip1 = {}
local blips = false
local blipActive = false
local mineActive = false
local washingActive = false
local remeltingActive = false
local firstspawn = false
local GorevAraci = nil
local impacts = 0
local timer = 0
local lastTime = 0
local locations = {
    { ['x'] = 2936.68,  ['y'] = 2771.28,  ['z'] = 39.36}, -- 2936.68, 2771.28, 39.36 + 
    { ['x'] = 2924.89,  ['y'] = 2795.43,  ['z'] = 40.81}, -- 2926.08, 2793.6, 40.64 +
    { ['x'] = 2919.92,  ['y'] = 2799.56,  ['z'] = 41.24}, -- 2919.92, 2799.56, 41.24 +
    { ['x'] = 2927.36,  ['y'] = 2790.4,  ['z'] = 40.24}, -- 2927.36, 2790.4, 40.24
    { ['x'] = 2933.92,  ['y'] = 2783.68,  ['z'] = 39.36}, -- 2933.92, 2783.68, 39.36 +
}

local jobsSelling = {
    {
        ["coords"] = vector3(-1477.28, -674.28, 28.04),
        ["draw-3d"] = "[E] - Maden Token Sat",
        ["item"] = "maden_token",
        ["money"] = 50,
    },
}

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)  

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent("ynf_miner:washing")
AddEventHandler("ynf_miner:washing", function()
    Washing()
end)

RegisterNetEvent("ynf_miner:remelting")
AddEventHandler("ynf_miner:remelting", function()
    TokenConvert()
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
    madenalani = AddBlipForCoord(2930.48, 2789.84, 40.08)
    SetBlipSprite(madenalani, 268)
    SetBlipScale(madenalani, 0.6)
    SetBlipColour(madenalani, 5)
    SetBlipAsShortRange(madenalani, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Maden Alanı")
    EndTextCommandSetBlipName(madenalani)
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
    start = AddBlipForCoord(1053.08, -1957.92, 31.04)
    SetBlipSprite(start, 268)
    SetBlipScale(start, 0.6)
    SetBlipColour(start, 5)
    SetBlipAsShortRange(start, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Maden İşleme")
    EndTextCommandSetBlipName(start)
end)


RegisterNetEvent('ynf_miner:timer')
AddEventHandler('ynf_miner:timer', function()
    local timer = 0
    local ped = PlayerPedId()
    
    Citizen.CreateThread(function()
		while timer > -1 do
			Citizen.Wait(150)

			if timer > -1 then
				timer = timer + 1
            end
            if timer == 100 then
                break
            end
		end
    end) 

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), 1113.96, -2005.96, 35.44, true) < 5 then
                TriggerEvent('inventory:client:Maden')
                QBCore.Functions.DrawText3D( 1113.96, -2005.96, 35.44+0.5 -1.400, ('Taşlar Eritiliyor ' .. timer .. '%'), 4, 0.1, 0.1)
            end
            if GetDistanceBetweenCoords(GetEntityCoords(ped), 1079.92, -1982.68, 31.48, true) < 5 then
                TriggerEvent('inventory:client:Maden')
                QBCore.Functions.DrawText3D( 1079.92, -1982.68, 33.48 -1.400, ('Eritilmiş Taş Tokene Dönüştürülüyor ' .. timer .. '%'), 4, 0.1, 0.1)
            end
            if timer == 100 then
                timer = 0
                break
            end
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
            for i=1, #locations, 1 do
            if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 25 and mineActive == false then
                DrawMarker(20, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 100.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 1 then
                    QBCore.Functions.DrawText3D(locations[i].x, locations[i].y, locations[i].z, "E - Kazmaya Başla")
                    if IsControlJustReleased(1, 51) then
                        Animation()
                        mineActive = true
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        for i=1, 1 do
            if GetDistanceBetweenCoords(GetEntityCoords(ped), 1054.8, -1952.84, 32.08, true) < 1 then
                DrawMarker(25, 1054.8, -1952.84, 32.08-0.9, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                QBCore.Functions.DrawText3D(1054.8, -1952.84, 32.08, "E - Maden Meslek Menüsü")
                if IsControlJustReleased(1, 51) then
                    StartMenu()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), 1113.96, -2005.96, 35.44, true) < 25 and washingActive == false then
            DrawMarker(20, 1113.96, -2005.96, 35.44, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), 1113.96, -2005.96, 35.44, true) < 1 then
                    QBCore.Functions.DrawText3D(1113.96, -2005.96, 35.44, "E - Taşları Dönüştür")
                    
                        if IsControlJustReleased(1, 51) then
                            TriggerServerEvent("ynf_miner:washing")
                        end
                end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), 1079.92, -1982.68, 31.48, true) < 25 and remeltingActive == false then
            DrawMarker(20, 1079.92, -1982.68, 31.48, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), 1079.92, -1982.68, 31.48, true) < 1 then
                    QBCore.Functions.DrawText3D(1079.92, -1982.68, 31.48, "E - Eritilmiş Taşları Tokene Çevir")
                    if IsControlJustReleased(1, 51) then
                        TriggerServerEvent("ynf_miner:remelting")  
                    end
                end
            end
        end
    end)

function StartMenu()
    local elements = {
        {label = 'Meslek Bilgi',     value = 'jobinfo'},
        {label = 'Araç Kirala',     value = 'rentacar'},
        {label = 'Araç Teslim Et',     value = 'dellcar'},
        {label = 'Menüyü Kapat',    value = 'kapat'},
    }

    QBCore.UI.Menu.CloseAll()
    QBCore.UI.Menu.Open('default', GetCurrentResourceName(), 'startmenu_actions', {
        title    = 'Maden Meslek Menüsü',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'rentacar' then
            menu.close()
            AracOlustur()
            lastTime = GetGameTimer() + 900000
        elseif data.current.value == 'dellcar' then
            menu.close()
            AracSil()
        elseif data.current.value == 'jobinfo' then
            TriggerEvent('shx-notify:sendAlert', 'Maden Bilgi', 'Maden mesleğine hoş geldin! Öncelikle Meslek Başlangıç noktasından araç kiralamalısın ardından haritadan da işaretlenen noktaya giderek taş toplamalısın. Taş toplama işlemini bitirdikten sonra başlangıç noktasının arkasında bulunan depoya girerek taşları eritmelisin. Taşları tokene dönüştürdükten sonra Motelde bulunan alıcıya tokenleri satabilirsin. Kolay gelsin!', 15000, 'truck-monster')
        elseif data.current.value == 'kapat' then
            menu.close()
        end
    end)
end

function AracOlustur()
    if vehicle == nil then
        TriggerServerEvent('ynf_miner:arac')
    else
        QBCore.Functions.Notify("Zaten bir aracınız var!", "error")
    end
end

RegisterNetEvent('ynf_miner:AracOlustur')
AddEventHandler('ynf_miner:AracOlustur', function ()
    if vehicle == nil then
        local modelHash = GetHashKey("Rebel")
        RequestModel(modelHash)
        local isLoaded = HasModelLoaded(modelHash)
        while isLoaded == false do
            Citizen.Wait(100)
        end
        vehicle = CreateVehicle(modelHash, 1073.76, -1949.16, 31.0, 146.88, 1, 0) -- 1073.76, y=-1949.16, z=31.0, h=146.88
        TriggerEvent("x-hotwire:give-keys", vehicle)
        plate = GetVehicleNumberPlateText(vehicle)
        Citizen.Wait(5000)

        TriggerServerEvent("qb-phone:server:sendNewMail", { 
            sender = "Maden Meslek", 
            subject = "Maden Alanı Konumu", 
            message = "Madencilik mesleğine tekrardan hoş geldin! Maden konumunu haritada işaretlemek için aşağıda icona tıklayabilirsin. Kolay gelsin.", 
            button = vector3(2930.48, 2789.84, 40.08),
            image = "https://cdn.discordapp.com/attachments/906532782107426816/920374659143319634/majudge.png"
        })
        
    else
        QBCore.Functions.Notify("Zaten bir aracınız var!", "error")
    end
end)

function AracSil()
    if vehicle ~= nil then
        if plate == GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true)) then
            DeleteEntity(vehicle)
            DeleteVehicle(vehicle)
            QBCore.Functions.DeleteVehicle(vehicle)
            vehicle = nil
            QBCore.Functions.Notify("Araç başarıyla teslim edildi. Depozitonuz geri ödenmiştir.", "success")
            TriggerServerEvent('ynf_miner:paraver')
        else
            QBCore.Functions.Notify("Araca in bin yapıp tekrar deneyiniz.", "error")
        end
    end
end

function Animation()
    Citizen.CreateThread(function()
        while impacts < 5 do
            Citizen.Wait(1)
		local ped = PlayerPedId()	
            RequestAnimDict("melee@large_wpn@streamed_core")
            Citizen.Wait(100)
            TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
            SetEntityHeading(ped, 270.0)
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'pickaxe', 0.5)
            if impacts == 0 then
                pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.0, -0.00, -0.00, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
            end
            Citizen.Wait(1000)
            ClearPedTasks(ped)
            impacts = impacts+1
            if impacts == 5 then
                DetachEntity(pickaxe, 1, true)
                DeleteEntity(pickaxe)
                DeleteObject(pickaxe)
                mineActive = false
                impacts = 0
                TriggerServerEvent("ynf_miner:givestone")
                break
            end        
        end
    end)
end

function Washing()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    washingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    TriggerEvent("ynf_miner:timer")
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    washingActive = false
end

function TokenConvert()
    local ped = PlayerPedId()
    remeltingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TriggerEvent("ynf_miner:timer")
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    remeltingActive = false
end