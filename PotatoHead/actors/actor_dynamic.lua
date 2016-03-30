require "actors.actor"

ActorDynamic = inheritsFrom(Actor)
ActorDynamic_mt = { __index = ActorDynamic }

function ActorDynamic:create(level, x, y, shape, sprite, quad)
	local body = love.physics.newBody(level.world, x, y, "dynamic")
	local new_actor = ActorDynamic:do_create(x, y, body, shape, sprite, quad)
	level:add_actor(new_actor, "dynamic")
	setmetatable(new_actor, ActorDynamic_mt)
	return new_actor
end
