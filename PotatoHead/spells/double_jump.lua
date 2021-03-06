require "spells.spell"

DoubleJump = inheritsFrom(Spell)
DoubleJump_mt = { __index = DoubleJump }
DoubleJump.combination = "ud"
DoubleJump.available = true

function DoubleJump:cast()
	print("DoubleJump")
	if self.available then
		character.body:setLinearVelocity(0, -350)
		local x, y = character.body:getPosition()
		x = x + 13
		y = y + 50
		DoubleJumpPS:create(x, y)
		self.available = false
		return true
	else
		return false
	end
end

function DoubleJump:OnGround()
	self.available = true
end
