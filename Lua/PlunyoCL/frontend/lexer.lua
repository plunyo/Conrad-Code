local Lexer = {}

-- token types
local TokenType = {
    NIL = "Nil", -- Literal types
    NUMBER = "Number",
    IDENTIFIER = "Identifier",

    VAR = "Var", -- Keywords

    BIN_OPERATOR = "Binary Operator", -- Grouping & Operators
    EQUALS = "Equals",
    L_PAREN = "Left Parenthesis",
    R_PAREN = "Right Parenthesis",

    QUOTE = "Quote",

    EOF = "E.O.F", -- End of file
}

TokenType.Lookup = {
    ["="] = TokenType.EQUALS,

    ["("] = TokenType.L_PAREN,
    [")"] = TokenType.R_PAREN,

    ["+"] = TokenType.BIN_OPERATOR,
    ["-"] = TokenType.BIN_OPERATOR,
    ["*"] = TokenType.BIN_OPERATOR,
    ["/"] = TokenType.BIN_OPERATOR,
    ["%"] = TokenType.BIN_OPERATOR,

    ["'"] = TokenType.QUOTE,
    ['"'] = TokenType.QUOTE,

    ["var"] = TokenType.VAR,
}

-- token "class"
local Token = {}
Token.__index = Token

function Token:new(type, value)
    return setmetatable({ type = type, value = value }, self)
end

Token.__tostring = function(self)
    return string.format('(Type: %s | Value: "%s")', self.type, self.value)
end

-- actual tokenizing
local keywords = {
    ["nil"] = TokenType.NIL,
    ["var"] = TokenType.VAR,
}

local function isAlpha(str)
    return str:match("^[A-Za-z]+$") ~= nil
end

local function isDigit(str)
    return str:match("^[0-9]+$") ~= nil
end

function Lexer.Tokenize(sourceCode)
    local tokens, src, index = {}, {}, 1

    local function at()
        return src[index]
    end

    local function eat()
        local current = src[index]
        index = index + 1
        return current
    end

    for i = 1, #sourceCode do
        src[i] = sourceCode:sub(i, i)
    end

    while index <= #src do
        local currentChar = at()

        if currentChar and currentChar:match("%s") then
            eat()
            goto continue
        end

        if currentChar and TokenType.Lookup[currentChar] then
            table.insert(
                tokens,
                Token:new(TokenType.Lookup[currentChar], currentChar)
            )

            eat()
        elseif currentChar and isDigit(currentChar) then
            local num = eat()

            while index <= #src and isDigit(at()) do
                num = num .. eat()
            end

            table.insert(tokens, Token:new(TokenType.NUMBER, num))
        elseif currentChar and isAlpha(currentChar) then
            local identifier = eat()

            while index <= #src and isAlpha(at()) do
                identifier = identifier .. eat()
            end

            table.insert(
                tokens,
                Token:new(
                    keywords[identifier] or TokenType.IDENTIFIER,
                    identifier
                )
            )
        elseif currentChar then
            error(string.format('Unexpected Token "%s"', currentChar))
        end

        ::continue::
    end

    return tokens
end

-- return the module so other files can require it
Lexer.TokenType = TokenType
Lexer.Token = Token

return Lexer
