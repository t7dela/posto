--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]
IDBlock = {411}
config = {
    geral = {
        liter_price_default = 10; 
        max_liters = 1000;
        max_price = 50;
        delay_operation = 10;
        max_meta = 1000000;
    };
    
    blips = {
        refuel = 56;
        management = 56;
    }; 

    markers_ids = {
        refuel = 1; 
        management = 1;
    };

    rotes_prices = {
        10000; 
        15000; 
        30000;
    };

    rote_percentage = 15;  -- quantos % o funcionario vai ganhar do valor da rota

    truck = {
        model = 515, 
        trailer = 584, 
    };

    gas_stations = {
        {   
            name = 'POSTO VINEWOOD'; 
            position_refuel = {
                {1000.435, -941.303+0.5, 41.18};
                {1000.435+7, -941.303+1, 41.18};
                {1000.435, -941.303+7, 41.18};
                {1000.435+7, -941.303+8, 41.18};
            }; 

            position_management = {1000.097, -920.03, 41.328};
            price = 20000000;

            rote_spawn = {986.857, -920.077, 42.18-1, 0, 0, 181.324}; -- x, y, z, rx, ry, rz do caminhão
            rotes = {
                [1] = {
                    colect = {1643.909, -1896.919, 13.553-1}; 
                    delivery = {998.748, -896.576, 42.254-1};
                }; 

                [2] = {
                    colect = {2430.35, 2783.804, 10.82-1}; 
                    delivery = {998.748, -896.576, 42.254-1};
                }; 

                [3] = {
                    colect = {-2260.359, 2304.365, 4.82-1}; 
                    delivery = {998.748, -896.576, 42.254-1};
                }; 
            };
        };
        {   
            name = 'POSTO CJ'; 
            position_refuel = {
                {1939.398, -1766.99, 13.383-1};
                {1939.429, -1771.091, 13.383-1};
                {1938.929, -1773.922, 13.383-1};
                {1938.868, -1778.352, 13.391-1};
                {1944.491, -1778.786, 13.391-1};
                {1944.315, -1774.82, 13.391-1};
                {1944.182, -1771.46, 13.391-1};
                {1944.149, -1767.433, 13.391-1};


            }; 

            position_management = {1929.271, -1776.338, 12.547};
            price = 20000000;

            rote_spawn = {1922.573, -1791.89, 13.383 + 2, 0, 0, 270}; -- x, y, z, rx, ry, rz do caminhão
            rotes = {
                [1] = {
                    colect = {-52.366, -1142.325, 1.078}; 
                    delivery = {1920.481, -1792.185, 13.383};
                }; 

                [2] = {
                    colect = {1268.257, 2682.546, 10.82}; 
                    delivery = {1920.481, -1792.185, 13.383};
                }; 

                [3] = {
                    colect = {-2260.252, 2317.328, 4.812}; 
                    delivery = {1920.481, -1792.185, 13.383}; 
                }; 
            };
        };

        {   
            name = 'POSTO PRINCIPAL'; 
            position_refuel = {
                {944.421, -1353.329, 13.747-1};
                {944.346, -1349.449, 13.747-1};
                {951.932, -1349.382, 13.747-1};
                {951.738, -1353.432, 13.747-1};
            }; 

            position_management = {951.433, -1363.302, 12.757};
            price = 18000000;

            rote_spawn = {932.912, -1341.515, 13.747+2, 0, 0, 4.842}; -- x, y, z, rx, ry, rz do caminhão
            rotes = {
                [1] = {
                    colect = {1643.909, -1896.919, 13.553}; 
                    delivery = {965.396, -1372.233, 13.757};
                }; 

                [2] = {
                    colect = {2430.35, 2783.804, 10.82}; 
                    delivery = {965.396, -1372.233, 13.757};
                }; 

                [3] = {
                    colect = {-2260.359, 2304.365, 4.82}; 
                    delivery = {965.396, -1372.233, 13.757};
                }; 
            };
        };


        {   
            name = 'POSTO SÃO FIERRO'; 
            position_refuel = {
                {-82.945, -1165.297, 2.204};
                {-87.554, -1176.371, 2.124};
                {-99.681, -1172.68, 2.444};
                {-95.183, -1162.171, 2.283};
            }; 

            position_management = {-78.493, -1169.826, 2.139};
            price = 10000000;

            rote_spawn = {-68.531, -1159.212, 1.75 + 2, 0, 0, 64.268}; -- x, y, z, rx, ry, rz do caminhão
            rotes = {
                [1] = {
                    colect = {-52.366, -1142.325, 1.078}; 
                    delivery = {-63.484, -1161.428, 1.75};
                }; 

                [2] = {
                    colect = {1268.257, 2682.546, 10.82}; 
                    delivery = {-63.484, -1161.428, 1.75};
                }; 

                [3] = {
                    colect = {-2260.252, 2317.328, 4.812}; 
                    delivery = {-63.484, -1161.428, 1.75}; 
                }; 
            };
        };

        {   
            name = 'POSTO LAS VENTURA 2'; 
            position_refuel = {
                {2210.232, 2480.848, 10.82-1};
                {2210.435, 2474.916, 10.82-1};
                {2210.528, 2470.466, 10.82-1};
                {2205.375, 2470.08, 10.82-1};
                {2205.135, 2474.053, 10.82-1};
                {2204.975, 2480.36, 10.82-1};
                {2199.519, 2480.493, 10.82-1};
                {2199.42, 2475.102, 10.82-1};
                {2199.462, 2470.746, 10.82-1};
                {2194.406, 2469.821, 10.82-1};
                {2194.565, 2474.347, 10.82-1};
                {2194.629, 2480.018, 10.82-1};
            }; 

            position_management = {2213.959, 2494.124, 10.82-1}; 
            price = 10000000;

            rote_spawn = {2192.618, 2500.479, 10.82 + 2, 0, 0, 175.149}; -- x, y, z, rx, ry, rz do caminhão
            rotes = {
                [1] = {
                    colect = {365.411, 2538.073, 16.665}; 
                    delivery = {2168.601, 2489.652, 10.82};
                }; 

                [2] = {
                    colect = {-57.548, -1138.198, 1.078}; 
                    delivery = {2168.601, 2489.652, 10.82};
                }; 

                [3] = {
                    colect = {-1619.633, -2711.45, 48.533}; 
                    delivery = {2168.601, 2489.652, 10.82}; 
                }; 
            };
        };





    }; 
}

function message(player, text, type) 
    return  triggerClientEvent(player, "OnClientAddBox", player, text, type)
end

function messageC(text, type) 
    triggerEvent('OnClientAddBox', localPlayer, type, text)
end

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

function getPlayerFromID(id)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'ID') == tonumber(id) then
            return v
        end
    end
    return false
end

r, g, b, a = 100, 100, 100, 90

week_day_values = {
    [0] = 'sunday';
    [1] = 'monday';
    [2] = 'tuesday';
    [3] = 'wednesday';
    [4] = 'thursday';
    [5] = 'friday';
    [6] = 'saturday';
}

week_order = {
    [1] = 'monday';
    [2] = 'tuesday';
    [3] = 'wednesday';
    [4] = 'thursday';
    [5] = 'friday';
    [6] = 'saturday';
    [7] = 'sunday';
}