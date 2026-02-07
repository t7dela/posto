--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

x, y = guiGetScreenSize() 

local fonts = {
    ['refuel'] = {
        dxCreateFont('assets/fonts/bold.ttf', 15);
        dxCreateFont('assets/fonts/regular.ttf', 25);
        dxCreateFont('assets/fonts/medium.ttf', 25);
    };

    ['buy'] = {
        dxCreateFont('assets/fonts/bold.ttf', 25);
    };

    ['invite'] = {
        dxCreateFont('assets/fonts/bold.ttf', 15);
    };

    ['management'] = {
        dxCreateFont('assets/fonts/medium.ttf', 10);
        dxCreateFont('assets/fonts/regular.ttf', 25);
        dxCreateFont('assets/fonts/regular.ttf', 10);
        dxCreateFont('assets/fonts/regular.ttf', 15);
        dxCreateFont('assets/fonts/light.ttf', 15);
        dxCreateFont('assets/fonts/medium.ttf', 15);
        dxCreateFont('assets/fonts/light.ttf', 40);
        dxCreateFont('assets/fonts/medium.ttf', 13);
        dxCreateFont('assets/fonts/bold.ttf', 15);
        dxCreateFont('assets/fonts/light.ttf', 12);
        dxCreateFont('assets/fonts/medium.ttf', 7);
    };
}

function draw_refuel()
    local alpha = interpolateBetween(interpolate[1], 0, 0, interpolate[2], 0, 0, ((getTickCount() - tick) / 500), 'Linear')
    dxDrawImage(x / 2 - 186, y / 2 - 195, 372, 390, 'assets/refuel/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawImage(x / 2 - 146, y / 2 - 25, 292, 189, 'assets/refuel/buttons_layout.png', 0, 0, 0, tocolor(255, 255, 255, alpha))

    dxDrawImage(x / 2 - 146, y / 2 - 25, 292, 46, 'assets/refuel/fill_button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
    if (isMouseInPosition(x / 2 - 146, y / 2 - 25, 292, 46)) then 
        if not (fill_tick) then fill_tick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - fill_tick) / 500), 'Linear')
        dxDrawImage(x / 2 - 146, y / 2 - 25, 292, 46, 'assets/refuel/fill_button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
    else
        fill_tick = nil 
    end

    dxDrawImage(x / 2 - 146, y / 2 + 125, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
    if (isMouseInPosition(x / 2 - 146, y / 2 + 125, 144, 38)) then 
        if not (cancel_tick) then cancel_tick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - cancel_tick) / 500), 'Linear')
        dxDrawImage(x / 2 - 146, y / 2 + 125, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
    else
        cancel_tick = nil 
    end

    dxDrawImage(x / 2, y / 2 + 125, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
    if (isMouseInPosition(x / 2, y / 2 + 125, 144, 38)) then 
        if not (refuel_tick) then refuel_tick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - refuel_tick) / 500), 'Linear')
        dxDrawImage(x / 2, y / 2 + 125, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
    else
        refuel_tick = nil 
    end

    dxDrawText(station, x / 2 - (dxGetTextWidth(station, 1, fonts['refuel'][1]) / 2), y / 2 - 178, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['refuel'][1])
    dxDrawText('R$'..price..',00', (x / 2 + 129) - (dxGetTextWidth('R$'..price..',00', 1, fonts['refuel'][2])), y / 2 - 80, 0, 0, tocolor(14, 154, 247, alpha), 1, fonts['refuel'][2])

    dxDrawRectangle(x / 2 - 146, y / 2 + 103, 292, 9, tocolor(45, 48, 58, alpha))
    dxDrawRectangle(x / 2 - 146, y / 2 + 103, refuel_width, 9, tocolor(14, 154, 247, alpha))
    dxDrawImage((x / 2 - 146) + (refuel_width - 9.5), y / 2 + 97, 19, 19, 'assets/refuel/circle.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    local liters = math.round((refuel_width / 292) * 100) 
    dxDrawText(liters..' LITROS', (x / 2 + 128) - dxGetTextWidth(liters..' LITROS', 1, fonts['refuel'][3]), y / 2 + 44, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['refuel'][3])

    if (moving) then 
        local start, finish = (x / 2 - 146), (x / 2 + 145) 
        local cx = getCursorPosition()
        local mx = (x * cx)
        
        if (mx < start) then 
            refuel_width = 0 
        elseif (mx > finish) then 
            refuel_width = 292
        else 
            refuel_width = (mx - start)
        end
    end
end

addEventHandler('onClientClick', root, 
    function(b, s)
        if (isEventHandlerAdded('onClientRender', root, draw_refuel)) then 
            if (b == 'left' and s == 'down') then 
                if (isMouseInPosition(x / 2 - 146, y / 2 + 103, 292, 9)) then 
                    moving = true
                elseif (isMouseInPosition(x / 2 - 146, y / 2 - 25, 292, 46)) then 
                    local fuel = (100 - (getElementData(getPedOccupiedVehicle(localPlayer), 'fuel') or 100))
                    refuel_width = math.round((fuel / 100) * 292)
                elseif (isMouseInPosition(x / 2, y / 2 + 125, 144, 38)) then 
                    local liters = math.round((refuel_width / 292) * 100) 
                    triggerServerEvent('onPlayerRefuelVehicle', localPlayer, localPlayer, liters, station)
                elseif (isMouseInPosition(x / 2 - 146, y / 2 + 125, 144, 38)) then 
                    if (interpolate[1] == 0) then 
                        tick, interpolate = getTickCount(), {255, 0} 
                        showCursor(false) 
                        setTimer(function()
                            removeEventHandler('onClientRender', root, draw_refuel)
                        end, 500, 1)
                    end

                end
            elseif (b == 'left' and s == 'up') then 
                if (moving) then 
                    moving = nil 
                end
            end
        end
    end
)

addEvent('onClientDrawRefuel', true)
addEventHandler('onClientDrawRefuel', root, 
    function(station_, price_)
        if not (isEventHandlerAdded('onClientRender', root, draw_refuel)) then 
            tick, interpolate, station, price, refuel_width = getTickCount(), {0, 255}, station_, price_, 0
            addEventHandler('onClientRender', root, draw_refuel)
            showCursor(true)
        end
    end
)

bindKey('backspace', 'down', 
    function()
        if (isEventHandlerAdded('onClientRender', root, draw_refuel)) then 
            if (interpolate[1] == 0) then 
                tick, interpolate = getTickCount(), {255, 0} 
                showCursor(false) 
                setTimer(function()
                    removeEventHandler('onClientRender', root, draw_refuel)
                end, 500, 1)
            end
        end
    end
)

function draw_buyStation()
    local alpha = interpolateBetween(interpolate[1], 0, 0, interpolate[2], 0, 0, ((getTickCount() - tick) / 500), 'Linear')
    dxDrawImage(x / 2 - 213, y / 2 - 112, 426, 224, 'assets/buy/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('R$ '..price, x / 2 - (dxGetTextWidth('R$ '..price, 1, fonts['buy'][1]) / 2), y / 2 - 18, 0, 0, tocolor(14, 154, 247, alpha), 1, fonts['buy'][1])
    
    dxDrawImage(x / 2 - 146, y / 2 + 51, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
    if (isMouseInPosition(x / 2 - 146, y / 2 + 51, 144, 38)) then 
        if not (cancel_tick) then cancel_tick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - cancel_tick) / 500), 'Linear')
        dxDrawImage(x / 2 - 146, y / 2 + 51, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
    else
        cancel_tick = nil 
    end

    dxDrawImage(x / 2 + 1, y / 2 + 51, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
    if (isMouseInPosition(x / 2, y / 2 + 51, 144, 38)) then 
        if not (buy_tick) then buy_tick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - buy_tick) / 500), 'Linear')
        dxDrawImage(x / 2 + 1, y / 2 + 51, 144, 38, 'assets/button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
    else
        buy_tick = nil 
    end
end

addEventHandler('onClientClick', root, 
    function(b, s) 
        if (b == 'left' and s == 'down') then 
            if (isEventHandlerAdded('onClientRender', root, draw_buyStation)) then 
                if (isMouseInPosition(x / 2 - 146, y / 2 + 51, 144, 38)) then
                    if (interpolate[1] == 0) then 
                        tick, interpolate = getTickCount(), {255, 0}
                        showCursor(false) 
                        setTimer(function()
                            removeEventHandler('onClientRender', root, draw_buyStation)
                        end, 500, 1)      
                    end
                elseif (isMouseInPosition(x / 2, y / 2 + 51, 144, 38)) then
                    triggerServerEvent('onPlayerBuyStation', localPlayer, localPlayer, station, price)    
                end
            end
        end
    end
)

addEvent('onClientDrawBuyStation', true)
addEventHandler('onClientDrawBuyStation', root, 
    function(station_, price_)
        if not (isEventHandlerAdded('onClientRender', root, draw_buyStation)) then 
            tick, interpolate, price, station = getTickCount(), {0, 255}, price_, station_
            addEventHandler('onClientRender', root, draw_buyStation)
            showCursor(true) 
        else 
            if (interpolate[1] == 0) then 
                tick, interpolate = getTickCount(), {255, 0}
                showCursor(false) 
                setTimer(function()
                    removeEventHandler('onClientRender', root, draw_buyStation)
                end, 500, 1)      
            end
        end
    end
)

addEvent('onClientRemoveBuyStation', true)
addEventHandler('onClientRemoveBuyStation', root, 
    function()
        if (isEventHandlerAdded('onClientRender', root, draw_buyStation)) then 
            if (interpolate[1] == 0) then 
                tick, interpolate = getTickCount(), {255, 0}
                showCursor(false) 
                setTimer(function()
                    removeEventHandler('onClientRender', root, draw_buyStation)
                end, 500, 1)      
            end
        end
    end
)

local icons = {
    {x / 2 - 293, y / 2 - 230, 33, 33, 'statistics'};
    {x / 2 - 173, y / 2 - 230, 27, 33, 'finance'};
    {x / 2 - 83, y / 2 - 233, 47, 40, 'rotes'};
    {x / 2 + 26, y / 2 - 228, 27, 31, 'employees'}; 
    {x / 2 + 116, y / 2 - 228, 33, 33, 'cashier'};     
}

function draw_management()
    local alpha = interpolateBetween(interpolate[1], 0, 0, interpolate[2], 0, 0, ((getTickCount() - tick) / 500), 'Linear')
    dxDrawImage(x / 2 - 319, y / 2 - 248, 638, 496, 'assets/management/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawImage(x / 2 + 262, y / 2 - 229, 32, 32, 'assets/icons/exit.png', 0, 0, 0, (isMouseInPosition(x / 2 + 262, y / 2 - 229, 32, 32) and tocolor(14, 154, 247, alpha) or tocolor(196, 196, 196, alpha)))
    for i, v in ipairs(icons) do 
        if (isMouseInPosition(unpack(v))) then
            dxDrawImage(v[1], v[2], v[3], v[4], 'assets/management/icons/'..v[5]..'.png', 0, 0, 0, tocolor(14, 154, 247, alpha))
        elseif (window == v[5]) then 
            dxDrawImage(v[1], v[2], v[3], v[4], 'assets/management/icons/'..v[5]..'.png', 0, 0, 0, tocolor(14, 154, 247, alpha))
        else
            dxDrawImage(v[1], v[2], v[3], v[4], 'assets/management/icons/'..v[5]..'.png', 0, 0, 0, tocolor(196, 196, 196, alpha))
        end
    end

    if (window == 'statistics') then 
        dxDrawText('ESTATÍSTICAS ( '..station..' )', x / 2 - 291, y / 2 - 147, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][1])
        dxDrawText('Veja as estatísticas do seu posto de combustível.', x / 2 - 291, y / 2 - 127, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][1])
        dxDrawImage(x / 2 - 291, y / 2 - 77, 584, 229, 'assets/management/statistics/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawText(statistics[1], (x / 2 - 198) - (dxGetTextWidth(statistics[1], 1, fonts['management'][2]) / 2), y / 2 + 16, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][2])
        dxDrawText(statistics[2], (x / 2) - (dxGetTextWidth(statistics[2], 1, fonts['management'][2]) / 2), y / 2 + 16, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][2])
        dxDrawText(statistics[3], (x / 2 + 199) - (dxGetTextWidth(statistics[3], 1, fonts['management'][2]) / 2), y / 2 + 16, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][2])
        dxDrawText('GASOLINA DISPONÍVEL PARA VENDA', x / 2 - 291, y / 2 + 165, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][3])
        dxDrawImage(x / 2 - 291, y / 2 + 190, 584, 32, 'assets/management/bar_gasoline.png', 0, 0, 0, tocolor(35, 38, 47, alpha))
        dxDrawImageSection(x / 2 - 291, y / 2 + 190, 584 * (stock / config.geral.max_liters), 32, 0, 0, 584 * (stock / config.geral.max_liters), 32, 'assets/management/bar_gasoline.png', 0, 0, 0, tocolor(14, 154, 247, alpha))
        dxDrawText(math.floor(((stock / config.geral.max_liters) * 100))..'%', x / 2 + 243, y / 2 + 192, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][4])
    elseif (window == 'finance') then 
        dxDrawImage(x / 2 - 285, y / 2 - 147, 578, 299, 'assets/management/finance/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha)) 
        dxDrawImage(x / 2 - 291, y / 2 + 190, 584, 32, 'assets/management/bar_gasoline.png', 0, 0, 0, tocolor(35, 38, 47, alpha))
        
        dxDrawImage(x / 2 - 28, y / 2 - 127, 101, 35, 'assets/management/finance/meta_button.png', 0, 0, 0, tocolor(35, 38, 47, alpha))
        dxDrawText('ADD META', (x / 2 + 21) - (dxGetTextWidth('ADD META', 1, fonts['management'][1]) / 2), y / 2 - 117, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][1])
        if (isMouseInPosition(x / 2 - 28, y / 2 - 127, 101, 35)) then 
            if not (meta_tick) then meta_tick = getTickCount() end 
            local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - meta_tick) / 500), 'Linear')
            dxDrawImage(x / 2 - 28, y / 2 - 127, 101, 35, 'assets/management/finance/meta_button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
            dxDrawText('ADD META', (x / 2 + 21) - (dxGetTextWidth('ADD META', 1, fonts['management'][1]) / 2), y / 2 - 117, 0, 0, tocolor(35, 38, 47, animation), 1, fonts['management'][1])
        else
            meta_tick = nil 
        end

        dxDrawImage(x / 2 + 102, y / 2 + 97, 144, 32, 'assets/management/finance/meta_button.png', 0, 0, 0, tocolor(49, 52, 62, alpha))
        dxDrawText('APLICAR', (x / 2 + 174) - (dxGetTextWidth('APLICAR', 1, fonts['management'][6]) / 2), y / 2 + 101, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][6])
        if (isMouseInPosition(x / 2 + 102, y / 2 + 97, 144, 32)) then 
            if not (apply_tick) then apply_tick = getTickCount() end 
            local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - apply_tick) / 500), 'Linear')
            dxDrawImage(x / 2 + 102, y / 2 + 97, 144, 32, 'assets/management/finance/apply_button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
            dxDrawText('APLICAR', (x / 2 + 174) - (dxGetTextWidth('APLICAR', 1, fonts['management'][6]) / 2), y / 2 + 101, 0, 0, tocolor(49, 52, 62, animation), 1, fonts['management'][6])
        else
            apply_tick = nil 
        end

        dxDrawImage(x / 2 + 263, y / 2 - 22, 8, 152, 'assets/management/finance/liter_bar.png', 0, 0, 0, tocolor(49, 52, 62, alpha))
        dxDrawImageSection(x / 2 + 263, y / 2 + 129, 8, - 152 * (liter_price / config.geral.max_price), 0, 0, 8, - 152 * (liter_price / config.geral.max_price), 'assets/management/finance/liter_bar.png', 0, 0, 0, tocolor(14, 154, 247, alpha))
        dxDrawImage(x / 2 + 257, ((y / 2 + 110) - (152 * (liter_price / config.geral.max_price))) + 9.5, 19, 19, 'assets/management/finance/liter_circle.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawText('R$'..math.floor(liter_price), (x / 2 + 174) - (dxGetTextWidth('R$'..math.floor(liter_price), 1, fonts['management'][7]) / 2), y / 2 - 10, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][7])

        if (moving) then 
            local start, finish = (y / 2 + 110), (y / 2 - 22)
            local _, cy = getCursorPosition()
            local my = (cy * y)
            if (my > start) then 
                liter_price = 1 
            elseif (my < finish) then 
                liter_price = config.geral.max_price 
            else 
                local progress = start - my
                local percentage  = (progress / 152) * 100
                liter_price = config.geral.max_price / 100 * percentage
            end
        end

        dxDrawText(select == 1 and guiGetText(meta_edit)..'|' or guiGetText(meta_edit), (x / 2 + 282) - dxGetTextWidth(select == 1 and guiGetText(meta_edit)..'|' or guiGetText(meta_edit), 1, fonts['management'][5]), y / 2 - 121, 0, 0, tocolor(49, 52, 62, alpha), 1, fonts['management'][5])
        dxDrawImage(x / 2 - 291, y / 2 + 190, 584, 32, 'assets/management/bar_gasoline.png', 0, 0, 0, tocolor(35, 38, 47, alpha))
        dxDrawImageSection(x / 2 - 291, y / 2 + 190, 584 * (stock / config.geral.max_liters), 32, 0, 0, 584 * (stock / config.geral.max_liters), 32, 'assets/management/bar_gasoline.png', 0, 0, 0, tocolor(14, 154, 247, alpha))
        dxDrawText(math.floor(((stock / config.geral.max_liters) * 100))..'%', x / 2 + 243, y / 2 + 192, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][4])

        if (week_result) then 
            for weeek_index = 1, 7 do 
                local register = fromJSON(week_result[1][week_order[weeek_index]])   
                for i, v in ipairs(register) do 
                    if (isMouseInPosition((x / 2 - 285) + (51 *  (weeek_index - 1)) + (18 * (i - 1)), y / 2 + 123 - (201 * (v / config.geral.max_meta)), 17, 201 * (v / config.geral.max_meta))) then 
                        dxDrawImageSection((x / 2 - 285) + (51 *  (weeek_index - 1)) + (18 * (i - 1)), y / 2 + 123, 17, - 201 * (v / config.geral.max_meta), 0, 0, 17, - 201 * (v / config.geral.max_meta), 'assets/management/finance/register_bar_effect.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
                        
                        local cx, cy = getCursorPosition()
                        local mx, my = (cx * x), (cy *  y) 
                        dxDrawText('R$ '..v, mx - (dxGetTextWidth('R$ '..v, 1, fonts['management'][1]) / 2), my + 20, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][1])
                    else
                        dxDrawImageSection((x / 2 - 285) + (51 *  (weeek_index - 1)) + (18 * (i - 1)), y / 2 + 123, 17, - 201 * (v / config.geral.max_meta), 0, 0, 17, - 201 * (v / config.geral.max_meta), 'assets/management/finance/register_bar.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
                    end 
                end
            end
        end

        dxDrawImage(x / 2 - 286, ((y / 2 + 112) - (202 * (meta / config.geral.max_meta))) + 13, 357, 13, 'assets/management/finance/meta_line.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawText('R$ '..meta, (x / 2 - 192) - (dxGetTextWidth('R$ '..meta, 1, fonts['management'][11]) / 2), ((y / 2 + 113)) - (202 * (meta / config.geral.max_meta)) + 13, 0, 0, tocolor(38, 41, 52, alpha), 1, fonts['management'][11])
    elseif (window == 'cashier') then 
        dxDrawImage(x / 2 - 291, y / 2 - 147, 584, 370, 'assets/management/cashier/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawText(select == 1 and guiGetText(cashier_edit)..'|' or guiGetText(cashier_edit), (x / 2 + 200) - (dxGetTextWidth(select == 1 and guiGetText(cashier_edit)..'|' or guiGetText(cashier_edit), 1, fonts['management'][8]) / 2), y / 2 + 3, 0, 0, tocolor(31, 31, 31, alpha), 1, fonts['management'][8])
        dxDrawText(cashier_mode, (x / 2 + 200) - (dxGetTextWidth(cashier_mode, 1, fonts['management'][8]) / 2), y / 2 + 67, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][8])
        dxDrawText(balance, (x / 2 - 198) - (dxGetTextWidth(balance, 1, fonts['management'][2]) / 2), y / 2 + 7, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][2])
        dxDrawText(withdrawn, (x / 2) - (dxGetTextWidth(withdrawn, 1, fonts['management'][2]) / 2), y / 2 + 7, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][2])

        local line = 0 
        for i, v in ipairs(table.reverse(logs)) do 
            if (i > page and line < 3) then 
                line = (line + 1) 
                dxDrawRectangle(x / 2 - 291, (y / 2 + 120) + (34 * (line - 1)), 584, 33, tocolor(48, 51, 61, alpha))
                dxDrawText(v[1], x / 2 - 277, (y / 2 + 128) + (34 * (line - 1)), 0, 0, tocolor(14, 154, 247, alpha), 1, fonts['management'][8])
                dxDrawText(v[2], x / 2 - (dxGetTextWidth(v[2], 1, fonts['management'][8]) / 2), (y / 2 + 128) + (34 * (line - 1)), 0, 0, tocolor(14, 154, 247, alpha), 1, fonts['management'][8])
                dxDrawText(v[3], (x / 2 + 287) - dxGetTextWidth(v[3], 1, fonts['management'][8]), (y / 2 + 128) + (34 * (line - 1)), 0, 0, tocolor(14, 154, 247, alpha), 1, fonts['management'][8])
            end
        end
    elseif (window == 'rotes') then 
        dxDrawImage(x / 2 - 287, y / 2 - 147, 574, 299, 'assets/management/rotes/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawText('R$ '..config.rotes_prices[1], (x / 2 - 192) - (dxGetTextWidth('R$ '..config.rotes_prices[1], 1, fonts['management'][3]) / 2), y / 2 + 65, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][3])
        dxDrawText('R$ '..config.rotes_prices[2], (x / 2) - (dxGetTextWidth('R$ '..config.rotes_prices[2], 1, fonts['management'][3]) / 2), y / 2 + 65, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][3])
        dxDrawText('R$ '..config.rotes_prices[3], (x / 2 + 190) - (dxGetTextWidth('R$ '..config.rotes_prices[3], 1, fonts['management'][3]) / 2), y / 2 + 65, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][3])

        if not (tick_buttons_rotes) then tick_buttons_rotes = {} end 
        for i = 1, 3 do 
            dxDrawImage((x / 2 - 271) + (192 * (i - 1)), y / 2 + 111, 158, 30, 'assets/management/rotes/start_button.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
            if (isMouseInPosition((x / 2 - 271) + (192 * (i - 1)), y / 2 + 111, 158, 30)) then 
                if not (tick_buttons_rotes[i]) then tick_buttons_rotes[i] = getTickCount() end 
                local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick_buttons_rotes[i]) / 500), 'Linear')
                dxDrawImage((x / 2 - 271) + (192 * (i - 1)), y / 2 + 111, 158, 30, 'assets/management/rotes/start_button_effect.png', 0, 0, 0, tocolor(255, 255, 255, animation))
            else 
                tick_buttons_rotes[i] = nil 
            end
        end

        dxDrawImage(x / 2 - 291, y / 2 + 190, 584, 32, 'assets/management/bar_gasoline.png', 0, 0, 0, tocolor(35, 38, 47, alpha))
        dxDrawImageSection(x / 2 - 291, y / 2 + 190, 584 * (stock / config.geral.max_liters), 32, 0, 0, 584 * (stock / config.geral.max_liters), 32, 'assets/management/bar_gasoline.png', 0, 0, 0, tocolor(14, 154, 247, alpha))
        dxDrawText(math.floor(((stock / config.geral.max_liters) * 100))..'%', x / 2 + 243, y / 2 + 192, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][4])
    elseif (window == 'employees') then  
        dxDrawImage(x /  2 - 291, y / 2 - 147, 584, 344, 'assets/management/employees/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawText(select == 1 and guiGetText(employe_edit)..'|' or guiGetText(employe_edit), (x / 2 - 73) - (dxGetTextWidth(select == 1 and guiGetText(employe_edit)..'|' or guiGetText(employe_edit), 1,  fonts['management'][9]) / 2), y / 2 + 166, 0, 0, tocolor(73, 87, 87, alpha), 1, fonts['management'][9])
        if not (tick_buttons_employees) then tick_buttons_employees = {} end 
        for i = 1, 2 do 
            dxDrawImage((x / 2) + (146 * (i - 1)), y / 2 + 158, 144, 38, 'assets/refuel/button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
            if (isMouseInPosition((x / 2) + (146 * (i - 1)), y / 2 + 158, 144, 38)) then 
                if not (tick_buttons_employees[i]) then tick_buttons_employees[i] = getTickCount() end 
                local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick_buttons_employees[i]) / 500), 'Linear')
                dxDrawImage((x / 2) + (146 * (i - 1)), y / 2 + 158, 144, 38, 'assets/refuel/button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
            else 
                tick_buttons_employees[i] = nil 
            end
        end

        local line = 0 
        for i, v in ipairs(employees) do 
            if (i > page and line  < 8) then 
                line = (line + 1) 
                if (select_employe == i or isMouseInPosition(x / 2 - 291, (y / 2 - 91) + (30 * (line -  1)), 584, 29)) then  
                    dxDrawRectangle(x / 2 - 291, (y / 2 - 91) + (30 * (line -  1)), 584, 29, tocolor(14, 154, 247, alpha))  
                    dxDrawText(v['employe_name'], x / 2 - 284, (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(25, 28, 37, alpha), 1, fonts['management'][10])
                    dxDrawText('ID: '..v['employe_id'], (x / 2) - (dxGetTextWidth('ID: '..v['employe_id'], 1, fonts['management'][10], true) / 2), (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(25, 28, 37, alpha), 1, fonts['management'][10], 'left', 'top', false, false, false, true)
                    
                    if (getPlayerFromID(v['employe_id'])) then 
                        dxDrawText('Online', (x / 2 +  279) - (dxGetTextWidth('Online', 1, fonts['management'][10])), (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(25, 28, 37, alpha), 1, fonts['management'][10])
                    else
                        dxDrawText('Offline', (x / 2 +  279) - (dxGetTextWidth('Offline', 1, fonts['management'][10])), (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(25, 28, 37, alpha), 1, fonts['management'][10])
                    end
                else 
                    dxDrawRectangle(x / 2 - 291, (y / 2 - 91) + (30 * (line -  1)), 584, 29, tocolor(47, 50, 58, alpha))  
                    dxDrawText(v['employe_name'], x / 2 - 284, (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][10])
                    dxDrawText('#22DC67ID: #C4C4C4'..v['employe_id'], (x / 2) - (dxGetTextWidth('#22DC67ID: #C4C4C4'..v['employe_id'], 1, fonts['management'][10], true) / 2), (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['management'][10], 'left', 'top', false, false, false, true)
                    
                    if (getPlayerFromID(v['employe_id'])) then 
                        dxDrawText('Online', (x / 2 +  279) - (dxGetTextWidth('Online', 1, fonts['management'][10])), (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(22, 220, 103, alpha), 1, fonts['management'][10])
                    else
                        dxDrawText('Offline', (x / 2 +  279) - (dxGetTextWidth('Offline', 1, fonts['management'][10])), (y / 2 - 85) + (30 * (line -  1)), 0, 0, tocolor(255, 84, 84, alpha), 1, fonts['management'][10])
                    end
                end
            end
        end
    end
end

addEventHandler('onClientClick', root, 
    function(b, s) 
        if (isEventHandlerAdded('onClientRender', root, draw_management)) then 
            if (b == 'left' and s == 'down') then 
                if (isMouseInPosition(x / 2 + 262, y / 2 - 229, 32, 32)) then 
                    if (interpolate[1] == 0) then 
                        tick, interpolate = getTickCount(), {255, 0}
                        showCursor(false)
                        setTimer(function()
                            removeEventHandler('onClientRender', root, draw_management)
                        end, 500, 1)
                    end
                else
                    for i, v in ipairs(icons) do 
                        if (isMouseInPosition(unpack(v))) then
                            if (window ~= v[5]) then 
                                if not (isEmploye) then 
                                    window = v[5]
                                    select = 0 
                                    page = 0 
                                    select_employe = 0 
                                end
                            end
                        return end
                    end
    
                    if (window == 'finance') then 
                        select = 0 
    
                        if (guiGetText(meta_edit) == '') then 
                            guiSetText(meta_edit, 'Valor')
                        end
    
                        if (isMouseInPosition(x / 2 + 78, y / 2 - 127, 214, 35)) then 
                            if (guiEditSetCaretIndex(meta_edit, #guiGetText(meta_edit))) then 
                                guiBringToFront(meta_edit)
                                guiSetInputMode('no_binds_when_editing')
                                select = 1 
                                if (guiGetText(meta_edit) == 'Valor') then 
                                    guiSetText(meta_edit, '')
                                end
                            end
                        elseif (isMouseInPosition(x / 2 - 28, y / 2 - 127, 101, 35)) then 
                            triggerServerEvent('onPlayerChangeMeta', localPlayer, localPlayer, station, guiGetText(meta_edit))
                        elseif (isMouseInPosition(x / 2 + 102, y / 2 + 97, 144, 32)) then 
                            triggerServerEvent('onPlayerChangePriceByLiter', localPlayer, localPlayer, station, math.floor(liter_price))
                        elseif (isMouseInPosition(x / 2 + 263, y / 2 - 22, 8, 152)) then 
                            moving = true
                        end
                    elseif (window == 'cashier') then 
                        select = 0 
    
                        if (guiGetText(cashier_edit) == '') then 
                            guiSetText(cashier_edit, 'VALOR')
                        end
    
                        if (isMouseInPosition(x / 2 + 121, y / 2, 157, 28)) then 
                            if (guiEditSetCaretIndex(cashier_edit, #guiGetText(cashier_edit))) then 
                                guiBringToFront(cashier_edit)
                                guiSetInputMode('no_binds_when_editing')
                                select = 1 
    
                                if (guiGetText(cashier_edit) == 'VALOR') then 
                                    guiSetText(cashier_edit, '')
                                end
                            end
                        elseif (isMouseInPosition(x / 2 + 108, y / 2 + 64, 26, 26)) then 
                            if (cashier_mode == 'DEPOSITAR') then 
                                cashier_mode = 'SACAR' 
                            else
                                cashier_mode = 'DEPOSITAR' 
                            end
                        elseif (isMouseInPosition(x / 2 + 263, y / 2 + 64, 26, 26)) then 
                            if (cashier_mode == 'DEPOSITAR') then 
                                cashier_mode = 'SACAR' 
                            else
                                cashier_mode = 'DEPOSITAR' 
                            end
                        elseif (isMouseInPosition(x / 2 + 121, y / 2 + 61, 157, 32)) then 
                            if (cashier_mode == 'SACAR') then 
                                triggerServerEvent('onPlayerWithdrawGasoline', localPlayer, localPlayer, station, guiGetText(cashier_edit))
                            else
                                triggerServerEvent('onPlayerDepositGasoline', localPlayer, localPlayer, station, guiGetText(cashier_edit))
                            end
                        end
                    elseif (window == 'rotes') then 
                        for i = 1, 3 do 
                            if (isMouseInPosition((x / 2 - 271) + (192 * (i - 1)), y / 2 + 111, 158, 30)) then 
                                triggerServerEvent('onPlayerStartRote', localPlayer, localPlayer, station, i)
                            return end 
                        end    
                    elseif (window == 'employees') then 
                        select = 0 
                        
                        if (guiGetText(employe_edit) == '') then 
                            guiSetText(employe_edit, 'ID')
                        end

                        if (isMouseInPosition(x / 2 - 145,  y / 2 + 158, 144, 38)) then 
                            if (guiEditSetCaretIndex(employe_edit, #guiGetText(employe_edit))) then 
                                guiBringToFront(employe_edit)
                                guiSetInputMode('no_binds_when_editing')
                                select = 1 

                                if (guiGetText(employe_edit) == 'ID') then 
                                    guiSetText(employe_edit, '')
                                end
                            end
                        else 
                            for i = 1, 2 do 
                                if (isMouseInPosition((x / 2) + (146 * (i - 1)), y / 2 + 158, 144, 38)) then 
                                    if (i == 1) then 
                                        triggerServerEvent('onPlayerInviteJob', localPlayer, localPlayer, station, guiGetText(employe_edit))
                                    elseif (i == 2) then 
                                        if (select_employe ~= 0) then 
                                            triggerServerEvent('onPlayerDismiss', localPlayer, localPlayer, station, employees[select_employe]['employe_user'])
                                        else
                                            messageC('Selecione algum funcionário primeiro!', 'error')
                                        end
                                    end
                                return end
                            end

                            local line = 0 
                            for i, v in ipairs(employees) do 
                                if (i > page and line  < 8) then 
                                    line = (line + 1) 
                                    if (isMouseInPosition(x / 2 - 291, (y / 2 - 91) + (30 * (line -  1)), 584, 29)) then  
                                        select_employe = i 
                                    return end
                                end
                            end                    
                        end
                    end
                end
            elseif (b == 'left' and s == 'up') then 
                if (moving) then 
                    moving = nil 
                end
            end
        end
    end
)

addEvent('onClientDrawManagement', true)
addEventHandler('onClientDrawManagement', root, 
    function(station_, statistics_, stock_, liter_price_, balance_, withdrawn_, logs_, employees_, isEmploye_, week_result_, meta_)
        if not (isEventHandlerAdded('onClientRender', root, draw_management)) then 
            tick, interpolate, window, station, statistics, stock, select, liter_price, cashier_mode, balance, withdrawn, logs, employees, isEmploye, week_result, meta = getTickCount(), {0, 255}, 'statistics', station_, statistics_, stock_, 0, liter_price_, 'DEPOSITAR', balance_, withdrawn_, logs_, employees_, isEmploye_, week_result_, meta_
            showCursor(true)
            addEventHandler('onClientRender', root, draw_management)

            if (isElement(meta_edit)) then destroyElement(meta_edit) end 
            meta_edit = guiCreateEdit(1000, 1000, 0, 0, 'Valor', false) 
            guiEditSetMaxLength(meta_edit, 5)
            guiSetProperty(meta_edit, 'ValidationString', '[0-9]*')

            if (isElement(cashier_edit)) then destroyElement(cashier_edit) end 
            cashier_edit = guiCreateEdit(1000, 1000, 0, 0, 'VALOR', false) 
            guiEditSetMaxLength(cashier_edit, 7)
            guiSetProperty(cashier_edit, 'ValidationString', '[0-9]*')

            if (isElement(employe_edit)) then destroyElement(employe_edit) end 
            employe_edit = guiCreateEdit(1000, 1000, 0, 0, 'ID', false) 
            guiEditSetMaxLength(employe_edit, 7)
            guiSetProperty(employe_edit, 'ValidationString', '[0-9]*')

            if (isEmploye) then 
                window =  'rotes' 
            end
        end
    end
)

addEvent('onClientRemoveManagement', true)
addEventHandler('onClientRemoveManagement', root, 
    function()
        if (interpolate[1] == 0) then 
            tick, interpolate = getTickCount(), {255, 0}
            showCursor(false)
            setTimer(function()
                removeEventHandler('onClientRender', root, draw_management)
            end, 500, 1)
        end
    end
)

addEvent('onClientReceiveEmployees', true)
addEventHandler('onClientReceiveEmployees', root, 
    function(employees_)
        employees = employees_ 
        page = 0 
    end
)

bindKey('backspace', 'down', 
    function()
        if (isEventHandlerAdded('onClientRender', root, draw_management)) then 
            if (interpolate[1] == 0) then 
                tick, interpolate = getTickCount(), {255, 0}
                showCursor(false)
                setTimer(function()
                    removeEventHandler('onClientRender', root, draw_management)
                end, 500, 1)
            end
        end
    end
)

addEvent('onClientReceiveBalance', true)
addEventHandler('onClientReceiveBalance', root, 
    function(balance_, withdrawn_)
        if (balance_) then 
            balance = balance_
        end

        if (withdrawn_) then 
            withdrawn = withdrawn_
        end
    end
)

addEvent('onClientReceiveLogs', true)
addEventHandler('onClientReceiveLogs', root, 
    function(logs_)
        logs = logs_
    end
)

addEvent('onClientReceiveEmployees', true)
addEventHandler('onClientReceiveEmployees', root, 
    function(employees_)
        employees = employees_ 
        page = 0 
    end
)

addEvent('onClientReceiveMeta', true)
addEventHandler('onClientReceiveMeta', root, 
    function(meta_)
        meta = meta_
    end
)

function draw_invite()
    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 500), 'Linear')
    dxDrawImage(x / 2 - 213, y / 2 - 112, 426, 224, 'assets/management/invite/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText(station, (x / 2) - (dxGetTextWidth(station, 1, fonts['invite'][1]) / 2), y / 2 - 41, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['invite'][1])
    dxDrawText('DESEJA TE CONTRATAR.', (x / 2) - (dxGetTextWidth('DESEJA TE CONTRATAR.', 1,  fonts['invite'][1]) / 2), y / 2 - 19, 0, 0, tocolor(196, 196, 196, alpha), 1, fonts['invite'][1])
    dxDrawImage(x / 2 - 146, y / 2 + 51,  144, 38, 'assets/refuel/button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
    if (isMouseInPosition(x /  2 - 146, y / 2 + 51,  144, 38)) then 
        if not (tick_button_invite) then tick_button_invite = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick_button_invite) / 500), 'Linear')
        dxDrawImage(x /  2 - 146, y / 2 + 51,  144, 38, 'assets/refuel/button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
    else
        tick_button_invite = nil 
    end

    dxDrawImage(x / 2, y / 2 + 51,  144, 38, 'assets/refuel/button.png', 0, 0, 0, tocolor(92, 94, 100, alpha))
    if (isMouseInPosition(x / 2, y / 2 + 51,  144, 38)) then 
        if not (tick_button_cancel) then tick_button_cancel = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick_button_cancel) / 500), 'Linear')
        dxDrawImage(x / 2, y / 2 + 51,  144, 38, 'assets/refuel/button.png', 0, 0, 0, tocolor(14, 154, 247, animation))
    else
        tick_button_cancel = nil 
    end
end

addEventHandler('onClientClick', root, 
    function(b, s)
        if (b == 'left' and s == 'down') then 
            if (isEventHandlerAdded('onClientRender', root, draw_invite)) then 
                if (isMouseInPosition(x /  2 - 146, y / 2 + 51,  144, 38)) then 
                    removeEventHandler('onClientRender', root, draw_invite)
                    showCursor(false)
                elseif (isMouseInPosition(x / 2, y / 2 + 51,  144, 38)) then     
                    triggerServerEvent('onPlayerAcceptJob', localPlayer, localPlayer, station)
                    removeEventHandler('onClientRender', root, draw_invite)
                    showCursor(false)
                end
            end
        end
    end
)

addEvent('onClientDrawInvite', true)
addEventHandler('onClientDrawInvite', root, 
    function(station_)
        if not (isEventHandlerAdded('onClientRender', root, draw_invite)) then 
            tick, station = getTickCount(), station_ 
            addEventHandler('onClientRender', root, draw_invite)
            showCursor(true)
        end
    end
)

------------------------------------------------
function isMouseInPosition(x,y,w,h)
	if isCursorShowing() then
		local sx,sy = guiGetScreenSize()
		local cx,cy = getCursorPosition()
		local cx,cy = (cx*sx),(cy*sy)

		if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
			return true
		end
	end
end

function table.reverse(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

bindKey('mouse_wheel_up', 'down', function()
    if isEventHandlerAdded('onClientRender', root, draw_management) then
        if (page > 0) then
            page = page - 1
        end
    end
end)

bindKey('mouse_wheel_down', 'down', function()
    if isEventHandlerAdded('onClientRender', root, draw_management) then
        if (window ==  'cashier') then  
            page = page + 1
            if (page > #logs - 3) then
                page = #logs - 3
            end
        elseif (window == 'employees') then 
            page = page + 1
            if (page > #employees   - 8) then
                page = #employees   - 8
            end 
        end 
    end
end)

------------------------------------------------        