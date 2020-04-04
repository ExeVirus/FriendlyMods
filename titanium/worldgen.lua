minetest.register_ore({
    ore_type = "scatter",
    ore =      "titanium:titanium_in_ground",
    wherein =  "default:stone",
    noise_params = {
        offset = 0,
        scale = 1,
        spread = {x=100, y=100, z=100},
        seed = 21,
        octaves = 2,
        persist = 0.70,
    },
    clust_scarcity = 8192,
    clust_num_ores = 5,
    clust_size = 2,
    y_min = -25000,
    y_max = -1500,
})
