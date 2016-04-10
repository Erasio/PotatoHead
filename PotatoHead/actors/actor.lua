Actor = {}
Actor_mt = { __index = Actor }

function Actor:do_create(x, y, body, shape, sprite, quad, layer)
	if not layer then
		layer = 5
	end
	local actor = {}
    actor.body = body
    actor.shape = shape
    actor.sprite = sprite
    actor.fixture = love.physics.newFixture(actor.body, actor.shape)
    actor.quad = quad
    actor.layer = layer
    actor.fixture:setUserData(actor)
	setmetatable(actor, Actor_mt)

	return actor
end



function Actor:hit(self, other_actor, x, y, col)
end

function Actor:leave(self, other_actor, x, y, col)
end