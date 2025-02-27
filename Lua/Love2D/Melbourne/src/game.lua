local ui = require('src.ui')
local saves = require('src.saves')

local game = {
    window = {},
    file = {},
    state = nil,
    fullscreen = true,
    save = nil
}

game.window.w, game.window.h = love.window.getDesktopDimensions()

game.menuBackground = love.graphics.newImage('assets/backgroundMenus/menu_background.png')

function game.fs(w, h, fullscreen)
    love.window.setMode(w, h, {fullscreen = fullscreen})
    game.window.w, game.window.h = love.graphics.getDimensions() -- Update window dimensions
end

function game.toggleFullscreen()
    game.fullscreen = not game.fullscreen
    love.window.setMode(1024, 768, {fullscreen = game.fullscreen})
    game.window.w, game.window.h = love.graphics.getDimensions() -- Update window dimensions
end

function game.menu()
    -- Menu Background
    love.graphics.draw(game.menuBackground, 0, 0, 0, love.graphics.getWidth() / game.menuBackground:getWidth(), love.graphics.getHeight() / game.menuBackground:getHeight())

    -- Game Title --
    local text = "Melbourne"
    local fontSize = 200
    local font = love.graphics.newFont("assets/fonts/fontyfont.ttf", fontSize)
    love.graphics.setFont(font)
    local textWidth = font:getWidth(text)
    local textX = (game.window.w - textWidth) / 2
    love.graphics.print(text, textX, game.window.h / 3)
    -- Buttons
    local buttonWidth = game.window.w * 0.2 -- 20% of the window width
    local buttonHeight = game.window.h * 0.1 -- 10% of the window height
    local buttonSpacing = game.window.w * 0.05 -- 5% of the window width
    local totalWidth = 3 * buttonWidth + 2 * buttonSpacing

    local leftButtonX = (game.window.w - totalWidth) / 2
    local middleButtonX = leftButtonX + buttonWidth + buttonSpacing
    local rightButtonX = middleButtonX + buttonWidth + buttonSpacing
    local buttonY = game.window.h / 2
end

function game.saveMenu()
    -- Buttons
    local buttonWidth = game.window.w * 0.2 -- 20% of the window width
    local buttonHeight = game.window.h * 0.1 -- 10% of the window height
    local buttonSpacing = game.window.w * 0.05 -- 5% of the window width
    local totalWidth = 3 * buttonWidth + 2 * buttonSpacing

    local leftButtonX = (game.window.w - totalWidth) / 2
    local middleButtonX = leftButtonX + buttonWidth + buttonSpacing
    local rightButtonX = middleButtonX + buttonWidth + buttonSpacing
    local buttonY = game.window.h / 2

    ui.newButton("Save 1", 24, {0, 0, 0}, leftButtonX, buttonY, buttonWidth, buttonHeight, {0.7, 0.7, 0.7}, {0.5, 0.5, 0.5}, saves.create, 'savefile1')
    ui.newButton("Save 2", 24, {0, 0, 0}, middleButtonX, buttonY, buttonWidth, buttonHeight, {0.7, 0.7, 0.7}, {0.5, 0.5, 0.5}, saves.create, 'savefile2' )
    ui.newButton("Save 3", 24, {0, 0, 0}, rightButtonX, buttonY, buttonWidth, buttonHeight, {0.7, 0.7, 0.7}, {0.5, 0.5, 0.5}, saves.create, 'savefile3' )
end


return game
