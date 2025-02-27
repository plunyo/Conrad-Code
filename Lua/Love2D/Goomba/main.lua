--[[

PUSHY GAME
CONRAD
NOAH IS SKIBIDI HELPER

https://love2d.org/wiki/love#Callbacks
^^^ CRAZY HELP FROM ^^^

]]--

local p1, p2, p3
local gameState = "menu"

gameConfig = {
    winX = 0,
    winY = 0,
    winner = ""
}

playerState = {
    p1 = 1,
    p2 = 1,
    p3 = 1,
    canJump1 = true,
    canJump2 = true,
    canJump3 = true
}

player = {
    speed = 500,
    sizeW = 0,
    sizeH = 0
}

function fs(x, y, work)
    love.window.setMode(x, y, {fullscreen = work})
end

function numPlayers(playerNum)
    -- Destroy colliders for players that are no longer active
    if playerNum < 3 and p3 then
        p3:destroy()
        p3 = nil
    end
    if playerNum < 2 and p2 then
            p2:destroy()
            p2 = nil
        end

        -- Set sizeW and sizeH based on winX and winY
        player.sizeW = gameConfig.winnerwinY / 10
        player.sizeH = gameConfig.winnerwinX / 10

        -- Calculate the y-coordinate for spawning vertically
        local ySpacing = gameConfig.winnerwinY / 4
        local yPosition = ySpacing * (playerNum - 1) + ySpacing / 2 - gameConfig.winnerwinY / 10

        -- Create new player colliders based on playerNum
        if playerNum >= 1 and not p1 then
        p1 = world:newRectangleCollider(gameConfig.winnerwinX / 3 - player.sizeW / 2, yPosition, player.sizeW, player.sizeH)
        p1:setType('dynamic')
    end
    if playerNum >= 2 and not p2 then
        p2 = world:newRectangleCollider(2 * gameConfig.winnerwinX / 3 - player.sizeW / 2, yPosition, player.sizeW, player.sizeH)
        p2:setType('dynamic')
    end
    if playerNum >= 3 and not p3 then
        p3 = world:newRectangleCollider(gameConfig.winnerwinX / 2 - player.sizeW / 2, yPosition, player.sizeW, player.sizeH)
        p3:setType('dynamic')
    end

    -- Change player colliders back to dynamic if going back to 3, 2, or 1 players
    if playerNum == 3 then
        if p1 then p1:setType('dynamic') end
        if p2 then p2:setType('dynamic') end
        if p3 then p3:setType('dynamic') end
    elseif playerNum == 2 then
        if p1 then p1:setType('dynamic') end
        if p2 then p2:setType('dynamic') end
    elseif playerNum == 1 then
        if p1 then p1:setType('dynamic') end
    end
end

function love.load()
    wf = require("libraries.windfield")
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 1000)

    gameConfig.winnerwinX, gameConfig.winnerwinY = love.window.getDesktopDimensions() -- Set winX and winY to desktop dimensions

    local groundWidth = gameConfig.winnerwinX * 0.5 -- Set ground width to 50% of window width
    local groundX = (gameConfig.winnerwinX - groundWidth) / 2 -- Calculate x position for centering

    ground = world:newRectangleCollider(groundX, gameConfig.winnerwinY - 300, groundWidth, 5)
    ground:setType('static')

    fs(gameConfig.winnerwinX, gameConfig.winnerwinY, true) -- Start in windowed mode

    numPlayers(1)  -- Initialize player 1

    -- Reset player states
    playerState.p1 = 1
    playerState.p2 = 1
    playerState.p3 = 1
    gameConfig.winner = ""

    -- Reset player colliders
    if p1 then
        p1:destroy()
        p1 = nil
    end
    if p2 then
        p2:destroy()
        p2 = nil
    end
    if p3 then
        p3:destroy()
        p3 = nil
    end
end

function love.keypressed(key)
    if key == "1" then
        numPlayers(1)
        gameState = "1player"
    elseif key == "2" then
        numPlayers(2)
        gameState = "2player"
    elseif key == "3" then
        numPlayers(3)
        gameState = "3player"
    elseif key == "w" and playerState.canJump1 then
        if p1 then
            p1:applyLinearImpulse(0, -player.sizeH ^ 2 / 2)
        end
    elseif key == "up" and playerState.canJump2 then
        if p2 then
            p2:applyLinearImpulse(0, -player.sizeH ^ 2 / 2)
        end
    elseif key == "i" and playerState.canJump3 then
        if p3 then
            p3:applyLinearImpulse(0, -player.sizeH ^ 2 / 2
        )
        end
    elseif key == "r" then
        if p1 then
            love.load()
        end
    end
end



function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    local activePlayers = 0

    -- Check if any player colliders touch the borders or ground/roof
    if p1 then
        local p1X, p1Y = p1:getPosition()
        if p1X < 0 or p1X + 50 > gameConfig.winnerwinX or p1Y < 0 or p1Y + 50 > gameConfig.winnerwinY then
            playerState.p1 = 2
        end
    end

    if p2 then
        local p2X, p2Y = p2:getPosition()
        if p2X < 0 or p2X + 50 > gameConfig.winnerwinX or p2Y < 0 or p2Y + 50 > gameConfig.winnerwinY then
            playerState.p2 = 2
        end
    end

    if p3 then
        local p3X, p3Y = p3:getPosition()
        if p3X < 0 or p3X + 50 > gameConfig.winnerwinX or p3Y < 0 or p3Y + 50 > gameConfig.winnerwinY then
            playerState.p3 = 2
        end
    end

    -- Set players to static if they are no longer active
    if p1 and playerState.p1 == 2 then
        p1:setType('static')
    end

    if p2 and playerState.p2 == 2 then
        p2:setType('static')
    end

    if p3 and playerState.p3 == 2 then
        p3:setType('static')
    end

    -- Apply movement impulses
    if p1 and playerState.p1 == 1 then
        if love.keyboard.isDown("a") then
            p1:applyLinearImpulse(-player.speed, 0)
        elseif love.keyboard.isDown("d") then
            p1:applyLinearImpulse(player.speed, 0)
        end
    end

    if p2 and playerState.p2 == 1 then
        if love.keyboard.isDown("left") then
            p2:applyLinearImpulse(-player.speed, 0)
        elseif love.keyboard.isDown("right") then
            p2:applyLinearImpulse(player.speed, 0)
        end
    end

    if p3 and playerState.p3 == 1 then
        if love.keyboard.isDown("j") then
            p3:applyLinearImpulse(-player.speed, 0)
        elseif love.keyboard.isDown("l") then
            p3:applyLinearImpulse(player.speed, 0)
        end
    end

    if gameState == "3player" then
        if playerState.p1 == 2 and playerState.p2 == 2 then
            gameConfig.winner = "Player 3"
        elseif playerState.p2 == 2 and playerState.p3 == 2 then
            gameConfig.winner = "Player 1"
        elseif playerState.p1 == 2 and playerState.p3 == 2 then
            gameConfig.winner = "Player 2"
        end
    elseif gameState == "2player" then
        if playerState.p1 == 2 then
            gameConfig.winner = "Player 2"
        elseif playerState.p2 == 2 then
            gameConfig.winner = "Player 1"
        end
    end

    if gameConfig.winner == "Player 1" or gameConfig.winner == "Player 2" or gameConfig.winner == "Player 3" then
        if gameState == "2player" then
            p1:setType("static")
            p2:setType("static")
        elseif gameState == "3player" then
            p1:setType("static")
            p2:setType("static")
            p3:setType("static")
        end
    end

    world:update(dt)
end



function love.draw()
    if gameState == "menu" then
        love.graphics.setColor(0, 0, 0) -- Set color to black
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()) -- Fill the entire screen with black
    else
        -- Draw the game elements here
        world:draw(dt)

        if gameConfig.winner == "Player 1" or gameConfig.winner == "Player 2" or gameConfig.winner == "Player 3" then
            local text = gameConfig.winner .. " HAS WON THE GAME, R to Rematch"
            local font = love.graphics.getFont()
            local textWidth = font:getWidth(text)
            local textHeight = font:getHeight()

            love.graphics.setFont(love.graphics.newFont(36))

            local x = (love.graphics.getWidth() - textWidth) / 2 - textWidth
            local y = (love.graphics.getHeight() - textHeight) / 3

            love.graphics.print(text, x, y)
        end

        love.graphics.setFont(love.graphics.newFont(12))

        love.graphics.print("Player States", 10, 10)

        love.graphics.print(tostring(playerState.p1), 10, 21)
        love.graphics.print(tostring(playerState.p2), 10, 32)
        love.graphics.print(tostring(playerState.p3), 10, 43)

        love.graphics.print("Can Jump", 10, 54)

        love.graphics.print(tostring(playerState.canJump1), 10, 65)
        love.graphics.print(tostring(playerState.canJump2), 10, 76)
        love.graphics.print(tostring(playerState.canJump3), 10, 87)

        love.graphics.print(gameState, 10, 98)
    end
end




