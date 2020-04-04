-- Hot magma -> lava
minetest.register_craft({
   output = "default:lava_source",
   recipe = {
      {"nether:magma_hot", "nether:magma_hot", "nether:magma_hot"},
      {"nether:magma_hot", "nether:magma_hot", "nether:magma_hot"},
      {"nether:magma_hot", "nether:magma_hot", "nether:magma_hot"}
   }
})
