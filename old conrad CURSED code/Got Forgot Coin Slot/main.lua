
function love.load()
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0, true)

    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/map.lua')

    fullscreen = true

    love.window.setMode(0, 0, {fullscreen = true})

    camera = {}


    guy = {}
    guy.collider = world:newBSGRectangleCollider(400, 250, 50, 100, 10)
    guy.collider:setFixedRotation(true)
    guy.x = love.graphics.getWidth() / 2
    guy.y = love.graphics.getHeight() / 2
    guy.speed = 300
    guy.looks = love.graphics.newImage('sprites/player-sheet.png')
    guy.grid = anim8.newGrid( 12, 18, guy.looks:getWidth(), guy.looks:getHeight() )
    guy.health = 100
    guy.levitate = 500

    guy.animations = {}
    guy.animations.down = anim8.newAnimation( guy.grid('1-4', 1), 0.2 )
    guy.animations.left = anim8.newAnimation( guy.grid('1-4', 2), 0.2 )
    guy.animations.right = anim8.newAnimation( guy.grid('1-4', 3), 0.2 )
    guy.animations.up = anim8.newAnimation( guy.grid('1-4', 4), 0.2 )
    guy.animations.levitate = anim8.newAnimation( guy.grid(3, 1), 0.2 )

    guy.anim = guy.animations.down
end

function love.update(dt)
    local isMoving = false

    local vx = 0
    local vy = 0
    
    if love.keyboard.isDown("w", "up") then
        vy = guy.speed * -1
        guy.anim = guy.animations.up
        isMoving = true
    end
    if love.keyboard.isDown("a", "left") then
        vx = guy.speed * -1
        guy.anim = guy.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("s", "down") then
        vy = guy.speed * 1
        guy.anim = guy.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("d", "right") then
        vx = guy.speed * 1
        guy.anim = guy.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("lshift") then
        guy.speed = guy.levitate
    else
        guy.speed = 300
    end
    guy.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        guy.anim:gotoFrame(2)
    end

    world:update(dt)
    guy.x = guy.collider:getX()
    guy.y = guy.collider:getY()

    guy.anim:update(dt)

    cam:lookAt(guy.x, guy.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight(0)

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x < w/2 then
        cam.x = w/2
    elseif cam.x > mapW - w/2 then
        cam.x = mapW - w/2
    end
    
    if cam.y < h/2 then
        cam.y = h/2
    elseif cam.y > mapH - h/2 then
        cam.y = mapH - h/2
    end
end


function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Trees"])
        guy.anim:draw(guy.looks, guy.x, guy.y, nil, 6, nil, 6, 9)
        world:draw()
    cam:detach()
end