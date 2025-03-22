local Parser = require("frontend.parser")
local Lexer = require("frontend.lexer")

local sourceCode = ""

-- read file
if arg[1] then
    local file = io.open(arg[1], "r")
    if file then
        sourceCode = file:read("*all")
        file:close()
    else
        error("Could not open file: " .. arg[1])
    end
else
    -- repl
    print("PlunyoCL (STDIN)")

    while true do
        io.write("> ") -- use io.write to avoid extra \n
        local input = io.read()

        if not input then
            print("\n[ EOF detected, exiting... ]")
            break
        end

        if input == "exit" then
            break
        end

        print(Parser:generateAST(input), "\n")
    end
end
