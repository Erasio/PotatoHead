function init_spells()
	current_spells = {}
	spell_input = ""
	max_spell_length = 0
end

function add_spell(spell)
	current_spells[table.getn(current_spells) + 1] = spell
	for i, temp_spell in pairs(current_spells) do
		if temp_spell.combination ~= nil then
			if string.len(temp_spell.combination) > max_spell_length then
				max_spell_length = string.len(temp_spell.combination)
			end
		else
			if temp_spell == nil then
				test = "No class"
			else
				test = "No combination"
			end
		end
	end
end

function enter_spell_command(input)
	spell_input = spell_input .. input
	for i, spell in pairs(current_spells) do
		if spell:check_spell(spell_input) then
			spell_input = ""
			break
		end
	end
	if string.len(spell_input) >= max_spell_length then
		spell_input = ""
	end
end