function love.load()
    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 4
    player.movement = true
    player.sprite = ("sprites/playersprite.png")
end

function love.update(dt)
    if player.movement then
        if love.keyboard.isDown("w") then
            player.y = player.y - player.speed
        end

        if love.keyboard.isDown("a") then
            player.x = player.x - player.speed
        end

        if love.keyboard.isDown("s") then
            player.y = player.y + player.speed
        end

        if love.keyboard.isDown("d") then
            player.x = player.x + player.speed
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 0, 1)
    love.graphics.draw(player.sprite, player.x player.y)
end
