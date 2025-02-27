local Enum = require("utils.enum")

NodeType = Enum.new({
    "PROGRAM",
    "NUMERIC_LITERAL",
    "BLANK_LITERAL",
    "IDENTIFIER",
    "BINARY_EXPR",
})

-- Statement class
Statement = {}
Statement.__index = Statement

function Statement:new(kind)
    local instance = setmetatable({}, self)
    instance.kind = kind
    return instance
end

-- Program class, inheriting from Statement
Program = {}
Program.__index = Program

function Program:new(body)
    local instance = setmetatable(Statement:new(NodeType.PROGRAM), self)
    instance.body = body or {}
    return instance
end

-- Expression class
Expr = {}
Expr.__index = Expr

function Expr:new(kind)
    local instance = setmetatable({}, self)
    instance.kind = kind
    return instance
end

-- BinaryExpr class, inheriting from Expr
BinaryExpr = {}
BinaryExpr.__index = BinaryExpr

function BinaryExpr:new(left, right, operator)
    local instance = setmetatable(Expr:new(NodeType.BINARY_EXPR), self)
    instance.left = left
    instance.right = right
    instance.operator = operator
    return instance
end

-- Identifier class, inheriting from Expr
Identifier = {}
Identifier.__index = Identifier

function Identifier:new(symbol)
    local instance = setmetatable(Expr:new(NodeType.IDENTIFIER), self)
    instance.symbol = symbol
    return instance
end

-- NumericLiteral class, inheriting from Expr
NumericLiteral = {}
NumericLiteral.__index = NumericLiteral

function NumericLiteral:new(value)
    local instance = setmetatable(Expr:new(NodeType.NUMERIC_LITERAL), self)
    instance.value = value
    return instance
end

BlankLiteral = {}
BlankLiteral.__index = BlankLiteral

function BlankLiteral:new(value)
    local instance = setmetatable(Expr:new(NodeType.BLANK_LITERAL), self)
    instance.value = value
    return instance
end