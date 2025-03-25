-- refactored pushy game code
local wf = require("libraries.windfield")
local world
local players = {}  -- table for dynamic player objects
local ground
local gameState = "menu"

local gameConfig = {
  winWidth = 800,
  winHeight = 600,
  winner = ""
}

local playerConfig = {
  speed = 500,
  sizeFactor = 10, -- player size is window dimension divided by this
  controls = {
    [1] = { jump = "w", left = "a", right = "d" },
    [2] = { jump = "up", left = "left", right = "right" },
    [3] = { jump = "i", left = "j", right = "l" }
  }
}

local function setFullscreen(width, height, fullscreen)
  love.window.setMode(width, height, {fullscreen = fullscreen})
end

local function createButton(label, x, y, width, height, outline, targetState, buttonColor, outlineColor)
  local font = love.graphics.getFont()
  local textWidth = font:getWidth(label)
  local textHeight = font:getHeight()
  local labelX = x + (width - textWidth) / 2
  local labelY = y + (height - textHeight) / 2

  love.graphics.setColor(buttonColor)
  love.graphics.rectangle("fill", x, y, width, height)
  if outline then
    love.graphics.setColor(outlineColor)
    love.graphics.rectangle("line", x, y, width, height)
  end
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(label, labelX, labelY)

  local mx, my = love.mouse.getPosition()
  if mx >= x and mx <= x + width and my >= y and my <= y + height then
    if love.mouse.isDown(1) then
      gameState = targetState
    end
  end
end

local function createPlayers(numPlayers)
  -- remove any existing players
  for i, player in ipairs(players) do
    if player.collider then
      player.collider:destroy()
    end
  end
  players = {}

  -- determine player size based on window dimensions
  local sizeW = gameConfig.winWidth / playerConfig.sizeFactor
  local sizeH = gameConfig.winHeight / playerConfig.sizeFactor

  -- vertical spacing for players (centered vertically)
  local ySpacing = gameConfig.winHeight / (numPlayers + 1)

  for i = 1, numPlayers do
    local xPos, yPos
    -- assign x positions: for 1 or 2 players, use 1/3 and 2/3; for 3, use 1/3, 2/3, and 1/2 in the middle of y
    if numPlayers == 1 then
      xPos = gameConfig.winWidth / 2 - sizeW / 2
    elseif numPlayers == 2 then
      xPos = i == 1 and gameConfig.winWidth / 3 - sizeW / 2 or 2 * gameConfig.winWidth / 3 - sizeW / 2
    elseif numPlayers == 3 then
      if i == 1 then
        xPos = gameConfig.winWidth / 3 - sizeW / 2
      elseif i == 2 then
        xPos = 2 * gameConfig.winWidth / 3 - sizeW / 2
      else
        xPos = gameConfig.winWidth / 2 - sizeW / 2
      end
    end

    yPos = ySpacing * i - sizeH / 2

    local collider = world:newRectangleCollider(xPos, yPos, sizeW, sizeH)
    collider:setType('dynamic')

    players[i] = {
      collider = collider,
      alive = true,
      canJump = true,
      controls = playerConfig.controls[i]
    }
  end
end

function love.load()
  world = wf.newWorld(0, 1000, true)
  love.window.setTitle("goomba")

  -- get desktop dimensions for game config, if needed
  gameConfig.winWidth, gameConfig.winHeight = love.window.getDesktopDimensions()

  -- set ground (70% of window width)
  local groundWidth = gameConfig.winWidth * 0.7
  local groundX = (gameConfig.winWidth - groundWidth) / 2
  ground = world:newRectangleCollider(groundX, gameConfig.winHeight - 300, groundWidth, 5)
  ground:setType('static')

  setFullscreen(800, 600, false)  -- start windowed mode

  -- default to one player game
  createPlayers(1)
  gameState = "1player"
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    love.load()
  end

  -- change player count based on key
  if key == "1" then
    createPlayers(1)
    gameState = "1player"
  elseif key == "2" then
    createPlayers(2)
    gameState = "2player"
  elseif key == "3" then
    createPlayers(3)
    gameState = "3player"
  end

  -- handle jumps for players
  for i, player in ipairs(players) do
    if player.alive and key == player.controls.jump and player.canJump then
      player.collider:applyLinearImpulse(0, - (gameConfig.winHeight / playerConfig.sizeFactor) ^ 2 / 2)
    end
  end
end

function love.update(dt)
  world:update(dt)

  -- movement for each player
  for _, player in ipairs(players) do
    if player.alive then
      local impulse = 0
      if love.keyboard.isDown(player.controls.left) then
        impulse = -playerConfig.speed
      elseif love.keyboard.isDown(player.controls.right) then
        impulse = playerConfig.speed
      end
      if impulse ~= 0 then
        player.collider:applyLinearImpulse(impulse, 0)
      end

      -- check boundaries, mark as dead if outside window bounds
      local x, y = player.collider:getPosition()
      local size = gameConfig.winWidth / playerConfig.sizeFactor
      if x < 0 or x + size > gameConfig.winWidth or y < 0 or y + size > gameConfig.winHeight then
        player.alive = false
        player.collider:setType("static")
      end
    end
  end

  -- determine winner based on alive states
