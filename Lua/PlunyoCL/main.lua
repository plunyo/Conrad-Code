local Tokenizer = require("frontend.tokenizer")
local Parser = require("frontend.parser")
local utils = require("utils.utils")

local sourceCode

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

local tokens = Tokenizer.Tokenize(sourceCode)
local parser = Parser:new()

parser:generateAST(tokens)
print(sourceCode)
print(utils.tableToString(parser.ast))
