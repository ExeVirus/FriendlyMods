local conf = {}

-- set this to 'true' to make ingots 8 times larger
conf.is_big = minetest.settings:get_bool("ingots.big", true)

return conf
