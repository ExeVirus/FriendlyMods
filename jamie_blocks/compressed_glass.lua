
-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

--
--  Item Registration
--

--  Compressed Glass
minetest.register_craftitem("jamie_blocks:compressed_glass", {
	description = S("Compressed Glass"),
	inventory_image = "compressed_glass.png",
})
--
-- Node Registration
--


-- Compressed glass
minetest.register_node("jamie_blocks:compressed_glass", {
	description = S("Compressed Glass"),
	tiles = {"compressed_glass.png"},
        use_texture_alpha = true,
        groups = {cracky=1},
        sounds = default.node_sound_stone_defaults(),
})

--
-- Crafting
--

-- Compressed Glass
minetest.register_craft({
	output = 'jamie_blocks:compressed_glass 1',
	recipe = {
		{'default:glass', 'default:glass', 'default:glass'},
		{'default:glass', 'default:glass', 'default:glass'},
		{'default:glass', 'default:glass', 'default:glass'},
	}
})

-- Uncompress Glass
minetest.register_craft({
	output = 'default:glass 9',
	recipe = {
		{'jamie_blocks:compressed_glass'},
	}
})
