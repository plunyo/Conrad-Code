-- main.lua
-- Insane Triple-A Game Blueprint in LÖVE (Now with REAL features!)

-- GLOBAL VARIABLES
local gameState = nil
local uiButtons = {} -- for our basic UI

-- Create a 1x1 white pixel image for our particle system
local function createPixelImage()
    local id = love.image.newImageData(1, 1)
    id:setPixel(0, 0, 1, 1, 1, 1)
    return love.graphics.newImage(id)
end

local pixelImage = createPixelImage()

-- CUSTOM SHADER: a crazy color-shift shader effect
local shaderCode = [[
    extern number time;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texcolor = Texel(texture, texture_coords);
        // Simple hue shift using sine waves
        texcolor.r = texcolor.r * abs(sin(time));
        texcolor.g = texcolor.g * abs(sin(time + 2.0));
        texcolor.b = texcolor.b * abs(sin(time + 4.0));
        return texcolor * color;
    }
]]
local customShader = love.graphics.newShader(shaderCode)
local shaderTime = 0

-- STATE MACHINE IMPLEMENTATION
local StateMachine = {}

function StateMachine:new(states, initial)
    local o = { states = states, current = nil }
    setmetatable(o, self)
    self.__index = self
    o:change(initial)
    return o
end

function StateMachine:change(stateName, params)
    if self.current and self.current.exit then
        self.current:exit()
    end
    self.current = self.states[stateName]()
    if self.current.enter then
        self.current:enter(params)
    end
end

function StateMachine:update(dt)
    if self.current and self.current.update then
        self.current:update(dt)
    end
end

function StateMachine:draw()
    if self.current and self.current.draw then
        self.current:draw()
    end
end

-- MENU STATE
local MenuState = {}
function MenuState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function MenuState:enter()
    self.title = "INSANE AAA GAME in LÖVE"
end
function MenuState:update(dt)
    if love.keyboard.isDown("return") then
        gameState:change("play")
    end
end
function MenuState:draw()
    love.graphics.printf(
        self.title,
        0,
        love.graphics.getHeight() / 2 - 20,
        love.graphics.getWidth(),
        "center"
    )
    love.graphics.printf(
        "Press Enter to Start",
        0,
        love.graphics.getHeight() / 2 + 20,
        love.graphics.getWidth(),
        "center"
    )
end
function MenuState:exit() end

-- PLAY STATE (with physics, particles, shader, and UI)
local PlayState = {}
function PlayState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function PlayState:enter()
    -- Create physics world (with gravity downwards)
    self.world = love.physics.newWorld(0, 500, true)
    self.world:setCallbacks(function(a, b, coll)
        self:beginContact(a, b, coll)
    end)

    -- Create player as a dynamic body
    self.player = {}
    self.player.body = love.physics.newBody(self.world, 400, 300, "dynamic")
    self.player.shape = love.physics.newRectangleShape(30, 30)
    self.player.fixture =
        love.physics.newFixture(self.player.body, self.player.shape, 1)
    self.player.fixture:setUserData("player")

    self.enemies = {}
    self.spawnTimer = 0
    self.score = 0

    -- Particle system for explosions / effects
    self.particleSystem = love.graphics.newParticleSystem(pixelImage, 100)
    self.particleSystem:setParticleLifetime(0.5, 1) -- particles live 0.5-1 seconds
    self.particleSystem:setEmissionRate(100)
    self.particleSystem:setSizes(1, 0)
    self.particleSystem:setSpeed(50, 100)
    self.particleSystem:setColors(1, 1, 0, 1, 1, 0, 0, 0)
    self.particleSystem:stop() -- start stopped, trigger on events

    -- UI: create a Pause/Resume button
    self.paused = false
    uiButtons = {}
    table.insert(uiButtons, {
        text = "Pause",
        x = 10,
        y = 50,
        w = 100,
        h = 30,
        onClick = function(btn)
            self.paused = not self.paused
            btn.text = self.paused and "Resume" or "Pause"
        end,
    })
end

function PlayState:beginContact(a, b, coll)
    local ua = a:getUserData()
    local ub = b:getUserData()
    if
        (ua == "player" and ub == "enemy") or (ua == "enemy" and ub == "player")
    then
        -- Trigger particle effect at collision point
        local x, y = coll:getNormal() -- not ideal but for demo purposes
        self.particleSystem:setPosition(
            self.player.body:getX(),
            self.player.body:getY()
        )
        self.particleSystem:emit(50)
        gameState:change("gameover", { score = self.score })
    end
end

function PlayState:update(dt)
    if not self.paused then
        self.world:update(dt)

        -- Keyboard input for player movement
        local vx, vy = 0, 0
        if love.keyboard.isDown("w") then
            vy = vy - 200
        end
        if love.keyboard.isDown("s") then
            vy = vy + 200
        end
        if love.keyboard.isDown("a") then
            vx = vx - 200
        end
        if love.keyboard.isDown("d") then
            vx = vx + 200
        end
        self.player.body:setLinearVelocity(vx, vy)

        -- Spawn enemy every 2 seconds
        self.spawnTimer = self.spawnTimer + dt
        if self.spawnTimer > 2 then
            self.spawnTimer = 0
            local enemy = {}
            enemy.body = love.physics.newBody(
                self.world,
                math.random(50, love.graphics.getWidth() - 50),
                -50,
                "dynamic"
            )
            enemy.shape = love.physics.newRectangleShape(20, 20)
            enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 1)
            enemy.fixture:setUserData("enemy")
            enemy.body:setLinearVelocity(0, math.random(100, 200))
            table.insert(self.enemies, enemy)
        end

        -- Remove enemies that fall off screen
        for i = #self.enemies, 1, -1 do
            local enemy = self.enemies[i]
            if enemy.body:getY() > love.graphics.getHeight() + 50 then
                enemy.body:destroy()
                table.remove(self.enemies, i)
                self.score = self.score + 1
            end
        end

        self.particleSystem:update(dt)
    end
    -- Update UI shader time
    shaderTime = shaderTime + dt
    customShader:send("time", shaderTime)
end

function PlayState:draw()
    -- Use custom shader for a crazy visual effect
    love.graphics.setShader(customShader)

    -- Draw physics world objects
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle(
        "fill",
        0,
        0,
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )

    -- Draw player as a green rectangle
    love.graphics.setColor(0, 1, 0)
    local px, py = self.player.body:getX(), self.player.body:getY()
    local pw, ph = 30, 30
    love.graphics.rectangle("fill", px - pw / 2, py - ph / 2, pw, ph)

    -- Draw enemies as red rectangles
    love.graphics.setColor(1, 0, 0)
    for _, enemy in ipairs(self.enemies) do
        local ex, ey = enemy.body:getX(), enemy.body:getY()
        love.graphics.rectangle("fill", ex - 10, ey - 10, 20, 20)
    end

    -- Draw particle effects
    love.graphics.draw(self.particleSystem, 0, 0)

    love.graphics.setShader() -- reset shader

    -- Draw UI overlay (Pause button, Score, etc.)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. self.score, 10, 10)
    for _, btn in ipairs(uiButtons) do
        love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h)
        love.graphics.printf(btn.text, btn.x, btn.y + 8, btn.w, "center")
    end
    love.graphics.printf(
        "Amazing AAA Madness!",
        0,
        40,
        love.graphics.getWidth(),
        "center"
    )
end
function PlayState:exit()
    -- Destroy physics bodies to avoid memory leaks
    self.player.body:destroy()
    for _, enemy in ipairs(self.enemies) do
        enemy.body:destroy()
    end
end

-- GAME OVER STATE
local GameOverState = {}
function GameOverState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function GameOverState:enter(params)
    self.finalScore = params and params.score or 0
end
function GameOverState:update(dt)
    if love.keyboard.isDown("return") then
        gameState:change("menu")
    end
end
function GameOverState:draw()
    love.graphics.printf(
        "GAME OVER",
        0,
        love.graphics.getHeight() / 2 - 40,
        love.graphics.getWidth(),
        "center"
    )
    love.graphics.printf(
        "Final Score: " .. self.finalScore,
        0,
        love.graphics.getHeight() / 2,
        love.graphics.getWidth(),
        "center"
    )
    love.graphics.printf(
        "Press Enter to return to Menu",
        0,
        love.graphics.getHeight() / 2 + 40,
        love.graphics.getWidth(),
        "center"
    )
end
function GameOverState:exit() end

-- GLOBAL STATE MACHINE INITIALIZATION
function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Insane AAA Game in LÖVE")
    local states = {
        menu = function()
            return MenuState:new()
        end,
        play = function()
            return PlayState:new()
        end,
        gameover = function()
            return GameOverState:new()
        end,
    }
    gameState = StateMachine:new(states, "menu")
end

function love.update(dt)
    gameState:update(dt)
end

function love.draw()
    gameState:draw()
end

-- UI Mouse Handling
function love.mousepressed(x, y, button)
    if button == 1 then
        for _, btn in ipairs(uiButtons) do
            if
                x >= btn.x
                and x <= btn.x + btn.w
                and y >= btn.y
                and y <= btn.y + btn.h
            then
                btn.onClick(btn)
            end
        end
    end
end
