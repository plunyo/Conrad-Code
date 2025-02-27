local TextureRect = require("src.classes.ui.TextureRect")
local Outline = require("src.classes.ui.Outline")
local Vector2 = require("src.classes.Vector2")
local Button = require("src.classes.ui.Button")
local Label = require("src.classes.ui.Label")

local utils = require("src.utils")

local mainMenu = {}

local background = TextureRect:new(
    Vector2:new(
        utils.sw,
        utils.sh
    ),

    Vector2:new(),

    love.graphics.newImage("assets/images/menuBackground.png")
)

local gameTitle = Label:new(
    Vector2:new(
        utils.sw / 2,
        utils.sh * 0.25
    ),

    "UI Test",

    {0.8, 0.9, 1, 1}, -- Glowing white with a bluish tint

    love.graphics.newFont("assets/fonts/testFont.ttf", 100)
)

local buttonWidth = utils.sw * 0.2 -- 20% of screen width
local buttonHeight = utils.sh * 0.1 -- 10% of screen height
local buttonSpacing = utils.sh * 0.05 -- 5% of screen height for spacing
local buttonOutline = Outline:new({0.2, 0.6, 1, 1}, 2) -- Neon blue outline

local fontSize = math.floor(utils.sh * 0.04)
local font = love.graphics.newFont("assets/fonts/testFont.ttf", fontSize)

local startButton = Button:new(
    Vector2:new(buttonWidth, buttonHeight),

    Vector2:new(
        utils.sw / 2,
        utils.sh * 0.6 -- Position a bit higher than center
    ),

    "Start",

    {0.7, 0.8, 1, 1}, -- Light blue text color

    buttonOutline
)

startButton.label.font = font

startButton.onClicked:connect(function()
    SceneManager.changeSceneTo("game")
end)

local quitButton = Button:new(
    Vector2:new(buttonWidth, buttonHeight),

    Vector2:new(
        utils.sw / 2,
        utils.sh * 0.6 + buttonHeight + buttonSpacing -- Below Start button
    ),

    "Quit",

    {0.7, 0.8, 1, 1}, -- Light blue text color

    buttonOutline
)

quitButton.label.font = font

quitButton.onClicked:connect(function()
    love.event.quit()
end)

function mainMenu.load()

end

function mainMenu.exit()

end

function mainMenu.update()
    startButton:update()
    quitButton:update()
end

function mainMenu.draw()
    background:draw()

    gameTitle:draw()

    startButton:draw()

    startButton.outline:draw(
        startButton.position,
        startButton.size
    )

    quitButton:draw()

    quitButton.outline:draw(
        quitButton.position,
        quitButton.size
    )
end

return mainMenu
