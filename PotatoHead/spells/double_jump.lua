require "spells.spell"

DoubleJump = inheritsFrom(Spell)
DoubleJump_mt = { __index = DoubleJump }
DoubleJump.combination = "ud"
DoubleJump.available = true

function DoubleJump:cast()
	print("DoubleJump")
	if self.available then
		character.body:setLinearVelocity(0, -350)
		self.available = false
	end
end

function DoubleJump:OnGround()
	self.available = true
end
