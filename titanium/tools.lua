
minetest.register_tool("titanium:sword", {
    description = "Titanium Sword",
    inventory_image = "titanium_sword.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[1]=2.00, [2]=0.60, [3]=0.20}, uses=100, maxlevel=2},
            snappy={times={[2]=0.60, [3]=0.20}, uses=100, maxlevel=1},
            choppy={times={[3]=0.70}, uses=100, maxlevel=0}
        },
        damage_groups = {fleshy=10.00}
    }
})

minetest.register_craft({
    output = 'titanium:sword',
    recipe = {
        {'', 'titanium:titanium', ''},
        {'', 'titanium:titanium', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_tool("titanium:axe", {
    description = "Titanium Axe",
    inventory_image = "titanium_axe.png",
    tool_capabilities = {
        max_drop_level=1,
        groupcaps={
            choppy={times={[1]=2.50, [2]=1.50, [3]=1.00}, uses=150, maxlevel=2},
            fleshy={times={[2]=1.00, [3]=0.50}, uses=120, maxlevel=1}
        },
        damage_groups = {fleshy=10.00}
    },
})

minetest.register_craft({
    output = 'titanium:axe',
    recipe = {
        {'titanium:titanium', 'titanium:titanium', ''},
        {'titanium:titanium', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_tool("titanium:shovel", {
    description = "Titanium Shovel",
    inventory_image = "titanium_shovel.png",
    tool_capabilities = {
        max_drop_level=1,
        groupcaps={
            crumbly={times={[1]=1.0, [2]=0.50, [3]=0.50}, uses=150, maxlevel=3}
        },
        damage_groups = {fleshy=4.00}
    },
})

minetest.register_craft({
    output = 'titanium:shovel',
    recipe = {
        {'', 'titanium:titanium', ''},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

minetest.register_tool("titanium:pick", {
    description = "Titanium Pickaxe",
    inventory_image = "titanium_pick.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level=3,
        groupcaps={
            cracky={times={[1]=2.4, [2]=1.0, [3]=0.6}, uses=160, maxlevel=3},
            crumbly={times={[1]=2.4, [2]=1.0, [3]=0.6}, uses=160, maxlevel=3},
            snappy={times={[1]=2.4, [2]=1.0, [3]=0.6}, uses=160, maxlevel=3}
        },
        damage_groups = {fleshy=4.00}
    },
})

minetest.register_craft({
    output = 'titanium:pick',
    recipe = {
        {'titanium:titanium', 'titanium:titanium', 'titanium:titanium'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})
