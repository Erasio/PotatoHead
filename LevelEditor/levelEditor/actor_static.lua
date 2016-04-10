require "levelEditor.actor"

ActorStatic = inheritsFrom(Actor)
ActorStatic_mt = { __index = ActorStatic }
ActorStatic.type = "static"

function ActorStatic.create(level, x, y, shape)
	local new_actor = ActorStatic:do_create(level, x, y, "static", shape)
	new_actor.color = {0, 255, 0}
	new_actor.actor_type = "static"
	level:add_actor(new_actor, new_actor.actor_type)
	setmetatable(new_actor, ActorStatic_mt)
	return new_actor
end

function ActorStatic.save(self)
	local save_string = self.actor_type .. ","
    local actor_x, actor_y = self.body:getPosition()
    save_string = save_string .. actor_x .. "," .. actor_y .. ","
    local x1, y1, x2, y2, x3, y3, x4, y4 = self.shape:getPoints()
    save_string = save_string .. x1 .. "," .. y1 .. "," .. x2 .. "," .. y2 .. "," .. x3 .. "," .. y3 .. "," .. x4 .. "," .. y4 .. ","
    save_string = save_string .. "\n"
	return save_string
end