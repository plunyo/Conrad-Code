sti = require('libraries.sti')

local game = {}

game.font = 'assets/fonts/fontyfont.ttf'
game.state = "menu"
game.paused = false

local menuBackgrounds = {
    love.graphics.newImage("assets/sprites/bgmenu.png"),
    love.graphics.newImage("assets/sprites/bgmenu1.png")
}

game.menupng = menuBackgrounds[love.math.random(1, #menuBackgrounds)]
game.map = sti("assets/maps/map.lua")
game.window = {
    x = 800,
    y = 600
}

function game.fs(work)
    if work then
        love.window.setMode(game.window.x, game.window.y, {fullscreen = true})
    end
end

function game.start()
    game.state = "lvl1"
end

function game.quit()
    love.event.quit()
end

function game.title()
    local text = "Melbourne"
    local fontSize = 100
    local font = love.graphics.newFont("assets/fonts/fontyfont.ttf", fontSize)
    love.graphics.setFont(font)
    local textWidth = font:getWidth(text)
    local textX = (game.window.x - textWidth) / 2
    love.graphics.print(text, textX, game.window.y / 3)
end

function game.sound(sound, loop)
    local noise = love.audio.newSource("assets/sounds/" .. sound, "static")
    noise:play()
    if loop then
        noise:setLooping(true)
    end
    return noise
end

function game.setup()
    wf = require("libraries.windfield")
    world = wf.newWorld(0, 0, true)

    anim8 = require("libraries.anim8")
    love.graphics.setDefaultFilter("nearest", "nearest")

    camera = require('libraries.camera')
    game.cam = camera()

    ui = require("src.ui")
    map = require('src.map')
    player = require('src.player')

    game.camera = {}

    game.window.x, game.window.y = love.window.getDesktopDimensions()
    
    game.fs(true)
    game.sound('bgmusic.mp3', true)

    map.colliders()
end

return game
