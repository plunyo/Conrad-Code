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

function Parser:expect(type, errorMessage)
    local prev = self:eat()

    if not prev or prev.type ~= type then
        error(
            string.format(
                "Parser Error:\n%s | %s | Expecting: %s",
                errorMessage,
                tostring(prev),
                type
            )
        )
    end

    return prev
end

-- [[ PARSER FUNCTIONS ]] --

function Parser:parseStatement()
    -- skip to parseExpr for now
    return self:parseExpr()
end

function Parser:parseExpr()
    return self:parseAdditiveExpr()
end

function Parser:parseAdditiveExpr()
    local left = self:parseMultiplicativeExpr()

    while self:at().value == "+" or self:at().value == "-" do
        local operator = self:eat().value
        local right = self:parseMultiplicativeExpr()

        left = AST.BinaryExpr:new(left, right, operator)
    end

    return left
end

function Parser:parseMultiplicativeExpr()
    local left = self:parsePrimaryExpr()

    while
        self:at().value == "*"
        or self:at().value == "/"
        or self:at().value == "%"
    do
        local operator = self:eat().value
        local right = self:parsePrimaryExpr()

        left = AST.BinaryExpr:new(left, right, operator)
    end

    return left
end

function Parser:parsePrimaryExpr()
    local tokenType = self:at().type

    local handler = ({
        [Lexer.TokenType.NUMBER] = function()
            return AST.NumericLiteral:new(tonumber(self:eat().value))
        end,

        [Lexer.TokenType.IDENTIFIER] = function()
            return AST.Identifier:new(self:eat().value)
        end,

        [Lexer.TokenType.NIL] = function()
            self:eat() -- consume 'nil'
            return AST.NilLiteral:new()
        end,

        [Lexer.TokenType.L_PAREN] = function()
            self:eat() -- consume '('
            local value = self:parseExpr()
            self:expect(
                Lexer.TokenType.R_PAREN,
                "expected closing parenthesis."
            )
            return value
        end,
    })[tokenType]

    if handler then
        return handler()
    else
        error(string.format('unexpected token: "%s"', tostring(self:at())))
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
