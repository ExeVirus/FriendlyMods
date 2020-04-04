more_monoids = {}

local function bound(min, v, max)
    return math.max(min, math.min(v, max))
end

more_monoids.sunlight_monoid = player_monoids.make_monoid({
    -- additive monoid, values between -1 and 1, cuts off if sum goes beyond those
    combine = function(sunlight1, sunlight2)
        if not sunlight1 then
            return sunlight2
        elseif not sunlight2 then
            return sunlight1
        else
            return sunlight1 + sunlight2
        end
    end,
    fold = function(t)
        local size = 0
        local sum = 0
        for _, v in pairs(t) do
            if v then
                sum = sum + v
                size = size + 1
            end
        end
        if size == 0 then
            return nil
        else
            return sum
        end
    end,
    identity = nil,
    apply = function(sunlight, player)
        if sunlight then
            sunlight = bound(0, (sunlight + 1) / 2, 1)
        end
        player:override_day_night_ratio(sunlight)
    end,
    on_change = function() return end,
})
