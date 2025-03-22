local Lexer = require("frontend.lexer")

local sourceCode = ""

if arg[1] then
    local file = io.open(arg[1], "r")
    if file then
        sourceCode = file:read("*all")

        file:close()
    else
        error("Could not open file: " .. arg[1])
    end
else
    sourceCode = io.read()
end

io.stderr()

local tokens = Lexer.Tokenize(sourceCode)

for _, token in ipairs(tokens) do
    print(token)
end
