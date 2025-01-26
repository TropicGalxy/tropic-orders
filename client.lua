local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('restrainingOrders:openMenu', function()
    lib.registerContext({
        id = 'restrainingOrders:menu',
        title = 'Restraining Orders',
        options = {
            {
                title = 'View Orders',
                icon = 'fa-solid fa-eye',
                onSelect = function()
                    TriggerServerEvent('restrainingOrders:fetchOrders')
                end
            },
            {
                title = 'New Order',
                icon = 'fa-solid fa-plus',
                onSelect = function()
                    local inputs = lib.inputDialog('Create New Restraining Order', {
                        { type = 'number', label = 'Maker Player ID', placeholder = 'Enter maker\'s player ID' },
                        { type = 'number', label = 'Target Player ID', placeholder = 'Enter target\'s player ID' },
                        { type = 'number', label = 'Duration (days)', placeholder = 'Enter duration in days' },
                        { type = 'number', label = 'Distance (feet)', placeholder = 'Enter distance in feet' }
                    })
                    if inputs and inputs[1] and inputs[2] and inputs[3] and inputs[4] then
                        local data = {
                            maker = tonumber(inputs[1]),
                            target = tonumber(inputs[2]),
                            duration = tonumber(inputs[3]),
                            distance = tonumber(inputs[4])
                        }
                        TriggerServerEvent('restrainingOrders:newOrder', data)
                    else
                        lib.notify({
                            type = 'error',
                            description = 'Input cancelled or invalid!',
                            duration = 5000
                        })
                    end
                end
            }
        },
    })
    lib.showContext('restrainingOrders:menu')
end)

RegisterNetEvent('restrainingOrders:displayOrders', function(orders)
    if not orders or #orders == 0 then
        lib.notify({
            title = 'Restraining Orders',
            description = 'No restraining orders found.',
            type = 'error'
        })
        return
    end

    local options = {}
    for _, order in ipairs(orders) do
        table.insert(options, {
            title = ('%s against %s'):format(order.maker_name, order.target_name),
            description = ('Duration: %d days\nDistance: %d feet'):format(order.duration, order.distance),
            icon = 'fa-solid fa-file'
        })
    end

    lib.registerContext({
        id = 'restrainingOrders:viewOrders',
        title = 'All Restraining Orders',
        options = options
    })
    lib.showContext('restrainingOrders:viewOrders')
end)

RegisterNetEvent('trespassingOrders:openMenu', function()
    lib.registerContext({
        id = 'trespassingOrders:menu',
        title = 'Trespassing Orders',
        options = {
            {
                title = 'View Orders',
                icon = 'fa-solid fa-eye',
                onSelect = function()
                    TriggerServerEvent('trespassingOrders:fetchOrders')
                end
            },
            {
                title = 'New Order',
                icon = 'fa-solid fa-plus',
                onSelect = function()
                    local inputs = lib.inputDialog('Create New Trespassing Order', {
                        { type = 'number', label = 'Player ID', placeholder = 'Enter player ID' },
                        { type = 'input', label = 'Business Name', placeholder = 'Enter business name' },
                        { type = 'number', label = 'Duration (days)', placeholder = 'Enter duration in days' },
                        { type = 'number', label = 'Distance (feet)', placeholder = 'Enter distance in feet' }
                    })
                    if inputs and inputs[1] and inputs[2] and inputs[3] and inputs[4] then
                        local data = {
                            player_id = tonumber(inputs[1]),
                            business_name = inputs[2],
                            duration = tonumber(inputs[3]),
                            distance = tonumber(inputs[4])
                        }
                        TriggerServerEvent('trespassingOrders:newOrder', data)
                    else
                        lib.notify({
                            type = 'error',
                            description = 'Input cancelled or invalid!',
                            duration = 5000
                        })
                    end
                end
            }
        },
    })
    lib.showContext('trespassingOrders:menu')
end)

RegisterNetEvent('trespassingOrders:displayOrders', function(orders)
    if not orders or #orders == 0 then
        lib.notify({
            title = 'Trespassing Orders',
            description = 'No trespassing orders found.',
            type = 'error'
        })
        return
    end

    local options = {}
    for _, order in ipairs(orders) do
        table.insert(options, {
            title = ('%s against %s'):format(order.business_name, order.player_name),
            description = ('Duration: %d days\nDistance: %d feet'):format(order.duration, order.distance),
            icon = 'fa-solid fa-store'
        })
    end

    lib.registerContext({
        id = 'trespassingOrders:viewOrders',
        title = 'All Trespassing Orders',
        options = options
    })
    lib.showContext('trespassingOrders:viewOrders')
end)