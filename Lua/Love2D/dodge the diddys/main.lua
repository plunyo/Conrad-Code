local player = require("src.player"):new()
local testDiddy = require("src.diddy"):new()

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
    testDiddy:draw()
end
