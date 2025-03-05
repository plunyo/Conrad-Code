local Animation = require("src.classes.Animation")
local utils = require("src.utils")

local game = {}

-- Constants for animation settings
local FRAME_WIDTH = 12
local FRAME_HEIGHT = 18
local SHEET_WIDTH = 48
local SHEET_HEIGHT = 72
local SCALE = 5

-- Load the sprite sheet
local spriteSheet = love.graphics.newImage("assets/player/playerWalkSheet.png")

-- Define player animations
local function createAnimationFrames(startY, frameCount)
    local frames = {}
    for i = 0, frameCount - 1 do
        table.insert(
            frames,
            love.graphics.newQuad(
                i * FRAME_WIDTH,
                startY,
                FRAME_WIDTH,
                FRAME_HEIGHT,
                SHEET_WIDTH,
                SHEET_HEIGHT
            )
        )
    end
    return frames
end

local playerAnims = {
    up = Animation:new(
        spriteSheet,
        createAnimationFrames(0, 4),
        0.1,
        true,
        SCALE
    ),
    down = Animation:new(
        spriteSheet,
        createAnimationFrames(FRAME_HEIGHT, 4),
        0.1,
        true,
        SCALE
    ),
    left = Animation:new(
        spriteSheet,
        createAnimationFrames(FRAME_HEIGHT * 2, 4),
        0.1,
        true,
        SCALE
    ),
    right = Animation:new(
        spriteSheet,
        createAnimationFrames(FRAME_HEIGHT * 3, 4),
        0.1,
        true,
        SCALE
    ),
}

-- Load the game
function game.load()
    for _, anim in pairs(playerAnims) do
        anim:play()
    end
end

function game.exit()
    -- Clean up resources here if needed
end

-- Update the animations
function game.update(dt)
    for _, anim in pairs(playerAnims) do
        anim:update(dt)
    end
end

-- Draw the animations and game scene
function game.draw()
    playerAnims.down:draw(utils.sw / 2, utils.sh / 2)

    love.graphics.print(
        "Game Scene",
        utils.sw / 2 - love.graphics.getFont():getWidth("Game Scene") / 2,
        utils.sh / 2 - love.graphics.getFont():getHeight() / 2
    )
end

return game
