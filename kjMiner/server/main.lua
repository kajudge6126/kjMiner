QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('ynf_miner:arac')
AddEventHandler('ynf_miner:arac', function()
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
    local cash = xPlayer.PlayerData.money["cash"]
	
    if xPlayer.PlayerData.money["cash"] >= 50 then 
        xPlayer.Functions.RemoveMoney('cash', 50)
		TriggerClientEvent('ynf_miner:AracOlustur', _source)
        TriggerClientEvent("QBCore:Notify", _source, 'Araç kiraladığınız için 50$ depozito alındı. Aracı teslim ettiğinizde depozitoyu geri alabilirsiniz.', "success")
	else
        TriggerClientEvent("QBCore:Notify", _source, 'Yeterli paranız yok!', "error")
	end
end)

RegisterServerEvent('ynf_miner:paraver')
AddEventHandler('ynf_miner:paraver', function()
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)

    xPlayer.Functions.AddMoney('cash', 50)
end)

RegisterNetEvent("ynf_miner:givestone")
AddEventHandler("ynf_miner:givestone", function(item, amount)
    local _source = source
    local xPlayer  = QBCore.Functions.GetPlayer(_source)
        if xPlayer ~= nil then
            if xPlayer.Functions.GetItemByName('stone').amount < 100 then
                xPlayer.Functions.AddItem('stone', math.random(3,7))
                TriggerClientEvent("QBCore:Notify", _source, 'Başarıyla taşı parçaladın!', "success")
            end
        end
end)

RegisterNetEvent("ynf_miner:washing") -- taş eritme
AddEventHandler("ynf_miner:washing", function(item, amount)
    local _source = source
    local xPlayer  = QBCore.Functions.GetPlayer(_source)
        if xPlayer ~= nil then
            if xPlayer.Functions.GetItemByName('stone').amount > 9 then
                TriggerClientEvent("ynf_miner:washing", source)
                Citizen.Wait(15900)
                xPlayer.Functions.AddItem('washed_stone', 10)
                xPlayer.Functions.RemoveItem("stone", 10)
            elseif xPlayer.Functions.GetItemByName('stone').amount < 10 then
                TriggerClientEvent("QBCore:Notify", _source, 'Üzerinde yeterli taş yok.', "error")
            end
        end
end)

RegisterNetEvent("ynf_miner:remelting") -- taş eritme
AddEventHandler("ynf_miner:remelting", function(item, amount)
    local _source = source
    local xPlayer  = QBCore.Functions.GetPlayer(_source)
        if xPlayer ~= nil then
            
            if xPlayer.Functions.GetItemByName('washed_stone').amount > 9 then
                TriggerClientEvent("ynf_miner:remelting", source)
                Citizen.Wait(15900)
                xPlayer.Functions.AddItem('maden_token', 5)
                xPlayer.Functions.RemoveItem("washed_stone", 10)
            elseif xPlayer.Functions.GetItemByName('washed_stone').amount < 10 then
                TriggerClientEvent("QBCore:Notify", _source, 'Üzerinde yeterli eritilmiş taş yok.', "error")
            end
        end
end)