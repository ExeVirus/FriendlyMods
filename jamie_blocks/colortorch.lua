
--[[

Color Torch mod
======================

(c) Copyright BlockMen (2013-2015)
(C) Copyright sofar <sofar@foo-projects.org> (2016)
(c) Copyright Jamie_blocks (2019)

This mod changes the default torch drawtype from "torchlike" to "mesh",
giving the torch a three dimensional appearance. The mesh contains the
proper pixel mapping to make the animation appear as a particle above
the torch, while in fact the animation is just the texture of the mesh.


License:
~~~~~~~~
(c) Copyright BlockMen (2013-2015)

Textures and Meshes/Models:
CC-BY 3.0 BlockMen
Note that the models were entirely done from scratch by sofar.

Code:
Licensed under the GNU LGPL version 2.1 or higher.
You can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License
as published by the Free Software Foundation;

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

See LICENSE.txt and http://www.gnu.org/licenses/lgpl-2.1.txt

--]]

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local dyes = {
	{"white",      "White",      "basecolor_white",     "#DADADA"},
	{"grey",       "Grey",       "basecolor_grey",      "#828282"},
	{"black",      "Black",      "basecolor_black",     "#1D1D1D"},
	{"red",        "Red",        "basecolor_red",       "#A71111"},
	{"yellow",     "Yellow",     "basecolor_yellow",    "#FFDF11"},
	{"green",      "Green",      "basecolor_green",     "#59D71C"},
	{"cyan",       "Cyan",       "basecolor_cyan",      "#008189"},
	{"blue",       "Blue",       "basecolor_blue",      "#00468E"},
	{"magenta",    "Magenta",    "basecolor_magenta",   "#C8036C"},
	{"orange",     "Orange",     "excolor_orange",      "#D44F15"},
	{"violet",     "Violet",     "excolor_violet",      "#5C00AB"},
	{"brown",      "Brown",      "unicolor_dark_orange","#532A00"},
	{"pink",       "Pink",       "unicolor_light_red",  "#FF8787"},
	{"dark_grey",  "Dark Grey",  "unicolor_darkgrey",   "#3B3B3B"},
	{"dark_green", "Dark Green", "unicolor_dark_green", "#206600"},
}

for i = 1, #dyes do
	local name, desc, craft_color_group, colorst = unpack(dyes[i])

minetest.register_node("jamie_blocks:torch_"..name, {
	description = desc.." Torch",
	drawtype = "mesh",
	mesh = "torch_floor.obj",
	inventory_image = "torch_on_floor.png^[multiply:" .. colorst,
	wield_image = "torch_on_floor.png^[multiply:" .. colorst,
	tiles = {{
		    name = "torch_on_floor_animated.png^[multiply:" .. colorst,
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	liquids_pointable = false,
	light_source = 12,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1, torch=1},
	drop = "jamie_blocks:torch_"..name,
	selection_box = {
		type = "wallmounted",
		wall_bottom = {-1/8, -1/2, -1/8, 1/8, 2/16, 1/8},
	},
	sounds = default.node_sound_wood_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local def = minetest.registered_nodes[node.name]
		if def and def.on_rightclick and
			not (placer and placer:is_player() and
			placer:get_player_control().sneak) then
			return def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		local above = pointed_thing.above
		local wdir = minetest.dir_to_wallmounted(vector.subtract(under, above))
		local fakestack = itemstack
		if wdir == 0 then
			fakestack:set_name("jamie_blocks:torch_ceiling_"..name)
		elseif wdir == 1 then
			fakestack:set_name("jamie_blocks:torch_"..name)
		else
			fakestack:set_name("jamie_blocks:torch_wall_"..name)
		end

		itemstack = minetest.item_place(fakestack, placer, pointed_thing, wdir)
		itemstack:set_name("jamie_blocks:torch_"..name)

		return itemstack
	end
})

minetest.register_node("jamie_blocks:torch_wall_"..name, {
	drawtype = "mesh",
	mesh = "torch_wall.obj",
	tiles = {{
		    name = "torch_on_floor_animated.png^[multiply:" .. colorst,
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = 12,
	groups = {choppy=2, dig_immediate=3, flammable=1, not_in_creative_inventory=1, attached_node=1, torch=1},
	drop = "jamie_blocks:torch_"..name,
	selection_box = {
		type = "wallmounted",
		wall_side = {-1/2, -1/2, -1/8, -1/8, 1/8, 1/8},
	},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("jamie_blocks:torch_ceiling_"..name, {
	drawtype = "mesh",
	mesh = "torch_ceiling.obj",
	tiles = {{
		    name = "torch_on_floor_animated.png^[multiply:" .. colorst,
		    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.3}
	}},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = 12,
	groups = {choppy=2, dig_immediate=3, flammable=1, not_in_creative_inventory=1, attached_node=1, torch=1},
	drop = "jamie_blocks:torch_"..name,
	selection_box = {
		type = "wallmounted",
		wall_top = {-1/8, -1/16, -5/16, 1/8, 1/2, 1/8},
	},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_lbm({
	name = "jamie_blocks:3dtorch_"..name,
	nodenames = {"jamie_blocks:torch_"..name, "default:floor", "default:wall"},
	action = function(pos, node)
		if node.param2 == 0 then
			minetest.set_node(pos, {name = "jamie_blocks:torch_ceiling_"..name,
				param2 = node.param2})
		elseif node.param2 == 1 then
			minetest.set_node(pos, {name = "jamie_blocks:torch_"..name,
				param2 = node.param2})
		else
			minetest.set_node(pos, {name = "jamie_blocks:torch_wall_"..name,
				param2 = node.param2})
		end
	end
})

minetest.register_craft{
		type = "shapeless",
		output = "jamie_blocks:torch_" .. name,
		recipe = {"group:dye," .. craft_color_group, "group:torch"},
}

end