require "levelEditor.actor"

ActorMeta = inheritsFrom(Actor)
ActorMeta_mt = { __index = ActorMeta }

function ActorMeta.create(level, x, y, shape, sprite, quad, type)
	local body = love.physics.newBody(level.world, x, y, "static")
	local new_actor = ActorMeta:do_create(x, y, body, shape, sprite, quad)
	level:add_actor(new_actor, type)
	setmetatable(new_actor, ActorMeta_mt)
	return new_actor
end
