require "actors.actor"

ActorStatic = inheritsFrom(Actor)
ActorStatic_mt = { __index = ActorStatic }

function ActorStatic.create(level, x, y, shape, sprite, quad, layer)
	local body = love.physics.newBody(level.world, x, y, "static")
	local new_actor = ActorStatic:do_create(x, y, body, shape, sprite, quad, layer)
	level:add_actor(new_actor, "static")
	setmetatable(new_actor, ActorStatic_mt)
	return new_actor
end

function ActorStatic:load(line)
	local actor_type, actor_x, actor_y, x1, y1, x2, y2, x3, y3, x4, y4, layer = unpack(split_string(line, ","))
	local actor_shape = love.physics.newPolygonShape(x1, y1, x2, y2, x3, y3, x4, y4)
    local actor_quad = love.graphics.newQuad(0, 0, x2 - x4, y2 - y4, level.default_sprite:getDimensions())
    ActorStatic.create(level, actor_x, actor_y, actor_shape, level.default_sprite, actor_quad, layer)
end