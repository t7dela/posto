---[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

local db = dbConnect('sqlite', 'stations.sqlite')
dbExec(db, 'Create table if not exists stations(owner TEXT, name TEXT, price INTEGER, liter INTEGER, stock REAL, meta INTEGER)')
dbExec(db, 'Create table if not exists statistics(name TEXT, money INTEGER, spending INTEGER, customers INTEGER)')
dbExec(db, 'Create table if not exists employees(name TEXT, employe_name TEXT, employe_user TEXT, employe_id INTEGER)')
dbExec(db, 'Create table if not exists balances(name TEXT, balance INTEGER, withdrawn_period INTEGER, withdrawn INTEGER)')
dbExec(db, 'Create table if not exists registers(name TEXT, monday TEXT, tuesday TEXT, wednesday TEXT, thursday TEXT, friday TEXT, saturday TEXT, sunday TEXT, updated TEXT)')
dbExec(db, 'Create table if not exists logs(name TEXT, logs TEXT)')

local gas_stations = {}
local stationBlips = {}
for index, v in ipairs(config.gas_stations) do 
    -- cria apenas 1 blip por posto
    stationBlips[v.name] = createBlip(
    v.position_management[1],
    v.position_management[2],
    v.position_management[3],
    config.blips.refuel
)
setBlipVisibleDistance(stationBlips[v.name], 100)
setElementData(stationBlips[v.name], "blipName", v.name)

    for i, value in ipairs(v.position_refuel) do 
        gas_stations[i] = createMarker(Vector3(unpack(v.position_refuel[i])), 'cylinder', 1.5, 255, 255, 255, 0)
        setElementData(gas_stations[i], 'markerData', {title = 'Bomba de Gasolina', desc = 'Abasteca seu carro aqui!', icon = 'tankTruck'})
        setElementData(gas_stations[i], 'marker_custom', config.markers_ids.refuel)

        addEventHandler('onMarkerHit', gas_stations[i], 
            function(player)
                if (isElement(player) and getElementType(player) == 'player' and isPedInVehicle(player)) then 
                    if (getStationOwner(v.name)) then 
                        if (getLiterPrice(v.name)) then 
                            triggerClientEvent(player, 'onClientDrawRefuel', player, v.name, getLiterPrice(v.name))
                        else
                            message(player, 'CONTATE A ADMINISTRAÇÃO E RELATE ESSE ERRO!!!!', 'error')
                        end
                    else
                        message(player, 'Esse estabelecimento ainda não foi comprado!', 'error') 
                    end
                end
            end
        )
    end
end

local management_stations = {}
for i, v in ipairs(config.gas_stations) do 
    management_stations[i] = createMarker(Vector3(unpack(v.position_management)), 'cylinder', 1.5, 255, 255, 255, 0)
    setElementData(management_stations[i], 'markerData', {title = 'Gerenciamento Posto', desc = 'Gerencie aqui o seu posto!', icon = 'licenceTheory'})
    local stationBlips = {}
    setElementData(management_stations[i], 'marker_custom', config.markers_ids.management)

    addEventHandler('onMarkerHit', management_stations[i], 
        function(player)
            if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 
                if (getStationOwner(v.name)) then 
                    if (getStationOwner(v.name) == getAccountName(getPlayerAccount(player))) then 
                        triggerClientEvent(player, 'onClientDrawManagement', player, v.name, {getStationStatistics(v.name)}, getStationStock(v.name), getLiterPrice(v.name), getStationBalance(v.name), getStationWithdrawn(v.name), getRegisters(v.name), getStationEmployees(v.name), false, getStationWeekResult(v.name), getStationMeta(v.name))
                        message(player, 'Bem vindo ao painel de gerenciamento do posto: '..v.name..'.', 'success')
                    elseif (isPlayerEmploye(player, v.name)) then 
                        triggerClientEvent(player, 'onClientDrawManagement', player, v.name, {getStationStatistics(v.name)}, getStationStock(v.name), getLiterPrice(v.name), getStationBalance(v.name), getStationWithdrawn(v.name), getRegisters(v.name), getStationEmployees(v.name), true)
                        message(player, 'Bem vindo ao painel de gerenciamento do posto: '..v.name..'.', 'success')
                    else
                        message(player, 'Você não trabalha na empresa!', 'error')
                    end
                else
                    triggerClientEvent(player, 'onClientDrawBuyStation', player, v.name, v.price)
                end
            end
        end
    )
end

addEvent('onPlayerRefuelVehicle', true)
addEventHandler('onPlayerRefuelVehicle', root, 
    function(player, liters, station)
        if (liters > 0) then 
            local price = getLiterPrice(station)
            local price = (price * liters)  
            if (getPlayerMoney(player) >= tonumber(price)) then 
                local vehicle = getPedOccupiedVehicle(player)
                if (isElement(vehicle)) then 
                    local fuel = (getElementData(vehicle, 'JOAO.fuel') or 100)
                    local gasoline_needed = (100 - (getElementData(vehicle, 'JOAO.fuel') or 100))
                    if (liters <= gasoline_needed) then 
                        local stock = getStationStock(station) 
                        if (stock and stock >= liters) then 
                            local money, spending, customers = getStationStatistics(station)
                            takePlayerMoney(player, tonumber(price))
                            setElementData(vehicle, 'JOAO.fuel', (fuel + liters))
                            dbExec(db, 'Update stations set stock = ? where name = ?', (stock - liters), station)
                            dbExec(db, 'Update statistics set money = ?, customers = ? where name = ?', (money + price), (customers + 1), station)
                            local balance = getStationBalance(station)
                            dbExec(db, 'Update balances set balance = ? where name = ?', (balance + tonumber(price)), station)
                            addWeekDayValue(station, tonumber(price))
                            message(player, 'Você colocou '..liters..' litros de gasolina em seu veiculo!', 'success')
                        else
                            message(player, 'O posto não tem essa quantidade de gasolina!', 'error')
                        end
                    elseif (gasoline_needed <= 0) then 
                        message(player, 'Seu tanque já está cheio!', 'error')
                    else 
                        message(player, 'Você precisa de apenas '..gasoline_needed..' litros para abastecer seu tanque!', 'error') 
                    end 
                else
                    message(player, 'Seu veiculo não foi identificado!', 'error')
                end
            else 
                message(player, 'Você não tem dinheiro suficiente!', 'error')
            end
        else
            message(player, 'Coloque uma quantidade maior que 0!', 'error')
        end
    end
)

addEvent('onPlayerBuyStation', true)
addEventHandler('onPlayerBuyStation', root, 
    function(player, station, price) 
        if not (getStationOwner(station)) then 
            if (getPlayerMoney(player) >= tonumber(price)) then 
                local time = getRealTime()
                local timestamp = time.timestamp
                local withdrawn_period = timestamp + (30 * 86400)
                takePlayerMoney(player, tonumber(price))
                triggerClientEvent(player, 'onClientRemoveBuyStation', player)
                dbExec(db, 'Insert into stations (owner, name, price, liter, stock, meta) Values(?, ?, ?, ?, ?, ?)', getAccountName(getPlayerAccount(player)), station, config.geral.max_price, config.geral.liter_price_default, 0, 1000)
                dbExec(db, 'Insert into statistics (name, money, spending, customers) Values(?, ?, ?, ?)', station, 0, 0, 0)
                dbExec(db, 'Insert into balances(name, balance, withdrawn_period, withdrawn) Values(?, ?, ?, ?)', station, 0, withdrawn_period, 0)
                dbExec(db, 'Insert into registers(name, monday, tuesday, wednesday, thursday, friday, saturday, sunday) Values(?, ?, ?, ?, ?, ?, ?, ?)', station, toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}))

                message(player, 'Você adquiriu o estabelecimento: '..station..'.', 'success')
            else 
                message(player, 'Você não tem dinheiro suficiente!', 'error')
            end
        else
            message(player, 'Esse posto de gasolina já tem um dono!', 'error')
        end
    end
)

addEvent('onPlayerChangePriceByLiter', true)
addEventHandler('onPlayerChangePriceByLiter', root, 
    function(player, station, price)
        local actualy_price = getLiterPrice(station) 
        if (actualy_price ~= price) then 
            dbExec(db, 'Update stations set price = ? where name = ?', tonumber(price), station)
            message(player, 'Preço do litro foi alterado com sucesso!', 'success')
        else
            message(player, 'O preço do litro já é esse!', 'error')
        end
    end 
)

addEvent('onPlayerChangeMeta', true)
addEventHandler('onPlayerChangeMeta', root, 
    function(player, station, meta) 
        if (tonumber(meta) and tonumber(meta) <= config.geral.max_meta) then 
            dbExec(db, 'Update stations set meta = ? where name = ?', tonumber(meta), station)
            triggerClientEvent(player, 'onClientReceiveMeta', player, tonumber(meta))
            message(player, 'Você estipulou uma nova meta!', 'success')
        else
            message(player, 'A meta máxima a ser declarada é R$'..config.geral.max_meta, 'error')
        end
    end
)

local delay = {}
addEvent('onPlayerDepositGasoline', true) 
addEventHandler('onPlayerDepositGasoline', root, 
    function(player, station, amount)
        if tonumber(amount) then 
            if getPlayerMoney(player) >= tonumber(amount) then 
                if not isTimer(delay[player]) then 
                    local balance = getStationBalance(station)
                    takePlayerMoney(player, tonumber(amount)) 
                    dbExec(db, 'Update balances set balance = ? where name = ?', (balance + tonumber(amount)), station)
                    triggerClientEvent(player, 'onClientReceiveBalance', player, (balance + tonumber(amount)))

                    message(player, 'Você efetuou um deposito de R$'..amount..'!', 'success')
                    addRegister(station, getPlayerName(player), 'DEPOSITO', 'R$'..tonumber(amount))
                    local logs = getRegisters(station)
                    triggerClientEvent(player, 'onClientReceiveLogs', player, logs)
                    delay[player] = setTimer(function() end, (config.geral.delay_operation * 1000), 1)
                else 
                    message(player, 'Você interagiu com o cofre recentemente, espere um pouco!', 'error')
                end
            else 
                message(player, 'Você não tem essa quantia em dinheiro!', 'error')
            end
        else 
            message(player, 'Digite uma quantia válida!', 'error')
        end
    end
)

addEvent('onPlayerWithdrawGasoline', true) 
addEventHandler('onPlayerWithdrawGasoline', root, 
    function(player, station, amount)
        if tonumber(amount) then 
            local balance, withdrawn = getStationBalance(station), getStationWithdrawn(station)
            if (balance ~= 0) then 
                if tonumber(balance) >= tonumber(amount) then 
                    if not isTimer(delay[player]) then 
                        givePlayerMoney(player, tonumber(amount)) 
                        dbExec(db, 'Update balances set balance = ?, withdrawn = ? where name = ?', (balance - tonumber(amount)), (withdrawn + tonumber(amount)), station)
                        triggerClientEvent(player, 'onClientReceiveBalance', player, (balance - tonumber(amount)), (withdrawn + tonumber(amount)))
                        
                        message(player, 'Você efetuou um deposito de R$'..amount..'!', 'success')
                        addRegister(station, getPlayerName(player), 'SAQUE', 'R$'..tonumber(amount))
                        local logs = getRegisters(station)
                        triggerClientEvent(player, 'onClientReceiveLogs', player, logs)
                        delay[player] = setTimer(function() end, 15000, 1)
                    else 
                        message(player, 'Você interagiu com o cofre recentemente, espere um pouco!', 'error')
                    end
                else 
                    message(player, 'O posto não tem essa quantia em dinheiro!', 'error')
                end
            else
                message(player, 'Algo deu errado, tente novamente!', 'error')
            end
        else 
            message(player, 'Digite uma quantia válida!', 'error')
        end
    end
)

addEvent('onPlayerInviteJob', true)
addEventHandler('onPlayerInviteJob', root, 
    function(player, station, id) 
        if (tonumber(id)) then 
            local receiver = getPlayerFromID(tonumber(id)) 
            if (isElement(receiver)) then 
                if (#dbPoll(dbQuery(db, 'Select * from employees where employe_id = ?', tonumber(id)), -1) == 0) then 
                    message(player, 'Você convidou o cidadão para se tornar funcionário do posto!', 'success')
                    triggerClientEvent(receiver, 'onClientDrawInvite', receiver, station)
                else
                    message(player, 'Cidadão já está contratado em outro estabelecimento!', 'error')
                end
            else
                message(player, 'Cidadão não encontrado!', 'error')
            end
        else
            message(player, 'Digite um id válido!', 'error')
        end
    end
)

addEvent('onPlayerDismiss', true)
addEventHandler('onPlayerDismiss', root, 
    function(player, station, user)
        dbExec(db, 'Delete from employees where employe_user = ? and name = ?',  user, station)
        triggerClientEvent(player, 'onClientReceiveEmployees', player, getStationEmployees(station))
        message(player, 'Você demitiu esse funcionário!', 'success')
    end
)

addEvent('onPlayerAcceptJob', true)
addEventHandler('onPlayerAcceptJob', root, 
    function(player, station)
        if (#dbPoll(dbQuery(db, 'Select * from employees where employe_id = ?', tonumber(getElementData(player,  'ID'))), -1) == 0) then  
            dbExec(db, 'Insert into employees(name, employe_name, employe_user, employe_id) Values(?, ?, ?, ?)', station, getPlayerName(player), getAccountName(getPlayerAccount(player)), getElementData(player,  'ID'))
            message(player, 'Você aceitou a oferta de trabalho em '..station, 'info')

            for i, v in ipairs(getElementsByType('player')) do 
                if (getStationOwner(station) == getAccountName(getPlayerAccount(v))) then  
                    triggerClientEvent(v, 'onClientReceiveEmployees', v, getStationEmployees(station))
                end
            end
        else
            message(player, 'Você já trabalha em um posto!', 'error')
        end
    end
)

local rotes_liters = {
    [1] = 100;
    [2] = 500; 
    [3] = 900; 
}

local vehicle, trailer, actualy_rote, colect, delivery, blip, player_data = {}, {}, {}, {}, {}, {}, {}

addEvent('onPlayerStartRote', true) 
addEventHandler('onPlayerStartRote', root, 
    function(player, station, rote)  
        local balance, withdrawn, price = getStationBalance(station), getStationWithdrawn(station), config.rotes_prices[rote]
        if tonumber(balance) >= tonumber(price) then 
            if not (actualy_rote[player]) then 
                local stock = getStationStock(station) 
                if ((stock + rotes_liters[rote]) <= 1000) then 
                    dbExec(db, 'Update statistics set spending = ? where name = ?', getStationSpending(station) + price, station)
                    dbExec(db, 'Update balances set balance = ?, withdrawn = ? where name = ?', (balance - tonumber(price)), (withdrawn + tonumber(price)), station)
                    triggerClientEvent(player, 'onClientRemoveManagement', player)
                    message(player, 'Você começou uma rota!', 'success')
                    addRegister(station, getPlayerName(player), 'ROTA', 'R$ '..tonumber(price))
                    startRote(player, station, rote)
                else
                    message(player, 'O posto não precisa dessa quantidade de litros para abastecer!', 'error')
                end 
            else
                message(player, 'Você já tem uma rota em andamento!', 'error')
            end
        else 
            message(player, 'O posto não tem essa quantia em dinheiro!', 'error')
        end
    end
)

function startRote(player, station, rote) 
    deleteRote(player)
    message(player, 'Você começou uma rota, siga a marcação em seu mapa para pegar sua carga!', 'info')
    local data = getStationData(station)
    player_data[player] = data
    vehicle[player] = createVehicle(config.truck.model, unpack(data.rote_spawn))
    warpPedIntoVehicle(player, vehicle[player]) 
    actualy_rote[player] = rote 

    addEventHandler('onElementDestroy', vehicle[player], 
        function()
            if (actualy_rote[player]) then 
                deleteRote(player) 
                triggerClientEvent(player, "JOAO.removeMarcadorJobs", player)
            end
        end
    )

    triggerClientEvent(player, "JOAO.marcadorJobs", player, data.rotes[rote].colect[1], data.rotes[rote].colect[2], data.rotes[rote].colect[3], 0, 0, "Rota de posto")

    colect[player] = createMarker(Vector3(unpack(data.rotes[rote].colect)), 'checkpoint', 4, r, g, b, a)
    blip[player] = createBlipAttachedTo(colect[player])
end

addEventHandler('onPlayerMarkerHit', root, 
    function(marker, dimension) 
        if (dimension) then 
            if (isElement(colect[source]) and marker == colect[source]) then 
                destroyElement(colect[source])
                if (isElement(blip[source])) then 
                    destroyElement(blip[source])
                end
            
                local x, y, z = getElementPosition(source)
                trailer[source] = createVehicle (config.truck.trailer, x + 2, y, z)  
                attachTrailerToVehicle(vehicle[source], trailer[source])
            
                addEventHandler('onElementDestroy', trailer[source], 
                    function()
                        if (actualy_rote[source]) then 
                            deleteRote(source) 
                            message(source, 'Você destruiu sua carga e falhou na rota!', 'error')
                            triggerClientEvent(source, "JOAO.removeMarcadorJobs", source)
                        end
                    end
                )
                
                triggerClientEvent(source, "JOAO.marcadorJobs", source, player_data[source].rotes[actualy_rote[source]].delivery[1], player_data[source].rotes[actualy_rote[source]].delivery[2], player_data[source].rotes[actualy_rote[source]].delivery[3], 0, 0, "Descarregamento Posto")
                delivery[source] = createMarker(Vector3(unpack(player_data[source].rotes[actualy_rote[source]].delivery)), 'checkpoint', 4, r, g, b, a)
                blip[source] = createBlipAttachedTo(delivery[source]) 
            elseif (isElement(delivery[source]) and marker == delivery[source]) then

                local stock = getStationStock(player_data[source].name) 
                if ((stock + rotes_liters[actualy_rote[source]]) <= 1000) then 
                    dbExec(db, 'Update stations set stock = ? where name = ?', (stock + rotes_liters[actualy_rote[source]]), player_data[source].name) 
                else
                    dbExec(db, 'Update stations set stock = ? where name = ?', 1000, player_data[source].name) 
                end

                if (isPlayerEmploye(source, player_data[source].name)) then 
                    givePlayerMoney(source, (config.rotes_prices[actualy_rote[source]] / 100) * config.rote_percentage)
                end

                message(source, 'Você completou a rota e abasteceu o estoque do posto!', 'success')
                triggerClientEvent(source, "JOAO.removeMarcadorJobs", source)
                deleteRote(source) 
            end
        end
    end
)

function deleteRote(player)
    if player and isElement(player) and actualy_rote[player] then
        actualy_rote[player] = {}
        if (vehicle[player] and isElement(vehicle[player])) then 
            destroyElement(vehicle[player]) 
        end

        if (trailer[player] and isElement(trailer[player])) then 
            destroyElement(trailer[player]) 
        end

        if (colect[player] and isElement(colect[player])) then 
            destroyElement(colect[player]) 
        end

        if (delivery[player] and isElement(delivery[player])) then 
            destroyElement(delivery[player]) 
        end

        if (blip[player] and isElement(blip[player])) then 
            destroyElement(blip[player])        
        end
    end
end

addEventHandler('onPlayerQuit', root, 
    function()
        deleteRote(source)
    end
)

addEventHandler('onPlayerWasted', root, 
    function()
        deleteRote(source)
    end
)

emergencyVeh = {
    [416] = true,
    [596] = true,
    [597] = true,
    [598] = true,
    [523] = true,
    [525] = true,
}

function setGas()
	if source and isElement(source) and not getElementData(source, "JOAO.fuel") then
		setElementData(source, "JOAO.fuel", 100)
	end
    local gas = getElementData(source, "JOAO.fuel") or 0
	if tonumber(gas) <= 1 then
		setVehicleEngineState(source, false)
	end
end
addEventHandler("onVehicleEnter", root, setGas)

function refreshGas()
	for i, v in pairs(getElementsByType("vehicle")) do
        if getVehicleType(v) == "Automobile" or getVehicleType(v) == "Bike" then
            if not emergencyVeh[getElementModel(v)] then
                if getVehicleEngineState(v) == true then
                    if getElementVelocity(v) ~= 0 then
                        local gas = getElementData(v, "JOAO.fuel") or 100
                        if gas > 100 then 
                            setElementData(v, "JOAO.fuel", 100)
                        else 
                            setElementData(v, "JOAO.fuel", gas - 4)
                        end 
                        
                    else
                        local gas = getElementData(v, "JOAO.fuel") or 100
                        if gas > 100 then 
                            setElementData(v, "JOAO.fuel", 100)
                        else 
                            setElementData(v, "JOAO.fuel", gas - 2)
                        end 
                        
                    end
                    if getElementData(v, "JOAO.fuel") <= 0 then
                        setVehicleEngineState(v, false)
                        local driver = getVehicleController(v)
                        if isElement(driver) then
                            message(driver, "Seu veículo ficou sem gasolina", "info")
                        end
                    end
                end
            else
                if getVehicleEngineState(v) == true then
                    if getElementVelocity(v) ~= 0 then
                        local gas = getElementData(v, "JOAO.fuel") or 100
                        if gas > 100 then 
                            setElementData(v, "JOAO.fuel", 100)
                        else 
                            setElementData(v, "JOAO.fuel", gas - 2)
                        end 
                        
                    else
                        local gas = getElementData(v, "JOAO.fuel") or 100
                        if gas > 100 then 
                            setElementData(v, "JOAO.fuel", 100)
                        else 
                            setElementData(v, "JOAO.fuel", gas - 1)
                        end 
                    end
                    if getElementData(v, "JOAO.fuel") <= 0 then
                        setVehicleEngineState(v, false)
                        local driver = getVehicleController(v)
                        if isElement(driver) then
                            message(driver, "Seu veículo ficou sem gasolina", "info")
                        end
                    end
                end
            end
        end
	end
end

setTimer(refreshGas, 60000, 0)

setTimer(function()
    for i, v in ipairs(dbPoll(dbQuery(db, 'Select * from balances'), -1)) do
        local time = getRealTime()
        local timestamp = time.timestamp 
        if (timestamp >= v['withdrawn_period']) then 
            dbExec(db, 'Update balances set withdrawn_period = ?, withdrawn = ? where name = ?', timestamp + (30 * 86400), 0, v['name'])
        end
    end

    for i, v in ipairs(dbPoll(dbQuery(db, 'Select * from registers'), -1)) do
        local time = getRealTime() 
        local weekday = time.weekday
        if (weekday == 1) then 
            if not (v['updated']) then 
                dbExec(db, 'Update registers set monday = ?, tuesday = ?, wednesday = ?, thursday = ?, friday = ?, saturday = ?, sunday = ?, updated = ?', toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), toJSON({0, 0, 0}), 'Sim')
            end
        else
            dbExec(db, 'Update registers set updated = ?', nil)
        end
    end
end, 1000, 0)

function addWeekDayValue(station, value)
    local data = dbPoll(dbQuery(db, 'Select * from registers where name = ?', station), -1)
    if (#data ~= 0) then 
        local time = getRealTime() 
        local hour = time.hour 
        local weekday = time.weekday
        local weekday = week_day_values[weekday]
        local register = fromJSON(data[1][weekday]) 
        
        if (hour < 8) then 
            register[1] = (register[1] + value)
        elseif (hour >= 8 and hour < 16) then 
            register[2] = (register[2] + value)
        elseif (hour >= 16 and hour < 0) then 
            register[3] = (register[3] + value)
        end

        dbExec(db, 'Update registers set '..weekday..' = ? where name = ?', toJSON(register), station)
    end 
end

function getStationWeekResult(station)
    return dbPoll(dbQuery(db, 'Select * from registers where name = ?', station), -1)
end

function addRegister(station, name, action, value) 
    local request = dbPoll(dbQuery(db, 'Select * from logs where name = ?', station), -1)
    if #request ~= 0 then 
        local logs = fromJSON(request[1]['logs']) 
        table.insert(logs, {name, action, value})
        dbExec(db, 'Update logs set logs = ? where name = ?', toJSON(logs), station)
    else

        local logs = {
            {name, action, value}
        }

        dbExec(db, 'Insert into logs (name, logs) Values(?, ?)', station, toJSON(logs))
    end
end

function getRegisters(station) 
    local request = dbPoll(dbQuery(db, 'Select * from logs where name = ?', station), -1)
    if #request ~= 0 then 
        return fromJSON(request[1]['logs'])
    else
        return {}
    end
end

function getStationSpending(station) 
    local data = dbPoll(dbQuery(db, 'Select * from statistics where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['spending']
    end
end

function getStationBalance(station)
    local data = dbPoll(dbQuery(db, 'Select * from balances where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['balance']
    end
end

function getStationWithdrawn(station)
    local data = dbPoll(dbQuery(db, 'Select * from balances where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['withdrawn']
    end
end

function getStationOwner(station)
    local data = dbPoll(dbQuery(db, 'Select * from stations where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['owner']
    end
end

function getStationMeta(station) 
    local data = dbPoll(dbQuery(db, 'Select * from stations where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['meta']
    end
end 

function getStationStock(station)
    local data = dbPoll(dbQuery(db, 'Select * from stations where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['stock']
    end
end

function getLiterPrice(station)
    local data = dbPoll(dbQuery(db, 'Select * from stations where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['price']
    end
end

function getStationData(station) 
    for i, v in ipairs(config.gas_stations) do 
        if (v.name == station) then 
            return v
        end
    end
end

function isPlayerEmploye(player, station)
    if (#dbPoll(dbQuery(db, 'Select * from employees where employe_id = ? and name = ?', getElementData(player, 'ID'), station), -1) ~= 0) then 
        return true 
    else
        return false 
    end
end 

function getStationStatistics(station)
    local data = dbPoll(dbQuery(db, 'Select * from statistics where name = ?', station), -1) 
    if (#data ~= 0) then 
        return data[1]['money'], data[1]['spending'], data[1]['customers']
    end
end

function getStationEmployees(station)
    return dbPoll(dbQuery(db, 'Select * from employees where name = ?', station), -1)
end