require "spells.spell"

TestSpell = inheritsFrom(Spell)
TestSpell.combination = "uud"

function TestSpell:cast()
	if character.is_on_ground then
		character.body:applyLinearImpulse(0, -300)
	end
end