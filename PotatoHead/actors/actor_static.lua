require "actors.actor"

ActorStatic = inheritsFrom(Actor)
ActorStatic_mt = { __index = ActorStatic }

function ActorStatic.create(level, x, y, shape, sprite, quad)
	local body = love.physics.newBody(level.world, x, y, "static")
	local new_actor = ActorStatic:do_create(x, y, body, shape, sprite, quad)
	level:add_actor(new_actor, "static")
	setmetatable(new_actor, ActorStatic_mt)
	return new_actor
end
