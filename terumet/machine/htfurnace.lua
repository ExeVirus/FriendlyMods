local opts = terumet.options.furnace
local base_opts = terumet.options.machine

local base_mach = terumet.machine

local base_htf = {}
base_htf.unlit_id = terumet.id('mach_htfurn')
base_htf.lit_id = terumet.id('mach_htfurn_lit')

-- state identifier consts
base_htf.STATE = {}
base_htf.STATE.IDLE = 0
base_htf.STATE.COOKING = 1

function base_htf.generate_formspec(furnace)
    local fs = 'size[10,9]'..base_mach.fs_start..
    --player inventory
    base_mach.fs_player_inv(0,4.75)..
    base_mach.fs_owner(furnace,8,0)..
    --input inventory
    base_mach.fs_input(furnace,0,1.5,2,2)..
    --output inventory
    base_mach.fs_output(furnace,6,1.5,2,2)..
    --fuel slot
    base_mach.fs_fuel_slot(furnace,6.5,0)..
    --current status
    'label[0,0;High-Temperature Furnace]'..
    'label[0,0.5;' .. furnace.status_text .. ']'..
    base_mach.fs_heat_info(furnace,4.25,1.5)..
    base_mach.fs_heat_mode(furnace,4.25,4)..
    base_mach.fs_upgrades(furnace,8.75,1)
    if furnace.state == base_htf.STATE.COOKING then
        fs=fs..'image[3.5,1.75;1,1;terumet_gui_product_bg.png]item_image[3.5,1.75;1,1;'..furnace.inv:get_stack('result',1):get_name()..']'
    end
    --list rings
    fs=fs.."listring[current_player;main]"..
	"listring[context;in]"..
    "listring[current_player;main]"..
    "listring[context;out]"
    return fs
end

function base_htf.generate_infotext(furnace)
    return string.format('High-Temp Furnace (%.1f%% heat): %s', base_mach.heat_pct(furnace), furnace.status_text)
end

function base_htf.init(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    inv:set_size('fuel', 1)
    inv:set_size('in', 4)
    inv:set_size('result', 1)
    inv:set_size('out', 4)
    inv:set_size('upgrade', 4)
    local init_furnace = {
        class = base_htf.unlit_nodedef._terumach_class,
        state = base_htf.STATE.IDLE,
        state_time = 0,
        heat_level = 0,
        max_heat = opts.MAX_HEAT,
        heat_xfer_mode = base_mach.HEAT_XFER_MODE.ACCEPT,
        status_text = 'New',
        inv = inv,
        meta = meta,
        pos = pos
    }
    base_mach.write_state(pos, init_furnace)
end

function base_htf.get_drop_contents(machine)
    local drops = {}
    default.get_inventory_drops(machine.pos, "fuel", drops)
    default.get_inventory_drops(machine.pos, 'in', drops)
    default.get_inventory_drops(machine.pos, "out", drops)
    default.get_inventory_drops(machine.pos, 'upgrade', drops)
    return drops
end

function base_htf.do_processing(furnace, dt)
    if furnace.state == base_htf.STATE.COOKING and base_mach.expend_heat(furnace, furnace.heat_cost, 'Cooking') then
        local result_stack = furnace.inv:get_stack('result', 1)
        local result_name = result_stack:get_definition().description
        furnace.state_time = furnace.state_time - dt
        if furnace.state_time <= 0 then
            local out_inv, out_list = base_mach.get_output(furnace)
            if out_inv then
                if out_inv:room_for_item(out_list, result_stack) then
                    furnace.inv:set_stack('result', 1, nil)
                    out_inv:add_item(out_list, result_stack)
                    furnace.state = base_htf.STATE.IDLE
                else
                    furnace.status_text = result_name .. ' ready - no output space!'
                    furnace.state_time = -0.1
                end
            else
                furnace.status_text = 'No output'
                furnace.state_time = -0.1
            end
        else
            furnace.status_text = 'Cooking ' .. result_name .. ' (' .. terumet.format_time(furnace.state_time) .. ')'
        end
    end
end

function base_htf.check_new_processing(furnace)
    if furnace.state ~= base_htf.STATE.IDLE then return end
    local cook_result
    local cook_after
    local in_inv, in_list = base_mach.get_input(furnace)
    if not in_inv then
        furnace.status_text = 'No input'
        return
    end
    for slot = 1,in_inv:get_size(in_list) do
        local input_stack = in_inv:get_stack(in_list, slot)
        cook_result, cook_after = minetest.get_craft_result({method = 'cooking', width = 1, items = {input_stack}})
        if input_stack:get_name() == 'terumet:block_thermese' then
            cook_result = {item='default:mese_crystal_fragment',time=2} -- fix heat exploit, sorry!
            minetest.sound_play( 'default_break_glass', {
                pos = furnace.pos,
                gain = 0.3,
                max_hear_distance = 16
            })
        end
        if cook_result.time ~= 0 then
            furnace.state = base_htf.STATE.COOKING
            in_inv:set_stack(in_list, slot, cook_after.items[1])
            furnace.inv:set_stack('result', 1, cook_result.item)
            furnace.state_time = math.floor(cook_result.time * opts.TIME_MULT * furnace.class.timer)
            furnace.heat_cost = opts.COST_COOKING_HU
            if base_mach.has_upgrade(furnace, 'speed_up') then 
                furnace.state_time = furnace.state_time / 2 
                furnace.heat_cost = furnace.heat_cost * 2
            end
            furnace.status_text = 'Accepting ' .. input_stack:get_definition().description .. ' for cooking...'
            return
        end
    end
    furnace.status_text = 'Idle'
end

function base_htf.tick(pos, dt)
    -- read state from meta
    local furnace = base_mach.read_state(pos)

    local venting
    if base_mach.check_overheat(furnace, opts.MAX_HEAT) then
        venting = true
    else
        base_htf.do_processing(furnace, dt)
        base_htf.check_new_processing(furnace)
        base_mach.process_fuel(furnace)
    end

    if furnace.state ~= base_htf.STATE.IDLE and (not furnace.need_heat) then
        -- if still processing and not waiting for heat, reset timer to continue processing
        base_mach.set_timer(furnace)
        base_mach.set_node(pos, base_htf.lit_id)
        base_mach.generate_particle(pos)
    else
        base_mach.set_node(pos, base_htf.unlit_id)
    end

    if venting or base_mach.has_upgrade(furnace, 'ext_input') then base_mach.set_timer(furnace) end
    -- write status back to meta
    base_mach.write_state(pos, furnace)

end

base_htf.unlit_nodedef = base_mach.nodedef{
    -- node properties
    description = "High-Temperature Furnace",
    tiles = {
        terumet.tex('htfurn_top_unlit'), terumet.tex('block_ceramic'),
        terumet.tex('htfurn_sides'), terumet.tex('htfurn_sides'),
        terumet.tex('htfurn_sides'), terumet.tex('htfurn_front')
    },
    -- callbacks
    on_construct = base_htf.init,
    on_timer = base_htf.tick,
    -- terumet machine class data
    _terumach_class = {
        name = 'High-Temperature Furnace',
        timer = 0.5,
        drop_id = base_htf.unlit_id,
        get_drop_contents = base_htf.get_drop_contents,
        on_read_state = function(htfurnace)
            htfurnace.heat_cost = htfurnace.meta:get_int('heatcost') or 0
        end,
        on_write_state = function(htfurnace)
            htfurnace.meta:set_string('formspec', base_htf.generate_formspec(htfurnace))
            htfurnace.meta:set_string('infotext', base_htf.generate_infotext(htfurnace))
            htfurnace.meta:set_int('heatcost', htfurnace.heat_cost or 0)
        end
    }
}

base_htf.lit_nodedef = {}
for k,v in pairs(base_htf.unlit_nodedef) do base_htf.lit_nodedef[k] = v end
base_htf.lit_nodedef.on_construct = nil -- lit node shouldn't be constructed by player
base_htf.lit_nodedef.tiles = {
    terumet.tex('htfurn_top_lit'), terumet.tex('block_ceramic'),
    terumet.tex('htfurn_sides'), terumet.tex('htfurn_sides'),
    terumet.tex('htfurn_sides'), terumet.tex('htfurn_front')
}
base_htf.lit_nodedef.groups={cracky=1, not_in_creative_inventory=1}
base_htf.lit_nodedef.light_source = 10


minetest.register_node(base_htf.unlit_id, base_htf.unlit_nodedef)
minetest.register_node(base_htf.lit_id, base_htf.lit_nodedef)

minetest.register_craft{ output = base_htf.unlit_id, recipe = {
    {terumet.id('item_coil_tcop'), terumet.id('item_coil_tcop'), terumet.id('item_coil_tcop')},
    {terumet.id('item_ceramic'), terumet.id('frame_tste'), terumet.id('item_ceramic')},
    {terumet.id('item_ceramic'), terumet.id('item_ceramic'), terumet.id('item_ceramic')}
}}

tubelib.register_node(base_htf.unlit_id, {base_htf.lit_id}, {
    on_pull_item = function(pos, side, player_name)
        if minetest.is_protected(pos, player_name) then
            return nil
        end
        local inv = minetest.get_meta(pos):get_inventory()
        return base_mach.get_item_from_inventory(inv, "out")
    end,
    on_push_item = function(pos, side, item, player_name)
        if minetest.is_protected(pos, player_name) then
            return false
        end
        local inv = minetest.get_meta(pos):get_inventory()
        return base_mach.add_item_to_inventory(inv, "in", item)
    end,
    on_unpull_item = function(pos, side, item, player_name)
        if minetest.is_protected(pos, player_name) then
            return false
        end
        return base_mach.add_item_to_inventory(inv, "out", item)
    end,
    on_recv_message = function(pos, topic, payload) end
})
