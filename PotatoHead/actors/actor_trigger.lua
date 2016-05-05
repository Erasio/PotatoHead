require "actors.actor"

ActorTrigger = {}
ActorTrigger_mt = {__index = ActorTrigger}

function ActorTrigger:create(level, x, y, radius)
	local new_actor = {}
	new_actor.x = tonumber(x)
	new_actor.y = tonumber(y)
	new_actor.radius = tonumber(radius)
	new_actor.layer = "trigger"
	new_actor.trigger_type = "save"
	new_actor.triggered = false
	Level:add_trigger(new_actor)
	setmetatable(new_actor, ActorTrigger_mt)
	return new_actor
end

function ActorTrigger:load(line)
	local actor_type, actor_x, actor_y, radius = unpack(split_string(line, ","))
	ActorTrigger:create(level, actor_x, actor_y, radius)
end

function ActorTrigger:activate()
	if not self.triggered then
		print("Herro :)")
		self.triggered = true
		if self.trigger_type == "save" then
			file = io.open("clocked.log", "a+")
			file:write(level.map .. "\t|\t" .. level.time .. "\n")
		end
	end
end
