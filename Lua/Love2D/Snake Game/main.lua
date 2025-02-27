-- snake game --

-- game constants
local SETTINGS = {
    TICK_RATE = 5,
    SCREEN_SIZE = 700,
    GRID_SIZE = 15,
}

local COLORS = {
    BACKGROUND = { 0.1, 0.1, 0.1, 1 },
    GRID = { 0.8, 0.8, 0.8, 0.8 },
    FOOD = { 1, 0, 0, 1 },

    SNAKE = {
        BODY = { 0.8, 0.8, 0.8, 1 },
        HEAD = { 1, 1, 1, 1 },
    },
}

local CONTROLS = {
    GAME = {
        QUIT = "q",
        RESTART = "r",
    },

    SNAKE = {
        UP = "up",
        DOWN = "down",
        LEFT = "left",
        RIGHT = "right",
    },
}

local BLOCK_SIZE = SETTINGS.SCREEN_SIZE / SETTINGS.GRID_SIZE

-- game variables
local snake = {
    segments = {
        {
            math.ceil(SETTINGS.GRID_SIZE / 2),
            math.ceil(SETTINGS.GRID_SIZE / 2),
        },
    },
    direction = { x = 0, y = 0 },
}

local food = {
    x = 0,
    y = 0,
}

local tickRate = SETTINGS.TICK_RATE
local isGameOver = false
local elapsedTime = 0

-- game functions
local function restartGame()
    snake.segments = {
        {
            math.ceil(SETTINGS.GRID_SIZE / 2),
            math.ceil(SETTINGS.GRID_SIZE / 2),
        },
    }

    snake.direction = { x = 1, y = 0 }
end

-- update functions
local function checkSelfCollision(head)
    for i = 2, #snake.segments do
        if head == snake.segments[i] then
            return true
        end
    end

    return false
end

local function updateGame()
    -- move snake
    local head = snake.segments[1]

    local newHead = {
        (head[1] + snake.direction.x) % SETTINGS.GRID_SIZE,
        (head[2] + snake.direction.y) % SETTINGS.GRID_SIZE,
    }

    table.insert(snake.segments, 1, newHead)

    -- collisions
    if checkSelfCollision(newHead) then
        restartGame()
    elseif not (newHead[1] == food.x and newHead[2] == food.y) then
        table.remove(snake.segments, #snake.segments)
    else
        food = {
            x = math.random(SETTINGS.GRID_SIZE),
            y = math.random(SETTINGS.GRID_SIZE),
        }
    end
end

-- draw functions
local function drawGrid()
    love.graphics.setColor(COLORS.GRID)

    for x = 0, SETTINGS.GRID_SIZE do
        for y = 0, SETTINGS.GRID_SIZE do
            love.graphics.rectangle(
                "line",
                x * BLOCK_SIZE,
                y * BLOCK_SIZE,
                BLOCK_SIZE,
                BLOCK_SIZE
            )
        end
    end

    love.graphics.setColor({ 1, 1, 1, 1 })
end

local function drawSnake()
    for index, segment in ipairs(snake.segments) do
        local x, y = segment[1] - 1, segment[2] - 1

        love.graphics.setColor(
            index == 1 and COLORS.SNAKE.HEAD or COLORS.SNAKE.BODY
        )

        love.graphics.rectangle(
            "fill",
            x * BLOCK_SIZE,
            y * BLOCK_SIZE,
            BLOCK_SIZE,
            BLOCK_SIZE
        )
    end

    love.graphics.setColor({ 1, 1, 1, 1 })
end

local function drawFood()
    love.graphics.setColor(COLORS.FOOD)

    love.graphics.rectangle(
        "fill",
        food.x * BLOCK_SIZE,
        food.y * BLOCK_SIZE,
        BLOCK_SIZE,
        BLOCK_SIZE
    )

    love.graphics.setColor({ 1, 1, 1, 1 })
end

-- input functions
local function handleDirectionInputs(key)
    local inputMap = {
        [CONTROLS.SNAKE.UP] = { x = 0, y = -1 },
        [CONTROLS.SNAKE.DOWN] = { x = 0, y = 1 },
        [CONTROLS.SNAKE.LEFT] = { x = -1, y = 0 },
        [CONTROLS.SNAKE.RIGHT] = { x = 1, y = 0 },
    }

    if inputMap[key] then
        snake.direction = inputMap[key]
    end
end

-- love functions
function love.load()
    love.window.setMode(SETTINGS.SCREEN_SIZE, SETTINGS.SCREEN_SIZE)
    love.graphics.setBackgroundColor(COLORS.BACKGROUND)
end

function love.update(dt)
    elapsedTime = elapsedTime + dt

    while elapsedTime >= 1 / tickRate do
        if not isGameOver then
            updateGame()
        end
        elapsedTime = elapsedTime - (1 / tickRate)
    end
end

function love.draw()
    drawGrid()
    drawFood()
    drawSnake()
end

function love.keypressed(key)
    if key == CONTROLS.GAME.QUIT then
        love.event.quit()
    elseif key == CONTROLS.GAME.RESTART then
        restartGame()
    else
        handleDirectionInputs(key)
    end
end
