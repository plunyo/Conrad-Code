local Animation = require("src.classes.Animation")
local utils = require("src.utils")

local game = {}

local FRAME_WIDTH = 12
local FRAME_HEIGHT = 18
local SHEET_WIDTH = 48
local SHEET_HEIGHT = 72
local SCALE = 5

local spriteSheet = love.graphics.newImage("assets/player/playerWalkSheet.png")

local playerAnims = {
    up = Animation:new(
    spriteSheet,

    {
        love.graphics.newQuad(0, 0, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH, 0, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 2, 0, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 3, 0, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
    },

    0.1,

    true,

    SCALE
    ),

    down = Animation:new(
    spriteSheet,

    {
        love.graphics.newQuad(0, FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH, FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 2, FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 3, FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
    },

    0.1,

    true,

    SCALE
    ),

    left = Animation:new(
    spriteSheet,
    
    {
        love.graphics.newQuad(0, FRAME_HEIGHT * 2, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH, FRAME_HEIGHT * 2, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 2, FRAME_HEIGHT * 2, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 3, FRAME_HEIGHT * 2, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
    },

    0.1,

    true,

    SCALE
    ),

    right = Animation:new(
    spriteSheet,

    {
        love.graphics.newQuad(0, FRAME_HEIGHT * 3, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH, FRAME_HEIGHT * 3, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 2, FRAME_HEIGHT * 3, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
        love.graphics.newQuad(FRAME_WIDTH * 3, FRAME_HEIGHT * 3, FRAME_WIDTH, FRAME_HEIGHT, SHEET_WIDTH, SHEET_HEIGHT),
    },
  
    0.1,

    true,

    SCALE
    ),
}

function game.load()
    for _, anim in pairs(playerAnims) do
        anim:play()
    end
end

function game.exit()

end

function game.update(dt)
    for _, anim in pairs(playerAnims) do
        anim:update(dt)
    end
end

function game.draw()
    playerAnims.down:draw(utils.sw / 2, utils.sh / 2)

    love.graphics.print("Game Scene", utils.sw / 2 - love.graphics.getFont():getWidth("Game Scene") / 2, utils.sh / 2 - love.graphics.getFont():getHeight() / 2)
end

return game
