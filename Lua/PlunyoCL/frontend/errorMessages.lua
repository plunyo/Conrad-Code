local errorMessages = {
    UNEXPECTED = {
        TOKEN = "|PlunyoCL| Unexpected token found during parsing: %s",
        PARENTHESIS = "|PlunyoCL| Unexpected token found inside parenthesised expression. Expected closing parenthesis.",
    },
    UNRECOGNIZED_TOKEN = "|PlunyoCL| Unrecognized token: %s",
    PARSER = "|PlunyoCL| Parser Error: %s %s Expected: %s",
    AST_NODE_INTERPRETATION = "|PlunyoCL| This AST Node has not yet been setup for interpretation: %s",
}

return errorMessages