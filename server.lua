local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while true do
        Wait(60000) 
        MySQL.Async.execute('DELETE FROM restraining_orders WHERE expiration_time <= NOW()', {}, function(affectedRows)
            if affectedRows > 0 then
                print(('Deleted %d expired restraining orders.'):format(affectedRows))
            end
        end)
        MySQL.Async.execute('DELETE FROM trespassing_orders WHERE expiration_time <= NOW()', {}, function(affectedRows)
            if affectedRows > 0 then
                print(('Deleted %d expired trespassing orders.'):format(affectedRows))
            end
        end)
    end
end)

RegisterCommand('restrainingorders', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'police' then
        TriggerClientEvent('restrainingOrders:openMenu', source)
    else
        lib.notify({
            title = 'Access Denied',
            description = 'Only police officers can use this command!',
            type = 'error'
        })
    end
end, false)

RegisterNetEvent('restrainingOrders:newOrder', function(data)
    local src = source
    local makerId = data.maker
    local targetId = data.target
    local duration = data.duration
    local distance = data.distance or 100

    local maker = QBCore.Functions.GetPlayer(makerId)
    local target = QBCore.Functions.GetPlayer(targetId)

    if maker and target then
        local makerCid = maker.PlayerData.citizenid
        local makerName = maker.PlayerData.charinfo.firstname .. " " .. maker.PlayerData.charinfo.lastname
        local targetCid = target.PlayerData.citizenid
        local targetName = target.PlayerData.charinfo.firstname .. " " .. target.PlayerData.charinfo.lastname
        local expirationTime = os.date('%Y-%m-%d %H:%M:%S', os.time() + (duration * 86400))

        MySQL.Async.insert(
            'INSERT INTO restraining_orders (maker_cid, target_cid, maker_name, target_name, duration, expiration_time, distance) VALUES (?, ?, ?, ?, ?, ?, ?)',
            {makerCid, targetCid, makerName, targetName, duration, expirationTime, distance},
            function()
                TriggerClientEvent('lib.notify', src, { title = 'Success', description = 'Restraining order created!', type = 'success' })
            end
        )
    else
        TriggerClientEvent('lib.notify', src, { title = 'Error', description = 'Invalid player IDs provided!', type = 'error' })
    end
end)

RegisterNetEvent('restrainingOrders:fetchOrders', function()
    local src = source
    MySQL.Async.fetchAll('SELECT maker_name, target_name, duration, distance FROM restraining_orders', {}, function(results)
        TriggerClientEvent('restrainingOrders:displayOrders', src, results)
    end)
end)

RegisterCommand('trespassingorders', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'police' then
        TriggerClientEvent('trespassingOrders:openMenu', source)
    else
        lib.notify({
            title = 'Access Denied',
            description = 'Only police officers can use this command!',
            type = 'error'
        })
    end
end, false)

RegisterNetEvent('trespassingOrders:newOrder', function(data)
    local src = source
    local playerId = data.player_id
    local businessName = data.business_name
    local duration = data.duration
    local distance = data.distance or 100

    local target = QBCore.Functions.GetPlayer(playerId)

    if target then
        local playerCid = target.PlayerData.citizenid
        local playerName = target.PlayerData.charinfo.firstname .. " " .. target.PlayerData.charinfo.lastname
        local expirationTime = os.date('%Y-%m-%d %H:%M:%S', os.time() + (duration * 86400))

        MySQL.Async.insert(
            'INSERT INTO trespassing_orders (business_name, player_cid, player_name, duration, expiration_time, distance) VALUES (?, ?, ?, ?, ?, ?)',
            {businessName, playerCid, playerName, duration, expirationTime, distance},
            function()
                TriggerClientEvent('lib.notify', src, { title = 'Success', description = 'Trespassing order added!', type = 'success' })
            end
        )
    else
        TriggerClientEvent('lib.notify', src, { title = 'Error', description = 'Invalid player ID!', type = 'error' })
    end
end)

RegisterNetEvent('trespassingOrders:fetchOrders', function()
    local src = source
    MySQL.Async.fetchAll('SELECT business_name, player_name, duration, distance FROM trespassing_orders', {}, function(results)
        TriggerClientEvent('trespassingOrders:displayOrders', src, results)
    end)
end)