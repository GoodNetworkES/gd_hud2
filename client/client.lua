local inCar, isReady, cinemaMode, hudVisible = false, nil, false, true
local before, ESX, QBCore = {}, nil, nil

CreateThread(function()
    while not ESX and not QBCore do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        QBCore = exports['qb-core']:GetCoreObject()
        Wait(500)
    end
    Wait(2000)
end)

RegisterNetEvent("hud:forceUpdate")
AddEventHandler("hud:forceUpdate", function()
    local p = PlayerPedId()
    local h, a = GetEntityHealth(p) - 100, GetPedArmour(p)
    local f, w
    if ESX then
        TriggerEvent('esx_status:getStatus', 'hunger', function(s) f = s.val / 10000 end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(s) w = s.val / 10000 end)
    elseif QBCore then
        local d = QBCore.Functions.GetPlayerData()
        f, w = d.metadata["hunger"] / 100, d.metadata["thirst"] / 100
    end
    while not f or not w do Wait(100) end
    isReady = true
    SendNUIMessage({status = 'info', data = {health = math.max(0, h), armour = a, food = f * 100, water = w * 100}})
end)

RegisterNetEvent("QBCore:Player:SetPlayerData")
AddEventHandler("QBCore:Player:SetPlayerData", function(d)
    if d and d.metadata then
        SendNUIMessage({status = 'info', data = {food = d.metadata["hunger"] / 100 * 100, water = d.metadata["thirst"] / 100 * 100}})
    end
end)

CreateThread(function() 
    while true do 
        TriggerEvent("hud:forceUpdate")
        Wait(3000) 
    end 
end)

RegisterCommand(Config.CommandName, function() cinemaMode = not cinemaMode end, false)
RegisterCommand(Config.CommandNameHud, function()
    hudVisible = not hudVisible
    if not cinemaMode then SendNUIMessage({status = 'visible', data = hudVisible}) end
end, false)

CreateThread(function()
    while true do
        if cinemaMode then
            DrawRect(0.5, 0.0, 1.0, 0.25, 0, 0, 0, 255)
            DrawRect(0.5, 1.0, 1.0, 0.25, 0, 0, 0, 255)
            SendNUIMessage({status = 'visible', data = false})
            DisplayRadar(false)
        else
            SendNUIMessage({status = 'visible', data = hudVisible})
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        local p = PlayerPedId()
        local v = IsPedInAnyVehicle(p, false)
        DisplayRadar(v)
        DisplayHud(not v)
        Wait(v and 500 or 1000)
    end
end)

CreateThread(function()
    local wait = 1000
    while true do
        if before.ready ~= isReady then
            before.ready = isReady
            SendNUIMessage({status = 'visible', data = true})
        end
        local pause = IsPauseMenuActive()
        if pause ~= before.pause then
            SendNUIMessage({status = 'visible', data = not pause})
            before.pause = pause
        end
        local p = PlayerPedId()
        local v = IsPedInAnyVehicle(p, false)
        if v then
            local veh = GetVehiclePedIsIn(p)
            if GetPedInVehicleSeat(veh, -1) == p then
                local fuel, speed, engine = GetVehicleFuelLevel(veh), GetEntitySpeed(veh) * 3.6, GetVehicleEngineHealth(veh) / 10
                if speed > 1 then
                    if fuel ~= before.fuel or speed ~= before.speed or engine ~= before.engine then
                        before.fuel, before.speed, before.engine = fuel, speed, engine
                        SendNUIMessage({status = 'speedometer', data = {visible = true, speed = speed, engine = engine, fuel = fuel, mph = false}})
                    end
                    before.speedometer_visible = true
                else
                    if before.speedometer_visible then
                        SendNUIMessage({status = 'speedometer', data = {visible = false}})
                        before.speedometer_visible = false
                    end
                end
                wait = 200
            end
        else
            if before.speedometer_visible then
                SendNUIMessage({status = 'speedometer', data = {visible = false}})
                before.speedometer_visible = false
            end
            wait = 1000
        end
        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        SendNUIMessage({action = NetworkIsPlayerTalking(PlayerId()) and 'showTalkingImage' or 'hideTalkingImage'})
    end
end)