# cfx-http-events

A FiveM/RedM resource that enables **synchronous HTTP-based events** between client and server with return values. Unlike native CitizenFX events, this library allows you to call server-side functions from the client and **receive a response** directly.

## Features

- **Synchronous client-to-server communication** - Call server events and get return values
- **Secure authentication** - Each client receives a unique 32-character key
- **Promise-based** - Uses Citizen.Await for clean async/await style code
- **Works with GTA5 and RDR3** - Compatible with both FiveM and RedM

## Installation

1. Download or clone this repository into your `resources` folder
2. Rename to `maku_httpevents` (or your preferred name)
3. Add `ensure maku_httpevents` to your `server.cfg`
4. Remove the example scripts from `fxmanifest.lua` if not needed

## Usage

### Server-side: Register HTTP Events

```lua
Events.RegisterHttpEvent('eventName', function(client, arg1, arg2, ...)
    -- client = source (player server ID)
    -- Return any value to send back to the client
    return { success = true, data = "Hello from server!" }
    return "Hello, I am example of random value u can return :)"
end)
```

### Client-side: Call HTTP Events

```lua
local response = Events.SendHttpEvent('eventName', arg1, arg2, ...)
print(response.data) -- "Hello from server!"
print(response) -- "Hello, I am example of random value u can return :)"
```

## Example

### Server (`sv-example.lua`)

```lua
Events.RegisterHttpEvent('getPlayerMoney', function(client, account, targetPlayer)
    if targetPlayer == nil then
        targetPlayer = client
    end

    local playerMoney = GetPlayerMoney(targetPlayer) -- Your money system
    if not playerMoney then
        return { success = false, error = 'Player not found' }
    end

    return { success = true, amount = playerMoney[account] }
end)
```

### Client (`cl-example.lua`)

```lua
RegisterCommand('money', function()
    local myMoney = Events.SendHttpEvent('getPlayerMoney', 'bank')
    if myMoney.success then
        print(('You have $%d in the bank'):format(myMoney.amount))
    else
        print(('Failed to get money: %s'):format(myMoney.error))
    end
end, false)
```

## How It Works

1. When a client connects, they request a unique authentication key from the server
2. The server generates a 32-character random key and stores it with the client's source ID
3. When `Events.SendHttpEvent()` is called, it sends an HTTP POST request to the server via NUI
4. The server validates the auth key, executes the registered handler, and returns JSON
5. The response is passed back to the client through NUI callbacks

## API Reference

### Server

| Function                                   | Description                                                 |
| ------------------------------------------ | ----------------------------------------------------------- |
| `Events.RegisterHttpEvent(name, callback)` | Register a server-side event handler that can return values |

### Client

| Function                          | Description                                   |
| --------------------------------- | --------------------------------------------- |
| `Events.SendHttpEvent(name, ...)` | Call a server event and wait for the response |

## Security Notes

- Each player receives a unique authentication key on connect
- Keys are automatically removed when players disconnect
- Only POST requests are accepted
- Authorization header is required for all requests

## Requirements

- FiveM or RedM server
- No external dependencies
