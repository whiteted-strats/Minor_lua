-- Make sure these are globals
blobSize = 0x1DC

-- Taken from Wyster's GuardData
-- You could equally just require Data\GE\GuardData, and write
--   metadatatable = GuardData.metadata

metadatatable = {
	{["offset"] = 0x000, ["size"] = 0x2, ["type"] = "hex", 		["name"] = "id"},
	{["offset"] = 0x004, ["size"] = 0x1, ["type"] = "unsigned", ["name"] = "rounds_fired_left"},
	{["offset"] = 0x005, ["size"] = 0x1, ["type"] = "unsigned", ["name"] = "rounds_fired_right"},
	{["offset"] = 0x006, ["size"] = 0x1, ["type"] = "hex", 		["name"] = "head_model"},	-- 0xFF = Special character (Natalya, Trevelyan etc...)
	{["offset"] = 0x007, ["size"] = 0x1, ["type"] = "enum", 	["name"] = "current_action"},
	{["offset"] = 0x00A, ["size"] = 0x1, ["type"] = "unsigned", ["name"] = "shots_near"},
	{["offset"] = 0x00B, ["size"] = 0x1, ["type"] = "unsigned", ["name"] = "shots_hit"},
	{["offset"] = 0x00C, ["size"] = 0x1, ["type"] = "unsigned", ["name"] = "alpha"},	
	{["offset"] = 0x00F, ["size"] = 0x1, ["type"] = "hex", 		["name"] = "body_model"},
	{["offset"] = 0x010, ["size"] = 0x1, ["type"] = "unsigned", ["name"] = "belligerency"},
	{["offset"] = 0x018, ["size"] = 0x4, ["type"] = "hex", 		["name"] = "position_data_pointer"},
	{["offset"] = 0x01C, ["size"] = 0x4, ["type"] = "hex", 		["name"] = "model_data_pointer"},	
	{["offset"] = 0x024, ["size"] = 0x4, ["type"] = "float", 	["name"] = "collision_radius"},	
	{["offset"] = 0x02C, ["size"] = 0x4, ["type"] = "unsigned", ["name"] = "fadeout_timer"},
	{["offset"] = 0x02C, ["size"] = 0xC, ["type"] = "vector", 	["name"] = "bond_position"},
	{["offset"] = 0x03C, ["size"] = 0xC, ["type"] = "vector", 	["name"] = "path_target_position"},
	{["offset"] = 0x060, ["size"] = 0xC, ["type"] = "vector", 	["name"] = "target_position"},
	{["offset"] = 0x070, ["size"] = 0x4, ["type"] = "float", 	["name"] = "path_segment_coverage"},
	{["offset"] = 0x074, ["size"] = 0x4, ["type"] = "float", 	["name"] = "path_segment_length"},
	{["offset"] = 0x094, ["size"] = 0x4, ["type"] = "float", 	["name"] = "segment_coverage"},
	{["offset"] = 0x098, ["size"] = 0x4, ["type"] = "float", 	["name"] = "segment_length"},
	{["offset"] = 0x0AC, ["size"] = 0x4, ["type"] = "float", 	["name"] = "clipping_height"},
	{["offset"] = 0x0BC, ["size"] = 0xC, ["type"] = "vector", 	["name"] = "position"},
	{["offset"] = 0x0D0, ["size"] = 0x4, ["type"] = "float", 	["name"] = "reaction_time"},	
	{["offset"] = 0x0D4, ["size"] = 0x4, ["type"] = "unsigned", ["name"] = "last_bond_detection_time"},		
	{["offset"] = 0x0EC, ["size"] = 0x4, ["type"] = "float", 	["name"] = "hearing_ability"},	
	{["offset"] = 0x0FC, ["size"] = 0x4, ["type"] = "float", 	["name"] = "damage_received"},
	{["offset"] = 0x100, ["size"] = 0x4, ["type"] = "float", 	["name"] = "health"},
	{["offset"] = 0x104, ["size"] = 0x4, ["type"] = "hex", 		["name"] = "action_block_pointer"},
	{["offset"] = 0x108, ["size"] = 0x2, ["type"] = "hex", 		["name"] = "action_block_offset"},
	{["offset"] = 0x10A, ["size"] = 0x2, ["type"] = "hex", 		["name"] = "action_block_return"},
	{["offset"] = 0x10C, ["size"] = 0x1, ["type"] = "hex", 		["name"] = "user_byte_1"},
	{["offset"] = 0x10D, ["size"] = 0x1, ["type"] = "hex", 		["name"] = "user_byte_2"},
	{["offset"] = 0x10F, ["size"] = 0x1, ["type"] = "hex", 		["name"] = "random_value"},
	{["offset"] = 0x110, ["size"] = 0x1, ["type"] = "unsigned",	["name"] = "timer"},
	{["offset"] = 0x114, ["size"] = 0x2, ["type"] = "hex", 		["name"] = "2328_preset"}
}
