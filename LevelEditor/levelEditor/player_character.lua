require "actors.actor"

PlayerCharacter = inheritsFrom(Actor)
PlayerCharacter_mt = { __index = PlayerCharacter }

function PlayerCharacter.create(level, x, y)
	local body = love.physics.newBody(level.world, x, y, "dynamic")
	local shape = love.physics.newPolygonShape(0, 0, 26, 0, 26, 50, 0, 50)
	local sprite = love.graphics.newImage("graphics/idle.png")
	local quad = love.graphics.newQuad(0, 0, 26, 50, sprite:getDimensions())
	new_actor = PlayerCharacter:do_create(x, y, body, shape, sprite, quad)
	level:add_actor(new_actor, "player")
	new_actor.is_on_ground = false
	new_actor.ground_col = {}
	new_actor.collisions = {}
	new_actor.body:setFixedRotation(true)
	setmetatable(new_actor, PlayerCharacter_mt)
	return new_actor
end

function PlayerCharacter:hit(me, other_actor, x, y, col)
	local colx1, coly1, colx2, coly2 = col:getPositions()
	if coly1 ~= nil and coly2 ~= nil then
		if round(coly1) == round(coly2) then
			table.insert(me:getUserData().ground_col, col)
			me:getUserData().is_on_ground = true
			print("On ground!")
		else
			table.insert(me:getUserData().collisions, col)
		end
	end
end

function Actor:leave(me, other_actor, x, y, col)
	local found = false
	if me:getUserData().ground_col ~= nil then
		for i, entry in pairs(me:getUserData().ground_col) do
			if entry == col then
				me:getUserData().ground_col[i] = nil
				found = true
			end
		end
		if #me:getUserData().ground_col == 0 then
			me:getUserData().is_on_ground = false
			print("No ground contact!")
		end
	end
	if me:getUserData().collisions ~= nil then
		if not found then
			for i, entry in pairs(me:getUserData().collisions) do
				if entry == col then
					me:getUserData().collisions[i] = nil
				end
			end
		end
	end
end

function PlayerCharacter:yell()
	print("PLAYER CHARACTER")
end

