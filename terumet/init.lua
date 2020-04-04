-- Terumet v1.10

-- Mod for open-source voxel game Minetest (https://www.minetest.net/)
-- Written for Minetest version 0.4.16
-- Creates a new ore in the world which can be used to make useful alloys
-- and heat-powered machines.

-- By Terumoc [https://github.com/Terumoc]
-- and with contributions from:
--  > RSL-Redstonier [https://github.com/RSL-Redstonier]
--  > Chem871 [https://github.com/Chemguy99] for many ideas and requests

--[[ Copyright (C) 2017-2018 Terumoc (Scott Horvath)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. ]]

terumet = {}
terumet.version = {major=1, minor=10, patch=0}
local ver = terumet.version
terumet.version_text = ver.major .. '.' .. ver.minor .. '.' .. ver.patch
terumet.mod_name = "terumet"

function terumet.pos_plus(pos, offset)
    return {
        x=pos.x + offset.x,
        y=pos.y + offset.y,
        z=pos.z + offset.z,
    }
end

-- empty function useful for where a callback is necessary but using nil would cause undesired default behavior
terumet.NO_FUNCTION = function() end

function terumet.recipe_3x3(i)
    return { 
        {i, i, i}, {i, i, i}, {i, i, i}
    }
end

function terumet.recipe_box(outer, inner)
    return {
        {outer, outer, outer}, {outer, inner, outer}, {outer, outer, outer}
    }
end

function terumet.format_time(t)
    return string.format('%.1f s', t or 0)
end

function terumet.do_lua_file(name)
    dofile(minetest.get_modpath(terumet.mod_name) .. '/' .. name .. '.lua')
end

function terumet.id(id, number)
    if number then
        return string.format('%s:%s %d', terumet.mod_name, id, number)
    else
        return string.format('%s:%s', terumet.mod_name, id)
    end
end

function terumet.give_player_item(pos, player, stack)
    local inv = player:get_inventory()
    local leftover = inv:add_item("main", stack)
    if leftover and not leftover:is_empty() then
        minetest.item_drop(leftover, player, player:get_pos())
    end
end

function terumet.tex(id)
    -- accepts both base ids (assuming this mod) and full mod ids
    -- ex: terumet.tex('ingot_raw') -> 'terumet_ingot_raw.png'
    --     terumet.tex('default:cobble') -> 'default_cobble.png'
    if id:match(':') then
        return string.format('%s.png', id:gsub(':', '_'))
    else
        return string.format('%s_%s.png', terumet.mod_name, id)
    end
end

function terumet.tex_comp(base_tex, overlay_id)
    return base_tex .. '^' .. terumet.tex(overlay_id)
end

terumet.do_lua_file('interop/terumet_api')
terumet.do_lua_file('options')
terumet.do_lua_file('machine/machine')
terumet.do_lua_file('machine/custom')
terumet.do_lua_file('material/raw')
terumet.do_lua_file('material/reg_alloy')
terumet.do_lua_file('material/upgrade')

terumet.reg_alloy('Terucopper', 'tcop', 1)
terumet.reg_alloy('Terusteel', 'tste', 2)
terumet.reg_alloy('Terugold', 'tgol', 3)
terumet.reg_alloy('Coreglass', 'cgls', 4)
terumet.reg_alloy('Teruchalcum', 'tcha', 2)

terumet.do_lua_file('material/ceramic')
terumet.do_lua_file('material/thermese')
terumet.do_lua_file('material/coil')
terumet.do_lua_file('material/htglass')

terumet.do_lua_file('material/crystallized')

local id = terumet.id
local tex = terumet.tex

terumet.do_lua_file('tool/reg_tools')

local sword_opts = terumet.options.tools.sword_damage

terumet.reg_tools('Pure Terumetal', 'raw',
    id('ingot_raw'),
    {2.0}, 10, 2, sword_opts.TERUMETAL
)
terumet.reg_tools('Terucopper', 'tcop', 
    id('ingot_tcop'),
    {3.2, 1.4, 0.8}, 40, 1, sword_opts.COPPER_ALLOY
)
terumet.reg_tools('Terusteel', 'tste', 
    id('ingot_tste'),
    {2.9, 1.3, 0.7}, 50, 2, sword_opts.IRON_ALLOY
)
terumet.reg_tools('Terugold', 'tgol', 
    id('ingot_tgol'),
    {2.7, 1.2, 0.63}, 60, 3, sword_opts.GOLD_ALLOY
)
terumet.reg_tools('Coreglass', 'cgls',
    id('ingot_cgls'),
    {2.5, 1.2, 0.7}, 75, 4, sword_opts.COREGLASS
)
terumet.reg_tools('Teruchalcum', 'tcha',
    id('ingot_tcha'),
    {1.8, 0.7, 0.45}, 90, 2, sword_opts.BRONZE_ALLOY
)

terumet.do_lua_file('tool/ore_saw')

terumet.do_lua_file('machine/heater/furnace_htr')
terumet.do_lua_file('machine/heater/solar_htr')
terumet.do_lua_file('machine/asmelt')
terumet.do_lua_file('machine/htfurnace')
terumet.do_lua_file('machine/vulcan')
terumet.do_lua_file('machine/thermobox')
terumet.do_lua_file('machine/thermdist')
terumet.do_lua_file('machine/heatray')

if unified_inventory then 
    terumet.do_lua_file('interop/unified_inventory')
end