local TextureRect = require("src.classes.ui.TextureRect")
local Outline = require("src.classes.ui.Outline")
local Vector2 = require("src.classes.Vector2")
local Button = require("src.classes.ui.Button")
local Label = require("src.classes.ui.Label")
local utils = require("src.utils")

local mainMenu = {}

-- Background setup
local background = TextureRect:new(
    Vector2:new(utils.sw, utils.sh),
    Vector2:new(),
    love.graphics.newImage("assets/images/menuBackground.png")
)

-- Title setup
local gameTitle = Label:new(
    Vector2:new(utils.sw / 2, utils.sh * 0.25),
    "UI Test",
    { 0.8, 0.9, 1, 1 }, -- Glowing bluish-white
    love.graphics.newFont("assets/fonts/testFont.ttf", 100)
)

-- Button config
local buttonWidth, buttonHeight = utils.sw * 0.2, utils.sh * 0.1
local buttonSpacing = utils.sh * 0.05
local buttonOutline = Outline:new({ 0.2, 0.6, 1, 1 }, 2) -- Neon blue outline

local font = love.graphics.newFont(
    "assets/fonts/testFont.ttf",
    math.floor(utils.sh * 0.04)
)

-- Start button
local startButton = Button:new(
    Vector2:new(buttonWidth, buttonHeight),
    Vector2:new(utils.sw / 2, utils.sh * 0.6),
    "Start",
    { 0.7, 0.8, 1, 1 },
    buttonOutline
)
startButton.label.font = font
startButton.onClicked:connect(function()
    SceneManager.changeSceneTo("game")
end)

-- Quit button
local quitButton = Button:new(
    Vector2:new(buttonWidth, buttonHeight),
    Vector2:new(utils.sw / 2, utils.sh * 0.6 + buttonHeight + buttonSpacing),
    "Quit",
    { 0.7, 0.8, 1, 1 },
    buttonOutline
)
quitButton.label.font = font
quitButton.onClicked:connect(function()
    love.event.quit()
end)

-- Scene functions
function mainMenu.update()
    startButton:update()
    quitButton:update()
end

function mainMenu.draw()
    background:draw()
    gameTitle:draw()

    for _, button in ipairs({ startButton, quitButton }) do
        button:draw()
        button.outline:draw(button.position, button.size)
    end
end

return mainMenu
