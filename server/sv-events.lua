Events = {
    Keys = {},
    Registered = {}
}

function Events.GenerateKey()
    local charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local key = ''
    for i = 1, 32 do
        local rand = math.random(1, #charset)
        key = key .. charset:sub(rand, rand)
    end

    return key
end

RegisterNetEvent('key', function()
    local client = source

    local key = Events.GenerateKey()
    Events.Keys[key] = client

    TriggerClientEvent('key', client, key)
end)

AddEventHandler('playerDropped', function()
    local client = source

    for key, c in pairs(Events.Keys) do
        if c == client then
            Events.Keys[key] = nil
            break
        end
    end
end)

function Events.RegisterHttpEvent(eventName, callback)
    Events.Registered[eventName] = function(client, ...)
        return callback(client, ...)
    end
end

function Events.CreateHttpServer()
    SetHttpHandler(function(request, response)
        if request.method ~= 'POST' then
            response.writeHead(404)
            response.send(
                'Not Found'
            )
            return
        end

        local client = Events.Keys[request.headers.Authorization]
        if not client then
            response.writeHead(401)
            response.send(
                'Unauthorized'
            )
            return
        end

        local p = promise.new()
        request.setDataHandler(function(data)
            p:resolve(data)
        end)

        local data = Citizen.Await(p)

        local eventName = request.path:sub(8)
        local eventHandler = Events.Registered[eventName]
        if not eventHandler then
            response.writeHead(404)
            response.send(
                'Event Not Implemented'
            )
            return
        end

        local args = json.decode(data)
        local res = eventHandler(client, table.unpack(args))

        response.writeHead(200, { ['Content-Type'] = 'application/json' })
        response.send(json.encode(res))
    end)
end

Events.CreateHttpServer()
