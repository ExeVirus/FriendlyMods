if minetest.global_exists("armor") and minetest.global_exists("more_monoids") then
    local damage_period = 19
    local damage_amount = 100

    armor:register_armor("titanium:sam_titanium", {
        description = "Night Vision Goggles",
        inventory_image = "sam_titanium.png",
        texture = "goggles_texture",
        preview = "goggles_preview",
        armor_groups = {fleshy=0},
        groups = {
            armor_head = 1,
            armor_use = 0,
            armor_heal = 0,
            armor_water = 0,
            armor_fire = 0,
            physics_speed = 0,
            physics_gravity = 0,
            physics_jump = 0,
        },
        damage_groups = {},

        on_equip = function(player, index, stack)
            local wear = stack:get_wear()
            if (65535 - wear) > damage_amount then
                more_monoids.sunlight_monoid:add_change(player, 1, "titanium:goggles")
            end
        end,
        on_unequip = function(player, index, stack)
            more_monoids.sunlight_monoid:del_change(player, "titanium:goggles")
        end,
    })

    minetest.register_craft({
        output = "titanium:sam_titanium",
        recipe = {
            {"titanium:titanium_plate", "terumet:block_tglassglow",     "titanium:titanium_plate"},
            {"titanium:glass",          "titanium:titanium_plate",      "titanium:glass"},
            {"titanium:titanium_plate", "terumet:item_batt_therm_full", "titanium:titanium_plate"},
        }
    })

    -- terumet.register_repairable_item -- can't use this here cuz of dependency loop

    local timer = 0
    minetest.register_globalstep(function(dtime)
        timer = timer + dtime;
        if timer >= damage_period then
            timer = timer - damage_period
            for _, player in ipairs(minetest.get_connected_players()) do
                local player_name = player:get_player_name()
                local armor_inv = minetest.get_inventory({type="detached", name=player_name.."_armor"})
                for index = 1, 6 do
                    local stack = armor_inv:get_stack("armor", index)
                    if stack:get_name() == "titanium:sam_titanium" then
                        local wear = stack:get_wear()
                        if (65535 - wear) > damage_amount then
                            armor:damage(player, index, stack, damage_amount)
                        else
                            more_monoids.sunlight_monoid:del_change(player, "titanium:goggles")
                        end
                    end
                end
            end
        end
    end)

else
    minetest.register_craftitem("titanium:sam_titanium", {
        description = "Night Vision Goggles",
        inventory_image = "sam_titanium.png",
        wield_image = "sam_titanium.png",
    })
end

