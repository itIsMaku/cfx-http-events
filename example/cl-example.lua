RegisterCommand('money', function()
    local myMoney = Events.SendHttpEvent('getPlayerMoney', 'bank')
    if myMoney.success then
        print(('You have %d in the bank'):format(myMoney.amount))
    else
        print(('Failed to get your money: %s'):format(myMoney.error))
    end

    local anotherPlayerId = 5
    local anotherPlayerMoney = Events.SendHttpEvent('getPlayerMoney', 'bank', anotherPlayerId)
    if anotherPlayerMoney.success then
        print(('Player %d has %d in the bank'):format(anotherPlayerId, anotherPlayerMoney.amount))
    else
        print(('Failed to get money for player %d: %s'):format(anotherPlayerId, anotherPlayerMoney.error))
    end
end, false)
