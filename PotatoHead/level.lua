Level = {}
Level_mt = { __index = Level }

function Level:init_level(map)
	love.physics.setMeter(64)

	level = {}
    level.world = love.physics.newWorld(0, 9.81*64, true)
    level.map = map
    level.world = love.physics.newWorld(0, 9.81*64, true)
    level.default_sprite = love.graphics.newImage("graphics/block.png")
    level.default_sprite:setWrap("repeat", "repeat")
    level.time = 0
    level.trigger = {}
    level.ps = {} -- ParticleSystems


    level.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    level.actors = {}
  
    setmetatable(level, Level_mt)

    for i = 1, 10 do
        level.actors[i] = {}
    end

    character = PlayerCharacter.create(level, 1155/2, 500)

    file = io.open(level.map .. ".map", "r")
    if file then
        local line = file:read()
        while line ~= nil do
            actor_type, actor_x, actor_y = unpack(split_string(line, ","))
            if actor_type == "static" then
                ActorStatic:load(line)
            elseif actor_type == "player_spawn" then
                character.body:setPosition(actor_x, actor_y)
            elseif actor_type == "background" then
                ActorBackground:load(line)
            elseif actor_type == "trigger" then
                ActorTrigger:load(line)
            end
            line = file:read()
        end
    end
    
    return level
end

function Level:update(dt)
    for k, ps in pairs(level.ps) do
        ps.lifetime = ps.lifetime - dt
        if ps.lifetime <= 0 then
            ps.ps:stop()
            level.ps[k] = nil
        else
            ps.ps:update(dt)
        end
    end
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
    if level.actors[actor.layer][actor_type] == nil then
        level.actors[actor.layer][actor_type] = {}
    end
	local actor_id = table.getn(level.actors[actor.layer][actor_type]) + 1
	level.actors[actor.layer][actor_type][actor_id] = actor
    actor.id = actor_id
end

function Level:add_trigger(trigger)
    local trigger_id = table.getn(level.trigger) + 1
    level.trigger[trigger_id] = trigger
    trigger.id = trigger_id
end

function Level:add_ps(ps)
    local ps_id = table.getn(level.ps) + 1
    level.ps[ps_id] = ps
    ps.id = ps_id
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
