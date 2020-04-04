-- Stairsplus.lua

if minetest.get_modpath("moreblocks").."/stairsplus" then

  local cave_nodes = { -- Default stairs/slabs/panels/microblocks:
    "glow_emerald",
    "glow_mese",
    "glow_ruby",
    "glow_amethyst",
    "glow_ore",
    "glow_emerald_ore",
    "glow_ruby_ore",
    "glow_amethyst_ore",
    "hot_cobble",
    "glow_obsidian",
    "glow_obsidian_2",
  }


  for _, name in pairs(cave_nodes) do
    local mod = "caverealms"
    local nodename = mod .. ":" .. name
    local ndef = table.copy(minetest.registered_nodes[nodename])
    ndef.sunlight_propagates = true


    -- Use the primary tile for all sides of cut glasslike nodes and disregard paramtype2.
    if #ndef.tiles > 1 and ndef.drawtype and ndef.drawtype:find("glass") then
      ndef.tiles = {ndef.tiles[1]}
      ndef.paramtype2 = nil
    end

    mod = "moreblocks"
    stairsplus:register_all(mod, name, nodename, ndef)
    minetest.register_alias_force("stairs:stair_" .. name, mod .. ":stair_" .. name)
    minetest.register_alias_force("stairs:stair_outer_" .. name, mod .. ":stair_" .. name .. "_outer")
    minetest.register_alias_force("stairs:stair_inner_" .. name, mod .. ":stair_" .. name .. "_inner")
    minetest.register_alias_force("stairs:slab_"  .. name, mod .. ":slab_"  .. name)
  end
end