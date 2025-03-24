local Interpreter = require("runtime.interpreter")
local Environment = require("runtime.environment")
local Values = require("runtime.values")
local Parser = require("frontend.parser")

local globalEnv = Environment:new()

globalEnv:declareVar("true", Values.BoolVal:new(true))
globalEnv:declareVar("false", Values.BoolVal:new(false))

globalEnv:declareVar("nil", Values.NilVal:new())

-- read file function
local function readFile(filename)
    local file = io.open(filename, "r")

    if not file then
        error("could not open file: " .. filename)
    end

    local content = file:read("*all")

    file:close()

    return content
end

-- main execution
if arg[1] then
    local fileContent = readFile(arg[1])
    local ast = Parser:generateAST(fileContent)
    local result = Interpreter:evaluate(ast, globalEnv)
    print(result)
else
    -- repl
    print("PlunyoCL (STDIN)")

    while true do
        io.write("> ")
        local input = io.read()

        if not input then
            print("\n[ EOF detected, exiting... ]")
            break
        elseif input == "exit()" then
            break
        end

        local ast = Parser:generateAST(input)
        local result = Interpreter:evaluate(ast, globalEnv)
        print(result, "\n")
    end
end
