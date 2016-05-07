Spell = {}
Spell_mt = { __index = Spell }

function Spell:create()
	local spell = {}
	setmetatable(spell, Spell_mt)
	return spell
end

function Spell:check_spell(input)
	if self.combination == input then
		local return_value = self:cast()
		if return_value then
			change_spell_color = 1
			spell_color = {0, 255, 60}
		else
			change_spell_color = 1
			spell_color = {255, 0, 0}
		end
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
