require "actors.actor"

ActorBackground = {}
ActorBackground_mt = { __index = ActorBackground }

function ActorBackground:create(level, x, y, sprite_name, layer)
	if not layer then
		layer = 4
	end
	local new_actor = {}
	new_actor.body = love.physics.newBody(level.world, x, y, "static")
	new_actor.sprite = love.graphics.newImage(sprite_path .. sprite_name .. ".png")
	new_actor.quad = love.graphics.newQuad( 0, 0, new_actor.sprite:getWidth(), new_actor.sprite:getHeight(), new_actor.sprite:getWidth(), new_actor.sprite:getHeight())
	new_actor.layer = layer
	level:add_actor(new_actor, "background")
	setmetatable(new_actor, ActorBackground_mt)
	return new_actor
end

function ActorBackground:load(line)
	local actor_type, actor_x, actor_y, sprite_name, layer = unpack(split_string(line, ","))
	ActorBackground:create(level, actor_x, actor_y, sprite_name, layer) -- x1 will be the sprite name
end