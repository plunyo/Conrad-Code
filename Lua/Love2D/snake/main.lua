-- love2d snake game (conrad thieu)

-- Constants for game settings
local SCREEN_SIZE = 900
local GRID_SIZE = 15
local TICK_RATE = 7

-- Control mappings for the game
local controls = {
    quit = "q",
    reload = "r",
    left = "left",
    down = "down",
    up = "up",
    right = "right",
}

-- Color mappings
local colors = {
    snake = { 0, 1, 0, 1 },
    snakeHead = { 0.54, 1, 0.54, 1 },
    food = { 1, 0, 0, 1 },
    grid = { 0.69, 0.69, 0.69 },
}

-- Snake properties
local startingPos = math.ceil(GRID_SIZE / 2)
local snake = {
    direction = { x = 1, y = 0 },
    segments = {
        { startingPos, startingPos },
        { startingPos - 1, startingPos },
        { startingPos - 2, startingPos },
        { startingPos - 3, startingPos },
        { startingPos - 4, startingPos },
    },
}

-- Food
local food = { x = 0, y = 0 }
local gameIconSprite = love.image.newImageData("assets/icon.png")
local gameOverSprite = love.graphics.newImage("assets/game_over.jpg")

-- Game variables
local isGameOver = false
local elapsedTime = 0

-- Function to spawn food in a random position not occupied by the snake
local function spawnFood()
    while true do
        food.x = math.random(GRID_SIZE - 1)
        food.y = math.random(GRID_SIZE - 1)
        local occupied = false

        for _, segment in ipairs(snake.segments) do
            if segment[1] == food.x and segment[2] == food.y then
                occupied = true
                break
            end
        end

        if not occupied then
            break
        end
    end
end

-- Function to reset the snake and food
local function resetGame()
    startingPos = math.ceil(GRID_SIZE / 2)
    snake.direction = { x = 1, y = 0 }
    snake.segments = {
        { startingPos, startingPos },
        { startingPos - 1, startingPos },
        { startingPos - 2, startingPos },
        { startingPos - 3, startingPos },
        { startingPos - 4, startingPos },
    }
    isGameOver = false
    elapsedTime = 0
    spawnFood() -- spawn food after resetting
end

-- Function to update the game logic
local function updateGameLogic()
    -- Move the snake
    local head = snake.segments[1]
    local newHead = {
        (head[1] + snake.direction.x) % GRID_SIZE,
        (head[2] + snake.direction.y) % GRID_SIZE,
    }

    -- Insert new head and check for collisions
    table.insert(snake.segments, 1, newHead)
    for i = 2, #snake.segments do -- Start from 2 to skip the head
        if
            newHead[1] == snake.segments[i][1]
            and newHead[2] == snake.segments[i][2]
        then
            isGameOver = true
            return
        end
    end

    -- Check for food consumption
    if newHead[1] == food.x and newHead[2] == food.y then
        TICK_RATE = TICK_RATE * 1.01
        spawnFood() -- Spawn new food
    else
        table.remove(snake.segments) -- Remove the tail
    end
end

-- Function to draw the grid
local function drawGrid()
    local blockSize = SCREEN_SIZE / GRID_SIZE
    love.graphics.setColor(colors.grid)

    for x = 0, GRID_SIZE do
        for y = 0, GRID_SIZE do
            love.graphics.rectangle(
                "line",
                x * blockSize,
                y * blockSize,
                blockSize,
                blockSize
            )
        end
    end

    love.graphics.setColor(1, 1, 1, 1) -- Reset to white
end

-- Function to draw the snake
local function drawSnake()
    local blockSize = SCREEN_SIZE / GRID_SIZE

    for i, segment in ipairs(snake.segments) do
        love.graphics.setColor(i == 1 and colors.snakeHead or colors.snake)
        love.graphics.rectangle(
            "fill",
            segment[1] * blockSize,
            segment[2] * blockSize,
            blockSize,
            blockSize
        )
    end

    love.graphics.setColor(1, 1, 1, 1) -- Reset to white
end

-- Function to draw food
local function drawFood()
    local blockSize = SCREEN_SIZE / GRID_SIZE
    love.graphics.setColor(colors.food)
    love.graphics.rectangle(
        "fill",
        food.x * blockSize,
        food.y * blockSize,
        blockSize,
        blockSize
    )
    love.graphics.setColor(1, 1, 1, 1) -- Reset to white
end

-- Handle snake direction input
local function handleSnakeInput(key)
    local directionMap = {
        [controls.left] = { x = -1, y = 0 },
        [controls.right] = { x = 1, y = 0 },
        [controls.up] = { x = 0, y = -1 },
        [controls.down] = { x = 0, y = 1 },
    }

    local newDirection = directionMap[key]

    if
        newDirection
        and not (
            newDirection.x == -snake.direction.x
            and newDirection.y == -snake.direction.y
        )
    then
        snake.direction = newDirection
    end
end

-- Initialize game settings
function love.load()
    love.window.setMode(SCREEN_SIZE, SCREEN_SIZE)
    love.window.setTitle("Snake")
    love.window.setIcon(gameIconSprite)
    resetGame()
end

function love.update(dt)
    elapsedTime = elapsedTime + dt
    while elapsedTime >= 1 / TICK_RATE do
        updateGameLogic()
        elapsedTime = elapsedTime - (1 / TICK_RATE)
    end
end

-- Draw the game elements
function love.draw()
    if not isGameOver then
        drawGrid()
        drawFood()
        drawSnake()
    else
        love.graphics.draw(
            gameOverSprite,
            love.graphics.getWidth() / 2 - gameOverSprite:getWidth() / 2,
            love.graphics.getHeight() / 2 - gameOverSprite:getHeight() / 2
        )
    end
end

-- Handle key presses for controls
function love.keypressed(key)
    if key == controls.quit then
        love.event.quit() -- Exit the game
    elseif key == controls.reload then
        resetGame() -- Reload the game
    else
        handleSnakeInput(key)
    end
end
