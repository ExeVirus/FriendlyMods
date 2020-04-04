minetest.register_node( "titanium:titanium_tv_1", {
    description = "Titanium TV",
    tile_images = { "titanium_tv_1.png" },
    is_ground_content = true,
    groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2},
    drop = 'titanium:titanium_tv_1',
    light_source = 8,
})

minetest.register_craft({
    output = 'titanium:titanium_tv_1',
    recipe = {
        {'default:steel_ingot', 'titanium:tougher_titanium', 'default:steel_ingot'},
        {'titanium:tougher_titanium', 'default:glass', 'titanium:tougher_titanium'},
        {'default:steel_ingot', 'titanium:tougher_titanium', 'default:steel_ingot'},
    }
})

minetest.register_node( "titanium:titanium_tv_2", {
    description = "Titanium TV",
    tile_images = { "titanium_tv_2.png" },
    is_ground_content = true,
    groups = {snappy=1,bendy=2,cracky=1,melty=2,level=2},
    drop = 'titanium:titanium_tv_1',
    light_source = 8,
})

minetest.register_abm(
    {nodenames = {"titanium:titanium_tv_1", "titanium:titanium_tv_2"},
    interval = 12,
    chance = 1,
    action = function(pos)
    local i = math.random(1,2)

        if i== 1 then
            minetest.add_node(pos,{name="titanium:titanium_tv_1"})
        end

        if i== 2 then
            minetest.add_node(pos,{name="titanium:titanium_tv_2"})
        end

   end
})
