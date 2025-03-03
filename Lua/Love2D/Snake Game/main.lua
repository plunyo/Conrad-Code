-- Snake Game --

-- Game Constants
local SETTINGS = {
    TICK_RATE = 5,
    SCREEN_SIZE = 700,
    GRID_SIZE = 15,
    TICK_RATE_INCREASE = 0.1,
}

local COLORS = {
    BACKGROUND = { 0.1, 0.1, 0.1, 1 },
    GRID = { 0.8, 0.8, 0.8, 0.8 },
    FOOD = { 1, 0, 0, 1 },
    SNAKE = {
        BODY = { 0, 0.8, 0, 1 },
        HEAD = { 0, 1, 0, 1 },
    },
    GAME_OVER = {
        BACKGROUND = { 0.2, 0.2, 0.2, 0.8 },
    },
}

local CONTROLS = {
    GAME = { QUIT = "q", RESTART = "r" },
    SNAKE = { UP = "up", DOWN = "down", LEFT = "left", RIGHT = "right" },
}

local BLOCK_SIZE = SETTINGS.SCREEN_SIZE / SETTINGS.GRID_SIZE

-- Game State Variables
local snake = {
    segments = {
        {
            math.ceil(SETTINGS.GRID_SIZE / 2),
            math.ceil(SETTINGS.GRID_SIZE / 2),
        },
    },
    direction = { x = 0, y = 0, canChange = true },
}

local food = { x = 0, y = 0 }
local tickRate = SETTINGS.TICK_RATE
local isGameOver = false
local elapsedTime = 0

-- Game Functions
local function restartGame()
    snake.segments = {
        {
            math.ceil(SETTINGS.GRID_SIZE / 2),
            math.ceil(SETTINGS.GRID_SIZE / 2),
        },
    }
    snake.direction = { x = 0, y = 0, canChange = true }
    food.x, food.y =
        math.random(1, SETTINGS.GRID_SIZE), math.random(1, SETTINGS.GRID_SIZE)
    tickRate = SETTINGS.TICK_RATE
    isGameOver = false
end

local function checkSelfCollision(head)
    for i = 3, #snake.segments do
        if
            head[1] == snake.segments[i][1]
            and head[2] == snake.segments[i][2]
        then
            return true
        end
    end
    return false
end

local function updateGame()
    local head = snake.segments[1]
    local newHead = {
        (head[1] + snake.direction.x - 1) % SETTINGS.GRID_SIZE + 1,
        (head[2] + snake.direction.y - 1) % SETTINGS.GRID_SIZE + 1,
    }
    table.insert(snake.segments, 1, newHead)
    snake.direction.canChange = true

    if checkSelfCollision(newHead) then
        isGameOver = true
    elseif newHead[1] == food.x and newHead[2] == food.y then
        food.x, food.y =
            math.random(1, SETTINGS.GRID_SIZE),
            math.random(1, SETTINGS.GRID_SIZE)
        tickRate = tickRate + SETTINGS.TICK_RATE_INCREASE
    else
        table.remove(snake.segments)
    end
end

-- Drawing Functions
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
    love.graphics.setColor(1, 1, 1, 1)
end

local function drawSnake()
    for index, segment in ipairs(snake.segments) do
        love.graphics.setColor(
            index == 1 and COLORS.SNAKE.HEAD or COLORS.SNAKE.BODY
        )
        love.graphics.rectangle(
            "fill",
            (segment[1] - 1) * BLOCK_SIZE,
            (segment[2] - 1) * BLOCK_SIZE,
            BLOCK_SIZE,
            BLOCK_SIZE
        )
    end
    love.graphics.setColor(1, 1, 1, 1)
end

local function drawFood()
    love.graphics.setColor(COLORS.FOOD)
    love.graphics.rectangle(
        "fill",
        (food.x - 1) * BLOCK_SIZE,
        (food.y - 1) * BLOCK_SIZE,
        BLOCK_SIZE,
        BLOCK_SIZE
    )
    love.graphics.setColor(1, 1, 1, 1)
end

local function drawGameOver()
    love.graphics.setColor(COLORS.GAME_OVER.BACKGROUND)
    love.graphics.rectangle(
        "fill",
        0,
        0,
        SETTINGS.SCREEN_SIZE,
        SETTINGS.SCREEN_SIZE
    )
    love.graphics.setColor(1, 1, 1, 1)

    local centerX, centerY =
        love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
    love.graphics.printf(
        "Game Over!",
        centerX - 100,
        centerY - 20,
        200,
        "center"
    )
    love.graphics.printf(
        "Press 'R' to restart!",
        centerX - 100,
        centerY + 20,
        200,
        "center"
    )
end

-- Input Handling
local function handleDirectionInputs(key)
    local inputMap = {
        [CONTROLS.SNAKE.UP] = { x = 0, y = -1 },
        [CONTROLS.SNAKE.DOWN] = { x = 0, y = 1 },
        [CONTROLS.SNAKE.LEFT] = { x = -1, y = 0 },
        [CONTROLS.SNAKE.RIGHT] = { x = 1, y = 0 },
    }

    if inputMap[key] and snake.direction.canChange then
        if
            snake.direction.x ~= -inputMap[key].x
            or snake.direction.y ~= -inputMap[key].y
        then
            snake.direction = inputMap[key]
            snake.direction.canChange = false
        end
    end
end

-- LOVE2D Functions
function love.load()
    love.window.setMode(SETTINGS.SCREEN_SIZE, SETTINGS.SCREEN_SIZE)
    love.graphics.setBackgroundColor(COLORS.BACKGROUND)
    restartGame()
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
    if isGameOver then
        drawGameOver()
    end
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
