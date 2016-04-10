require "levelEditor.actor"

ActorDynamic = inheritsFrom(Actor)
ActorDynamic_mt = { __index = ActorDynamic }
ActorDynamic.actor_type = "dynamic"

function ActorDynamic:create(level, x, y, shape, sprite_name)
	local new_actor = ActorDynamic:do_create(level, x, y, "dynamic", shape)
	new_actor.color = {255, 0, 0}
	new_actor.sprite_name = sprite_name
	new_actor.actor_type = ActorDynamic.actor_type
	level:add_actor(new_actor, new_actor.actor_type)
	setmetatable(new_actor, ActorDynamic_mt)
	return new_actor
end

function ActorDynamic.save(self)
	local save_string = self.actor_type .. ","
    local actor_x, actor_y = self.body:getPosition()
    save_string = save_string .. actor_x .. "," .. actor_y .. ","
    save_string = save_string .. "\n"
    return save_string
end