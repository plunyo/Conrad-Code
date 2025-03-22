sti = require('libraries.sti')

local game = {}

game.font = 'assets/fonts/fontyfont.ttf'
game.state = "menu"
game.paused = false

local menuBackgrounds = {
    love.graphics.newImage("assets/sprites/bgmenu.png"),
    love.graphics.newImage("assets/sprites/bgmenu1.png"),
    love.graphics.newImage("assets/sprites/bgmenu2.png")
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

function game.menu()
    love.audio.setVolume(1.0)
    game.state = "menu"

    love.graphics.draw(game.menupng, 0, 0, 0, love.graphics.getWidth() / game.menupng:getWidth(), love.graphics.getHeight() / game.menupng:getHeight())

    local buttonWidth = game.window.x / 6
    local buttonHeight = game.window.y / 12
    local buttonMargin = game.window.x / 40
    local totalButtonWidth = buttonWidth * 3 + buttonMargin * 2
    local startX = (game.window.x - totalButtonWidth) / 2

    ui.newButton("Start Game", game.window.x / 80, {0, 0, 0}, startX, game.window.y / 15, buttonWidth, buttonHeight, {1, 1, 1}, {190 / 255, 190 / 255, 190 / 255}, game.start)
    ui.newButton("Settings", game.window.x / 80, {0, 0, 0}, startX + buttonWidth + buttonMargin, game.window.y / 15, buttonWidth, buttonHeight, {1, 1, 1}, {190 / 255, 190 / 255, 190 / 255}, game.quit)
    ui.newButton("Exit to Desktop", game.window.x / 80, {0, 0, 0}, startX + 2 * (buttonWidth + buttonMargin), game.window.y / 15, buttonWidth, buttonHeight, {1, 1, 1}, {190 / 255, 190 / 255, 190 / 255}, game.quit)

    local text = "Melbourne"
    local fontSize = game.window.x / 8
    local font = love.graphics.newFont("assets/fonts/fontyfont.ttf", fontSize)
    love.graphics.setFont(font)
    local textWidth = font:getWidth(text)
    local textX = (game.window.x - textWidth) / 2
    love.graphics.print(text, textX, game.window.y / 4 * 3)
end


function game.sound(sound, loop)
    local noise = love.audio.newSource("assets/sounds/" .. sound, "static")
    noise:play()
    if loop then
        noise:setLooping(true)
    end
    return noise
end

function game.pause()
    game.paused = true
    ui.newButton("Exit to Menu", game.window.x / 80, {0, 0, 0}, game.window.x - game.window.x / 6 - 10, 10, game.window.x / 6, game.window.y / 12, {1, 1, 1}, {190 / 255, 190 / 255, 190 / 255}, game.menu)
    ui.newButton("Unpause", game.window.x / 80, {0, 0, 0}, game.window.x / 2 - game.window.x / 6 / 2, game.window.y - game.window.y / 8, game.window.x / 6, game.window.y / 12, {1, 1, 1}, {190 / 255, 190 / 255, 190 / 255}, game.unpause)
    love.audio.setVolume( 0.0 )
end

function game.unpause()
    game.paused = false
end

function game.camClamp()
    game.cam:lookAt(player.x, player.y)
    --[[
    local camX, camY = game.cam:position()
    local camWidth, camHeight = love.graphics.getWidth() / game.cam.scale, love.graphics.getHeight() / game.cam.scale
    local mapWidth, mapHeight = game.map.width * game.map.tilewidth, game.map.height * game.map.tileheight

    local clampX = math.min(math.max(camWidth / 2, player.x), mapWidth - camWidth / 2)
    local clampY = math.min(math.max(camHeight / 2, player.y), mapHeight - camHeight / 2)
        
    game.cam:lookAt(clampX, clampY)
    ]]--
end

function game.zoomIn(zoomScale)
    if game.cam.scale < 2 then
        game.cam.scale = game.cam.scale + zoomScale
    end
end

function game.zoomOut(zoomScale)
    if game.cam.scale > 0.5 then
        game.cam.scale = game.cam.scale - zoomScale
    end
end


function game.setup()
    wf = require("libraries.windfield")
    world = wf.newWorld(0, 10000, true)

    anim8 = require("libraries.anim8")
    love.graphics.setDefaultFilter("nearest", "nearest")

    camera = require('libraries.camera')
    game.cam = camera()

    ui = require("src.ui")
    map = require('src.map')
    player = require('src.player')

    game.camera = {}

    game.window.x, game.window.y = love.window.getDesktopDimensions()

    game.zoomIn(3)
    
    game.fs(true)
    game.sound('bgmusic.mp3', true)

    map.colliders()
end

return game
