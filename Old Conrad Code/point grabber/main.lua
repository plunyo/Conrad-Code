
function love.load()
    guy = {}
    guy.x = love.graphics.getWidth() / 2
    guy.y = love.graphics.getHeight() / 2
    target = {}
    target.x = love.graphics.getWidth() / 2
    target.y = love.graphics.getHeight() / 2
    target.radius = 50
    score = 0
    guyspeed = 4
    range4click = 50
    gameFont = love.graphics.newFont('fonts/bubble.TTF', 80)
    love.mouse.setVisible(false)
    guy.looks = love.graphics.newImage('sprites/guy.png')
    background = love.graphics.newImage('sprites/background.png')
    sounds ={}
    sounds.gamemusic = love.audio.newSource('sounds/gamemusic.mp3', 'stream')
    sounds.coincollect = love.audio.newSource('sounds/coincollect.mp3', 'static')
    sounds.gamemusic:setLooping(true)
    sounds.gamemusic:play()
    rot = {}
end

function love.update(dt)
    if love.keyboard.isDown("w") then
        guy.y = guy.y - guyspeed
    end
    if love.keyboard.isDown("a") then
        guy.x = guy.x - guyspeed
    end
    if love.keyboard.isDown("s") then
        guy.y = guy.y + guyspeed
    end
    if love.keyboard.isDown("d") then
        guy.x = guy.x + guyspeed
    end

    local guyToTarget = distanceBet(guy.x, guy.y, target.x, target.y)
    if guyToTarget <= target.radius + range4click and love.mouse.isDown(1) then
        score = score + 1
        target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
        target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        sounds.coincollect:play()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle('fill', target.x, target.y, target.radius)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('line', target.x, target.y, target.radius)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print(score, 10, 10)
end


function distanceBet(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
