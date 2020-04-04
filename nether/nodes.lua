-- Nether fumes (atmosphere)
minetest.register_node("nether:fumes", {
   descriptions = "Nether Fumes (you hacker you)",
   drawtype = "airlike",
   groups = {not_in_creative_inventory = 1},
   drop = "",
   walkable = false,
   pointable = false,
   diggable = false,
   buildable_to = true,
   sunlight_propagates = true,
   is_ground_content = false,
   floodable = false,
   paramtype = "light"
})

-- Magma

minetest.register_node("nether:magma_hot", {
   description = "Hot Nether Magma",
   drawtype = "liquid",
   tiles = {"nether_magma.png"},
   groups = {crumbly = 1},
   is_ground_content = true,
   light_source = 10,
   walkable = false,
   pointable = true,
   diggable = true,
   buildable_to = false,
   paramtype = "light",
   damage_per_second = 2,
   liquidtype = "source",
   liquid_renewable = false,
   liquid_alternative_flowing = "nether:magma_hot",
   liquid_alternative_source = "nether:magma_hot",
   liquid_viscosity = 7,
   liquids_pointable = true,
   liquid_range = 0
})

minetest.register_node("nether:magma", {
   description = "Nether Magma",
   groups = {crumbly = 2, cracky = 1},
   tiles = {"nether_magma_dim.png"},
   is_ground_content = true,
   light_source = 3,
   paramtype = "light"
})

-- Basic nether materials (rack, sand, etc)

minetest.register_node("nether:rack", {
   description = "Nether Rack",
   groups = {cracky = 3, level = 2},
   tiles = {"nether_rack.png"},
   is_ground_content = true,
   sounds = default.node_sound_stone_defaults()
})

minetest.register_node("nether:sand", {
	description = "Nethersand",
	tiles = {"nether_sand.png"},
	is_ground_content = true,
	groups = {crumbly = 3, level = 2},
	sounds = default.node_sound_gravel_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.45},
	}),
})

minetest.register_node("nether:glowstone", {
	description = "Glowstone",
	tiles = {"nether_glowstone.png"},
	is_ground_content = true,
	light_source = 14,
	paramtype = "light",
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	on_blast = function (pos, intensity) end
})

minetest.register_node("nether:brick", {
	description = "Nether Brick",
	tiles = {"nether_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, level = 2},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function (pos, intensity) end
})

minetest.register_node("nether:fence_nether_brick", {
	description = "Nether Brick Fence",
	drawtype = "fencelike",
	tiles = {"nether_brick.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky = 2, level = 2},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function (pos, intensity) end
})

minetest.register_craft({
	output = "nether:brick 4",
	recipe = {
		{"nether:rack", "nether:rack"},
		{"nether:rack", "nether:rack"},
	}
})

minetest.register_craft({
	output = "nether:fence_nether_brick 6",
	recipe = {
		{"nether:brick", "nether:brick", "nether:brick"},
		{"nether:brick", "nether:brick", "nether:brick"},
	},
})

stairsplus:register_all("nether", "brick", "nether:brick", {
	description = "Nether Brick",
	groups = {cracky = 2, level = 2},
	tiles = {"nether_brick.png"},
	sounds = default.node_sound_stone_defaults(),
})

-- Ores
minetest.register_node("nether:titanium_ore", {
   description = "Titanium Ore",
   groups = {cracky = 1},
   tiles = {"nether_rack.png^titanium_titanium_in_ground.png"},
   drop = "titanium:titanium"
})

minetest.register_node("nether:heart_ore", {
	definition = "Nether Heart Ore",
	tiles = {"nether_heart_ore.png"},
	groups = {cracky = 1, level = 2},
	drop = "nether:heart",
	on_blast = function (pos, intensity) end
})

minetest.register_node("nether:bedrock", {
	description = "Bedrock",
	tiles = {"bedrock.png"},
	is_ground_content = false,
	diggable = false,
	damage_per_second = 500, -- Keep hackers from glitching through
	drop = "",
	on_blast = function (pos, intensity) end -- Nothing happens with TNT
})

if minetest.get_modpath("technic_worldgen") then
	minetest.register_node("nether:sulfur_ore", {
		description = "Sulfur ore",
		groups = {cracky = 1},
		tiles = {"nether_rack.png^technic_mineral_sulfur.png"},
		drop = "technic:sulfur_lump",
	})
end
