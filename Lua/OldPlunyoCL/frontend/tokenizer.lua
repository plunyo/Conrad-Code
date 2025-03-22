local errorMessages = require("frontend.errorMessages")
local TokenType = require("frontend.tokenType")
local Token = require("frontend.token")

local keywords = {
    ["blank"] = TokenType.BLANK,
    ["var"] = TokenType.VAR,
}

local Tokenizer = {}

local function isAlpha(str)
    return str:match("^[A-Za-z]+$") ~= nil
end

local function isDigit(str)
    return str:match("^[0-9]+$") ~= nil
end

function Tokenizer.Tokenize(sourceCode)
    print("sourceCode type:", type(sourceCode))
    if type(sourceCode) == "table" then
        for k, v in pairs(sourceCode) do
            print("key:", k, "value:", v, "value type:", type(v))
        end
    end
    local tokens = {}
    local src = {}

    -- split into individual characters
    for i = 1, #sourceCode do
        src[i] = sourceCode:sub(i, i)
    end

    while #src > 0 do
        local currentChar = table.remove(src, 1)

        if currentChar:match("%s") then
            -- ignore whitespace
        elseif TokenType.Lookup[currentChar] then
            table.insert(
                tokens,
                Token:new(currentChar, TokenType.Lookup[currentChar])
            )
        elseif isDigit(currentChar) then
            local num = currentChar
            while #src > 0 and isDigit(src[1]) do
                num = num .. table.remove(src, 1)
            end
            table.insert(tokens, Token:new(num, TokenType.NUMBER))
        elseif isAlpha(currentChar) then
            local identifier = currentChar
            while #src > 0 and isAlpha(src[1]) do
                identifier = identifier .. table.remove(src, 1)
            end
            table.insert(
                tokens,
                Token:new(
                    identifier,
                    keywords[identifier] or TokenType.IDENTIFIER
                )
            )
        else
            error(errorMessages.UNRECOGNIZED_TOKEN:format(currentChar))
        end
    end

    table.insert(tokens, Token:new("EndOfFile", TokenType.EOF))
    return tokens
end

return Tokenizer
