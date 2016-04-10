require "levelEditor.actor"

ActorBackground = inheritsFrom(Actor)
ActorBackground_mt = { __index = ActorBackground }

function ActorBackground.create(level, x, y, sprite_name)
	local new_actor = {}
	new_actor.color = {255, 255, 255}
	new_actor.body = love.physics.newBody(level.world, x, y, "static")
	new_actor.sprite_name = sprite_name
	new_actor.actor_type = "background"
	level:add_actor(new_actor, type)
	setmetatable(new_actor, ActorBackground_mt)
	new_actor:set_hitbox()
	return new_actor
end

function ActorBackground.save(self)
	local save_string = self.actor_type .. ","
    local actor_x, actor_y = self.body:getPosition()
    save_string = save_string .. actor_x .. "," .. actor_y .. ","
    save_string = save_string .. self.sprite_name .. ","
    save_string = save_string .. "\n"
    return save_string
end

function ActorBackground:set_hitbox()
	for i, button in pairs(buttons) do
		if button == self.hitbox then
			table.remove(buttons, i)
		end
	end

	local actor_x, actor_y = self.body:getPosition()
	if self == selected_actor then
		self.hitbox = hitbox:new(actor_x - 5, actor_y - 5, 10, 10, self.test, "", {0, 255, 0, 0}, false, {self})
	else
		self.hitbox = hitbox:new(actor_x - 5, actor_y - 5, 10, 10, self.set_active, "", {0, 255, 0, 0}, false, {self})
	end
end

function ActorBackground.set_active(self)
	if self ~= selected_actor then
		if selected_actor ~= nil then
			selected_actor.set_unactive(selected_actor)
		end
		print("Set Active")
		selected_actor = self
		self:set_hitbox()
	end
end

function ActorBackground.set_unactive(self)
	selected_actor = nil

	self:set_hitbox()
end

function ActorBackground.test()
	print("Background test")
end