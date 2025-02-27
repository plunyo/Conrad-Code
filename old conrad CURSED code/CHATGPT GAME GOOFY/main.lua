-- Game state
local player1 = {x = 50, y = 250, width = 10, height = 50, speed = 300, score = 0}
local player2 = {x = 740, y = 250, width = 10, height = 50, speed = 300, score = 0}
local ball = {x = 400, y = 300, size = 10, speedX = 200, speedY = 200}
local maxScore = 5
local gameState = "menu"

-- Load assets
function love.load()
    love.window.setTitle("Pong Game")
    love.window.setMode(800, 600)
    player1.image = love.graphics.newImage("player1.png")
    player2.image = love.graphics.newImage("player2.png")
    ball.image = love.graphics.newImage("ball.png")
    bounceSound = love.audio.newSource("bounce.wav", "static")
    scoreSound = love.audio.newSource("score.wav", "static")
end

-- Update game state
function love.update(dt)
    if gameState == "play" then
        -- Player movement
        if love.keyboard.isDown('w') and player1.y > 0 then
            player1.y = player1.y - player1.speed * dt
        end
        if love.keyboard.isDown('s') and player1.y < 600 - player1.height then
            player1.y = player1.y + player1.speed * dt
        end
        if love.keyboard.isDown('up') and player2.y > 0 then
            player2.y = player2.y - player2.speed * dt
        end
        if love.keyboard.isDown('down') and player2.y < 600 - player2.height then
            player2.y = player2.y + player2.speed * dt
        end

        -- Ball movement
        ball.x = ball.x + ball.speedX * dt
        ball.y = ball.y + ball.speedY * dt

        -- Ball collision with walls
        if ball.y < 0 or ball.y > 600 - ball.size then
            ball.speedY = -ball.speedY
            love.audio.play(bounceSound)
        end

        -- Ball collision with players
        if ball.x < player1.x + player1.width and
           ball.x + ball.size > player1.x and
           ball.y < player1.y + player1.height and
           ball.y + ball.size > player1.y then
            ball.speedX = -ball.speedX
            love.audio.play(bounceSound)
        end
        if ball.x < player2.x + player2.width and
           ball.x + ball.size > player2.x and
           ball.y < player2.y + player2.height and
           ball.y + ball.size > player2.y then
            ball.speedX = -ball.speedX
            love.audio.play(bounceSound)
        end

        -- Score
        if ball.x < 0 then
            player2.score = player2.score + 1
            love.audio.play(scoreSound)
            resetBall()
        end
        if ball.x > 800 then
            player1.score = player1.score + 1
            love.audio.play(scoreSound)
            resetBall()
        end

        -- Check for game over
        if player1.score >= maxScore or player2.score >= maxScore then
            gameState = "gameover"
        end
    end
end

-- Reset ball position
function resetBall()
    ball.x = 400
    ball.y = 300
    ball.speedX = math.random(100, 300) * (math.random(0, 1) == 0 and -1 or 1)
    ball.speedY = math.random(100, 300) * (math.random(0, 1) == 0 and -1 or 1)
end

-- Draw game elements
function love.draw()
    -- Draw background
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)

    if gameState == "menu" then
        -- Draw menu
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Press Enter to Start", 0, 250, 800, "center")
    elseif gameState == "play" then
        -- Draw players
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(player1.image, player1.x, player1.y)
        love.graphics.draw(player2.image, player2.x, player2.y)

        -- Draw ball
        love.graphics.draw(ball.image, ball.x, ball.y)

        -- Draw score
        love.graphics.printf(player1.score, 0, 20, 400, "center")
        love.graphics.printf(player2.score, 400, 20, 400, "center")
    elseif gameState == "gameover" then
        -- Draw game over screen
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Game Over", 0, 250, 800, "center")
        love.graphics.printf("Press Enter to Restart", 0, 300, 800, "center")
        love.graphics.printf("Player " .. (player1.score >= maxScore and "1" or "2") .. " Wins!", 0, 350, 800, "center")
    end
end

-- Handle key presses
function love.keypressed(key)
    if key == "return" then
        if gameState == "menu" or gameState == "gameover" then
            -- Start or restart the game
            gameState = "play"
            player1.score = 0
            player2.score = 0
            resetBall()
        end
    end
end
