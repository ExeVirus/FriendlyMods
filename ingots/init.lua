--[[
	Ingots - allows the placemant of ingots in the world
	Copyright (C) 2018  Skamiz Kazzarch

	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
]]--

ingots = {}

local conf = dofile(minetest.get_modpath("ingots").."/conf.lua")
dofile(minetest.get_modpath("ingots").."/api.lua")

--Here you can make individual choices per ingot on which varian will be used.
--To disable the ability of an ingot to be placed just comment out it's registration line.
if minetest.get_modpath("basic_materials") then
		ingots.register_ingots("basic_materials:brass_ingot", "ingot_brass.png", conf.is_big)
end

if minetest.get_modpath("default") then
		ingots.register_ingots("default:copper_ingot", "ingot_copper.png", conf.is_big)
		ingots.register_ingots("default:tin_ingot", "ingot_tin.png", conf.is_big)
		ingots.register_ingots("default:bronze_ingot", "ingot_bronze.png", conf.is_big)
		ingots.register_ingots("default:steel_ingot", "ingot_steel.png", conf.is_big)
		ingots.register_ingots("default:gold_ingot", "ingot_gold.png", conf.is_big)
end

if minetest.get_modpath("moreores") then
		ingots.register_ingots("moreores:silver_ingot", "ingot_silver.png", conf.is_big)
		ingots.register_ingots("moreores:mithril_ingot", "ingot_mithril.png", conf.is_big)
end

if minetest.get_modpath("technic_worldgen") then
		ingots.register_ingots("technic:stainless_steel_ingot", "ingot_stainless_steel.png", conf.is_big)
		ingots.register_ingots("technic:carbon_steel_ingot", "ingot_carbon_steel.png", conf.is_big)
		ingots.register_ingots("technic:cast_iron_ingot", "ingot_cast_iron.png", conf.is_big)

		ingots.register_ingots("technic:chromium_ingot", "ingot_chromium.png", conf.is_big)
		ingots.register_ingots("technic:lead_ingot", "ingot_lead.png", conf.is_big)
		ingots.register_ingots("technic:uranium_ingot", "ingot_uranium.png", conf.is_big)
		ingots.register_ingots("technic:zinc_ingot", "ingot_zinc.png", conf.is_big)
end

if minetest.get_modpath("terumet") then
		ingots.register_ingots("terumet:ingot_cgls", "ingot_coreglass.png", conf.is_big)
		ingots.register_ingots("terumet:ingot_raw", "ingot_terumetal.png", conf.is_big)
		ingots.register_ingots("terumet:ingot_tcha", "ingot_teruchalcum.png", conf.is_big)
		ingots.register_ingots("terumet:ingot_tcop", "ingot_terucopper.png", conf.is_big)
		ingots.register_ingots("terumet:ingot_tgol", "ingot_terugold.png", conf.is_big)
		ingots.register_ingots("terumet:ingot_tste", "ingot_terusteel.png", conf.is_big)
		ingots.register_ingots("terumet:ingot_ttin", "ingot_terutin.png", conf.is_big)
end
