local playersMoney = {
    [1] = {
        bank = 1000,
        cash = 500
    },
    [2] = {
        bank = 2000,
        cash = 1500
    },
    [3] = {
        bank = 3000,
        cash = 2500
    },
    [6] = {
        bank = 40400,
        cash = 324500
    },
}

Events.RegisterHttpEvent('getPlayerMoney', function(client, account, targetPlayer)
    if targetPlayer == nil then
        targetPlayer = client
    end

    local playerMoney = playersMoney[targetPlayer]
    if not playerMoney then
        return { success = false, error = 'Player not found' }
    end

    local amount = playerMoney[account]
    if not amount then
        return { success = false, error = 'Account not found' }
    end

    return { success = true, amount = amount }
end)
