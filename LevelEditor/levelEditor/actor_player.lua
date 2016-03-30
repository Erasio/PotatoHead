require "actors.actor"

ActorPlayer = inheritsFrom(Actor)

function ActorPlayer.create(level, x, y, shape, sprite, quad)
	body = love.physics.newBody(level.world, x, y, "dynamic")
	new_actor = Actor.create(x, y, body, shape, sprite, quad)
	level:add_actor(new_actor, "player")
	return new_actor
end

