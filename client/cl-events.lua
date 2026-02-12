Events = {
    Key = nil
}

TriggerServerEvent('key')

RegisterNetEvent('key', function(key)
    Events.Key = key
end)

function Events.SendHttpEvent(eventName, ...)
    local p = promise.new()

    local requestId = tostring(GetGameTimer()) .. Events.Key
    SendNUIMessage({
        type = 'sendEvent',
        data = {
            endpoint = GetCurrentServerEndpoint(),
            resourceName = GetCurrentResourceName(),
            auth = Events.Key,
            eventName = eventName,
            requestId = requestId,
            args = json.encode({ ... })
        }
    })

    RegisterNuiCallback(requestId, function(data, cb)
        p:resolve(data)
        cb('ok')
    end)


    local yo = Citizen.Await(p)
    return yo
end

exports('SendHttpEvent', Events.SendHttpEvent)
