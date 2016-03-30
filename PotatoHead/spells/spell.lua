Spell = {}
Spell_mt = { __index = Spell }

function Spell:create()
	local spell = {}
	setmetatable(spell, Spell_mt)
	return spell
end

function Spell:check_spell(input)
	if self.combination == input then
		self:cast()
		return true
	end
	return false
end

function Spell:spell_length()
	return string.len(self.combination)
end

function Spell:cast()
	test = "No spell implemented. Fell back to spell.lua"
end
