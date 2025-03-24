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

function Parser:parseVarDeclaration()
    local keywordToken = self:eat()

    if
        keywordToken.type ~= Lexer.TokenType.VAR
        and keywordToken.type ~= Lexer.TokenType.CONST
    then
        error("Expected 'var' or 'const' keyword.")
    end

    local isConstant = keywordToken.type == Lexer.TokenType.CONST

    local identifier = self:expect(
        Lexer.TokenType.IDENTIFIER,
        "Expected identifier name after 'var' or 'const'."
    ).value

    if self:at().type == Lexer.TokenType.SEMICOLON then
        self:eat() -- eat semicolon

        if isConstant then
            error("Constants must have an assigned value. None provided.")
        end

        return AST.VarDeclaration:new(isConstant, identifier)
    end

    self:expect(Lexer.TokenType.EQUALS, "Expected '=' after identifier.")

    local value = self:parseExpr()

    self:expect(
        Lexer.TokenType.SEMICOLON,
        "Expected ';' at the end of the declaration."
    )

    return AST.VarDeclaration:new(isConstant, identifier, value)
end

function Parser:parseStatement()
    local tkType = self:at().type

    if tkType == Lexer.TokenType.VAR or tkType == Lexer.TokenType.CONST then
        return self:parseVarDeclaration()
    else
        return self:parseExpr()
    end
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

    if tokenType == Lexer.TokenType.NUMBER then
        return AST.NumericLiteral:new(tonumber(self:eat().value))
    elseif tokenType == Lexer.TokenType.IDENTIFIER then
        return AST.Identifier:new(self:eat().value)
    elseif tokenType == Lexer.TokenType.L_PAREN then
        self:eat() -- consume '('
        local value = self:parseExpr()
        self:expect(Lexer.TokenType.R_PAREN, "Expected closing parenthesis.")
        return value
    else
        error(string.format('Unexpected token: "%s"', tostring(self:at())))
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
