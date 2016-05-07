Level = {}
Level_mt = { __index = Level }

function Level:init_level(map)
	love.physics.setMeter(64)

	level = {}
    level.map = map
    level.world = love.physics.newWorld(0, 9.81*64, true)

    level.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    level.actors = {}
    
    setmetatable(level, Level_mt)

    file = io.open(level.map .. ".map", "r")
    if file then
        local line = file:read()
        while line ~= nil do
            local actor_type, actor_x, actor_y, x1, y1, x2, y2, x3, y3, x4, y4 = unpack(split_string(line, ","))
            if actor_type == "static" then
                print("Spawning ActorStatic Location :", actor_x, actor_y)
                local actor_shape = love.physics.newPolygonShape(x1, y1, x2, y2, x3, y3, x4, y4)
                ActorStatic.create(level, actor_x, actor_y, actor_shape)
            elseif actor_type == "player_spawn" then
                print("Spawning PlayerSpawn Location :", actor_x, actor_y)
                local actor_shape = love.physics.newPolygonShape(5, 5, 5, -5, -5, -5, -5, 5)
                ActorMeta.create(level, actor_x, actor_y, actor_shape, actor_type)
            elseif actor_type == "trigger" then
                print("Spawning Trigger")
                ActorTrigger.create(level, actor_x, actor_y, x1)
            elseif actor_type == "background" then
                print("Spawning Sprite")
                ActorBackground.create(level, actor_x, actor_y, x1)
            end

            line = file:read()
        end
    else
        level.actors["player_spawn"] = {}
        local actor_shape = love.physics.newPolygonShape(5, 5, 5, -5, -5, -5, -5, 5)
        ActorMeta.create(level, 0, 0, actor_shape, "player_spawn")
    end
    return level
end

function split_string(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

function Level:add_actor(actor, actor_type)
    if level.actors[actor_type] == nil then
        level.actors[actor_type] = {}
    end
	local actor_id = table.getn(level.actors[actor_type]) + 1
	level.actors[actor_type][actor_id] = actor
end

function beginContact(a, b, coll)
    x, y = get_x_y_from_col(coll)

    a:getUserData():hit(a, b, x, y, coll)
    b:getUserData():hit(b, a, x, y, coll)
end
 
function endContact(a, b, coll)
    x, y = get_x_y_from_col(coll)

    a:getUserData():leave(a, b, x, y, coll)
    b:getUserData():leave(b, a, x, y, coll)
end
 
function preSolve(a, b, coll)
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end

function get_x_y_from_col(coll)
    local x1, y2, x2, y2 = coll:getPositions()
    x = 0
    y = 0
    if x1 == nil then
        x = x2
    elseif x2 == nil then
        x = x1
    else
        x = (x1 - x2) / 2 + x1
    end
    if y1 == nil then
        y = y2
    elseif y2 == nil then
        y = y1
    else
        y = (y1 - y2) / 2 + y1
    end
    return x, y
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
