local Vector2 = require("src.Vector2")
local utils = require("src.utils")

local Player = {}
Player.__index = Player

function Player:new()
    local instance = setmetatable({}, Player)

    instance.position = Vector2:new(
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2
    )

    instance.direction = Vector2:new(0, 0)

    instance.speed = 400
    instance.size = 40

    return instance
end

function Player:update(dt)
    self.direction = utils.getVector({"up"}, {"down"}, {"left"}, {"right"}):normalize()

    local movement = {
        x = self.direction.x * self.speed,
        y = self.direction.y * self.speed
    }

    self.position.x = utils.clamp(self.position.x + movement.x, 0, love.graphics.getWidth() - self.size)
    self.position.y = utils.clamp(self.position.y + movement.y, 0, love.graphics.getHeight() - self.size)
end

function Player:draw()
    love.graphics.circle("line", self.position.x, self.position.y, self.size)
end

return Player
