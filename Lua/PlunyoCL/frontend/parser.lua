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

-- generat AST tiem 👍
function Parser:generateAST(sourceCode)
    self.tokens = Lexer.generateTokens(sourceCode)

    local program = AST.Program:new()

    while self:at() ~= Lexer.TokenType.EOF do
        local statement = self:parseStatement()

        table.insert(program.body, statement)
    end

    return program
end

return Parser
