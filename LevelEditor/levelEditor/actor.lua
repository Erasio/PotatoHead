Actor = {}
Actor_mt = { __index = Actor }

function Actor:do_create(level, x, y, body_type, shape)
	local actor = {}
    actor.body = love.physics.newBody(level.world, x, y, body_type)
    actor.shape = shape
    actor.fixture = love.physics.newFixture(actor.body, actor.shape)
    actor.fixture:setUserData(actor)
    actor.hitbox = nil
    actor.extend_right = nil
    actor.extend_down = nil
    actor.extend_direction = nil
	setmetatable(actor, Actor_mt)
	actor:set_hitbox()

	return actor
end

function Actor.set_active(self)
	if self ~= selected_actor then
		if selected_actor ~= nil then
			selected_actor.set_unactive(selected_actor)
		end
		print("Set Active")
		selected_actor = self
		self:set_hitbox()
	end
end

function Actor.test()
	print("Test successful!")
end

function Actor.set_unactive(self)
	for i, button in pairs(buttons) do
		if button == self.extend_down then
			table.remove(buttons, i)
		end
	end
	self.extend_down = nil
	for i, button in pairs(buttons) do
		if button == self.extend_right then
			table.remove(buttons, i)
		end
	end
	self.extend_right = nil
	selected_actor = nil

	shape_x1, shape_y1, shape_x2, shape_y2, shape_x3, shape_y3, shape_x4, shape_y4 = self.shape:getPoints()
	self.shape = love.physics.newPolygonShape(round(shape_x1, 0), round(shape_y1, 0), round(shape_x2, 0), round(shape_y2, 0), round(shape_x3, 0), round(shape_y3, 0), round(shape_x4, 0), round(shape_y4, 0))
	self:set_hitbox()
end

function Actor:set_hitbox()
	for i, button in pairs(buttons) do
		if button == self.hitbox then
			table.remove(buttons, i)
		end
	end

	local actor_x, actor_y = self.body:getPosition()
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.shape:getPoints()

	if self == selected_actor then
		self.hitbox = hitbox:new(actor_x + x4, actor_y + y4, x2 - x4, y2- y4, self.test, "", {0, 255, 0, 0}, false, {self})
	else
		self.hitbox = hitbox:new(actor_x + x4, actor_y + y4, x2 - x4, y2 - y4, self.set_active, "", {0, 255, 0, 0}, false, {self})
	end

	if self == selected_actor then
		self:create_extend_buttons()
	end
end

function Actor:extend(dx, dy)
	if self.extend_direction ~= nil then
		shape_x1, shape_y1, shape_x2, shape_y2, shape_x3, shape_y3, shape_x4, shape_y4 = self.shape:getPoints()
		if self.extend_direction == "down" then
			if shape_y2 + dy > 0 then
				self.shape = love.physics.newPolygonShape(shape_x1, shape_y1, shape_x2, shape_y2 + dy, shape_x3, shape_y3 + dy, shape_x4, shape_y4)
			end
		elseif self.extend_direction == "right" then
			if shape_x1 + dx > 0 then
				self.shape = love.physics.newPolygonShape(shape_x1 + dx, shape_y1, shape_x2 + dx, shape_y2, shape_x3, shape_y3, shape_x4, shape_y4)
			end
		end
	end
	self:set_hitbox()
end

function Actor.set_extend_direction(self, direction)
	print("Direction: " .. direction)
	self.extend_direction = direction
	extend_mode = true
end

function Actor:create_extend_buttons()
	local actor_x, actor_y = self.body:getPosition()
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.shape:getPoints()

	for i, button in pairs(buttons) do
		if button == self.extend_down then
			table.remove(buttons, i)
		end
	end
	self.extend_down = hitbox:new(actor_x + 5 + x3, actor_y + y3 - 10, x2 - 10, 10, self.set_extend_direction, "", {255, 0, 0}, false, {self, "down"})

	for i, button in pairs(buttons) do
		if button == self.extend_right then
			table.remove(buttons, i)
		end
	end
	self.extend_right = hitbox:new(actor_x + x2 - x4 - 10, actor_y + y4 + 5, 10, y2 - y4 - 10, self.set_extend_direction, "", {255, 0, 0}, false, {self, "right"})
end

function Actor:destroy()
	for i, button in pairs(buttons) do
		if button == self.hitbox or button == self.extend_right then
			table.remove(buttons, i)
		end
	end
	for i, button in pairs(buttons) do
		if button == self.extend_down then
			table.remove(buttons, i)
		end
	end

    self.body:destroy( )
	self = nil
end

function Actor:hit(self, other_actor, x, y, col)
end

function Actor:leave(self, other_actor, x, y, col)
end
