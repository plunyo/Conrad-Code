local anim8 = require('libraries.anim8')

local player = {
    x = 0,
    y = 0,
    speed = 600,
    sprintspeed = 0.01,
    sprite = love.graphics.newImage('assets/sprites/player-sheet.png'),
    collider = world:newBSGRectangleCollider(400, 250, 50, 100, 10),
}

player.grid = anim8.newGrid(12, 18, player.sprite:getWidth(), player.sprite:getHeight())

player.animations = {
    down = anim8.newAnimation(player.grid('1-4', 1), 0.2),
    left = anim8.newAnimation(player.grid('1-4', 2), 0.2),
    right = anim8.newAnimation(player.grid('1-4', 3), 0.2),
    up = anim8.newAnimation(player.grid('1-4', 4), 0.2)
}

player.anim = player.animations.down

function player.move(dt)
    local isMoving = false

    local vx, vy = 0, 0
    
    if love.keyboard.isDown("w", "up") then
        vy = -player.speed
        player.anim = player.animations.up
        isMoving = true
    end
    if love.keyboard.isDown("a", "left") then
        vx = -player.speed
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("s", "down") then
        vy = player.speed
        player.anim = player.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("d", "right") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("lshift") then
        player.speed = player.sprintspeed
    else
        player.speed = 300
    end

    player.x = player.x + vx * dt
    player.y = player.y + vy * dt

    player.collider:setLinearVelocity(vx, vy)

    player.x = player.collider:getX()
    player.y = player.collider:getY()

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)
end




return player
