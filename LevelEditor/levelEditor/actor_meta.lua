require "levelEditor.actor"

ActorMeta = inheritsFrom(Actor)
ActorMeta_mt = { __index = ActorMeta }

function ActorMeta.create(level, x, y, shape, actor_type, color)
	local new_actor = ActorMeta:do_create(level, x, y, "static", shape)
	new_actor.actor_type = actor_type
	level:add_actor(new_actor, actor_type)
	setmetatable(new_actor, ActorMeta_mt)
	return new_actor
end

function ActorMeta.save(self)
	local save_string = self.actor_type .. ","
    local actor_x, actor_y = self.body:getPosition()
    save_string = save_string .. actor_x .. "," .. actor_y .. ","
    save_string = save_string .. "\n"
    return save_string
end