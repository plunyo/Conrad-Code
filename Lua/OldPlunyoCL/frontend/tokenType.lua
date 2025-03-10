local Enum = require("utils.enum")

local TokenType = Enum.new({
    -- cuz goof stuff js ignore
    "PROGRAM",

    -- Literal Types
    "BLANK",
    "NUMBER",
    "IDENTIFIER",
    
    -- Keywords
    "VAR",
    
    -- Grouping & Operators
    "BIN_OPERATOR",
    "EQUALS",
    "L_PAREN",
    "R_PAREN",

    "EOF" -- End of file
})

TokenType.Lookup = {
    ["="] = TokenType.EQUALS,
    ["("] = TokenType.L_PAREN,
    [")"] = TokenType.R_PAREN,
    ["+"] = TokenType.BIN_OPERATOR,
    ["-"] = TokenType.BIN_OPERATOR,
    ["*"] = TokenType.BIN_OPERATOR,
    ["/"] = TokenType.BIN_OPERATOR,
    ["%"] = TokenType.BIN_OPERATOR,
    ["var"] = TokenType.VAR
}

return TokenType
