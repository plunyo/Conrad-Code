local Lexer = require("frontend.lexer")
local AST = require("frontend.ast")

local Parser = {
    tokens = {},
    index = 1,
}

function Parser:at()
    return self.tokens[self.index]
end

function Parser:eat()
    local current = self:at()
    self.index = self.index + 1
    return current
end

-- [[ PARSER FUNCTIONS ]] --

function Parser:parseStatement()
    -- skip to parseExpr for now
    return self:parseExpr()
end

function Parser:parseExpr()
    return self:parsePrimaryExpr()
end

function Parser:parsePrimaryExpr()
    local tokenType = self:at().type

    if tokenType == Lexer.TokenType.NUMBER then
        return AST.NumericLiteral:new(tonumber(self:eat().value))
    elseif tokenType == Lexer.TokenType.IDENTIFIER then
        return AST.Identifier:new(self:eat().value)
    else
        error(
            string.format(
                'Unexpected token found during parsing "%s"',
                tostring(self:at())
            )
        )
    end
end

-- [[ PARSER FUNCTIONS ]] --

-- generat AST tiem 👍

function Parser:generateAST(sourceCode)
    self.tokens = Lexer.Tokenize(sourceCode)
    self.index = 1

    local program = AST.Program:new()

    while
        self.index <= #self.tokens and self:at().type ~= Lexer.TokenType.EOF
    do
        local statement = self:parseStatement()
        table.insert(program.body, statement)
    end

    return program
end

return Parser
