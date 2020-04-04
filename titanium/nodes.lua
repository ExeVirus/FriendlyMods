minetest.register_craftitem( "titanium:titanium", {
    description = "Titanium",
    inventory_image = "titanium_titanium.png",
    on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_node( "titanium:titanium_in_ground", {
    description = "Titanium Ore",
    tile_images = { "default_stone.png^titanium_titanium_in_ground.png" },
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
    drop = 'craft "titanium:titanium" 1',
})

minetest.register_node( "titanium:block", {
    description = "Titanium Block",
    tile_images = { "titanium_block.png" },
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
    output = 'titanium:block',
    recipe = {
        {'titanium:titanium', 'titanium:titanium', 'titanium:titanium'},
        {'titanium:titanium', 'titanium:titanium', 'titanium:titanium'},
        {'titanium:titanium', 'titanium:titanium', 'titanium:titanium'},
    }
})

minetest.register_craft({
    output = 'titanium:titanium 9',
    recipe = {
        {'', 'titanium:block', ''},
    }
})

minetest.register_node("titanium:glass", {
    description = "Titanium Glass",
    drawtype = "glasslike",
    tile_images = {"titanium_glass.png"},
    light_propagates = true,
    paramtype = "light",
    sunlight_propagates = true,
    is_ground_content = true,
    groups = {snappy=1,cracky=2,oddly_breakable_by_hand=2},
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
    output = 'titanium:glass 3',
    recipe = {
        {'', 'titanium:titanium', ''},
        {'titanium:titanium', 'default:glass', 'titanium:titanium'},
        {'', 'titanium:titanium', ''},
    }
})

minetest.register_craftitem( "titanium:tougher_titanium", {
    description = "Tougher Titanium",
    inventory_image = "tougher_titanium.png",
    on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_craft({
    output = 'titanium:tougher_titanium',
    recipe = {
        {'titanium:titanium', 'titanium:titanium'},
        {'titanium:titanium', 'titanium:titanium'},
    }
})

minetest.register_node( "titanium:titanium_plate", {
    description = "Titanium Plate",
    tile_images = {"titanium_plate.png"},
    inventory_image = "titanium_plate.png",
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
    output = 'titanium:titanium_plate 9',
    recipe = {
        {'titanium:titanium', 'titanium:titanium', 'titanium:titanium'},
        {'titanium:titanium', 'titanium:tougher_titanium', 'titanium:titanium'},
        {'titanium:titanium', 'titanium:titanium', 'titanium:titanium'},
    }
})
