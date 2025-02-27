local tokenizer = require("frontend.tokenizer")
local TokenType = require("frontend.tokenType")
local Token = require("frontend.token")

require("frontend.astNodes")

local Parser = {}
Parser.__index = Parser

function Parser:new()
    local instance = setmetatable({}, Parser)

    instance.tokens = {}

    return instance
end

function Parser:notEOF()
    return self.tokens[1] ~= TokenType.EOF
end

function Parser:at()
    return self.tokens[1]
end

function Parser:eat()
    return table.remove(self.tokens, 1)
end

function Parser:parseStatement()
    return self:parseExpr()
end

function Parser:parseExpr()
    return self:parsePrimaryExpression()
end

function Parser:parsePrimaryExpression()
    local tk = self:at().type

    if tk == TokenType.IDENTIFIER then
        return Identifier:new(self:eat().value)
    elseif tk == TokenType.NUMBER then
        return NumericLiteral:new(tonumber(self:eat().value))
    else
        error("-- Unexpected token found during parsing! --", self:at())
    end
end

function Parser:generateAST(sourceCode)
    self.tokens = tokenizer.Tokenize(sourceCode)
    local program = Program:new()

    -- Parse till end
    while self:notEOF() do
        local statement = self:parseStatement()
        table.insert{program.body, statement}
    end

    return program
end

return Parser