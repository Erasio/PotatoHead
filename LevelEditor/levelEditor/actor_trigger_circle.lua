require "levelEditor.actor"

ActorTrigger = inheritsFrom(Actor)
ActorTrigger_mt = {__index = ActorTrigger}

function ActorTrigger.create(level, x, y, radius, color)
	local shape = love.physics.newPolygonShape(radius, radius, radius, -radius, -radius, -radius, -radius, radius)
	local new_actor = ActorTrigger:do_create(level, x, y, "static", shape)
	level:add_actor(new_actor, "trigger")
	setmetatable(new_actor, ActorTrigger_mt)
	return new_actor
end

function ActorTrigger.save(self)
	local save_string = "trigger,"
	local actor_x, actor_y = self.body:getPosition()
	local radius = 0
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.shape:getPoints()
	love.graphics.print("Size: " .. round(x2 - x4) .. " / " .. round(y2 - y4), window.x - 190, current_y)
	if math.abs(round(x2 - x4)) <= math.abs(round(y2 - y4)) then
		radius = math.abs(round(x2 - x4)) / 2
	else
		radius = math.abs(round(y2 - y4)) / 2
	end
	save_string = save_string .. actor_x .. "," .. actor_y .. "," .. radius .. ",\n"
	return save_string
end
