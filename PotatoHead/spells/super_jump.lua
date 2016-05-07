require "spells.spell"

SuperJump = inheritsFrom(Spell)
SuperJump_mt = { __index = SuperJump }
SuperJump.combination = "uud"

function SuperJump:cast()
	print("SuperJump!")
	if character.is_on_ground then
		character.body:applyLinearImpulse(0, -200)
		return true
	else
		return false
	end
end
