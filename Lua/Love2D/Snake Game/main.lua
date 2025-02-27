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
        BODY = { 0, 0.8, 0, 1 },
        HEAD = { 0, 1, 0, 1 },
    },

    GAME_OVER = {
        BACKGROUND = { 0.2, 0.2, 0.2, 0.8 },
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

local food = { x = 0, y = 0 }

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
    snake.direction = { x = 0, y = 0 }

    food.x, food.y =
        math.random(1, SETTINGS.GRID_SIZE), math.random(1, SETTINGS.GRID_SIZE) -- Generate new food

    isGameOver = false -- Reset game over state
end

-- update functions
local function checkSelfCollision(head)
    for i = 3, #snake.segments do -- skip da head
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

    -- Update new head position
    local newHead = {
        (head[1] + snake.direction.x - 1) % SETTINGS.GRID_SIZE + 1, -- Wrap around logic
        (head[2] + snake.direction.y - 1) % SETTINGS.GRID_SIZE + 1,
    }

    table.insert(snake.segments, 1, newHead)

    -- Check collisions
    if checkSelfCollision(newHead) then
        isGameOver = true -- Set game over state
    elseif newHead[1] == food.x and newHead[2] == food.y then
        food.x, food.y =
            math.random(1, SETTINGS.GRID_SIZE),
            math.random(1, SETTINGS.GRID_SIZE)
    else
        table.remove(snake.segments)
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
        (food.x - 1) * BLOCK_SIZE,
        (food.y - 1) * BLOCK_SIZE,
        BLOCK_SIZE,
        BLOCK_SIZE
    )

    love.graphics.setColor({ 1, 1, 1, 1 })
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
        -- Prevent the snake from reversing
        if
            (snake.direction.x ~= -inputMap[key].x)
            or (snake.direction.y ~= -inputMap[key].y)
        then
            snake.direction = inputMap[key]
        end
    end
end

-- love functions
function love.load()
    love.window.setMode(SETTINGS.SCREEN_SIZE, SETTINGS.SCREEN_SIZE)
    love.graphics.setFont(love.graphics.getFont(), 40)
    love.graphics.setBackgroundColor(COLORS.BACKGROUND)

    restartGame() -- Initialize the game state
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
