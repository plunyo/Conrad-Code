#include "include/parser.h"

Parser *init_parser(Lexer *lexer) {
    Parser *parser = calloc(1, sizeof(struct PARSER_STRUCT));
    parser->lexer = lexer;
    parser->current_token = lexer_get_next_token(lexer);

    return parser;
}

void parser_eat(Parser *parser, int token_type) {
    if (parser->current_token->type == token_type) {
        parser->current_token = lexer_get_next_token(parser->lexer);
    } else {
        printf("Unexpected Token '%s', with type '%d'",
               parser->current_token->value, parser->current_token->type);
        exit(EXIT_FAILURE);
    }
}

AST *parser_parse(Parser *parser) { return parser_parse_statements(parser); }

AST *parser_parse_statement(Parser *parser) {
    switch (parser->current_token->type) {
    case TOKEN_IDENTIFIER:
        return parser_parse_identifier(parser);
    }
}

AST *parser_parse_statements(Parser *parser) {
    AST *compound = init_ast(AST_COMPOUND);
    compound->compound_value = calloc(1, sizeof(struct AST_STRUCT *));

    AST *ast_statement = parser_parse_statement(parser);
    compound->compound_value[0] = ast_statement;
    compound->compound_size++;

    while (parser->current_token->type == TOKEN_SEMI) {
        parser_eat(parser, TOKEN_SEMI);

        AST *ast_statement = parser_parse_statement(parser);
        compound->compound_size++;
        compound->compound_value =
            realloc(compound->compound_value,
                    compound->compound_size * sizeof(struct AST_STRUCT *));
        compound->compound_value[compound->compound_size - 1] = ast_statement;
    }

    return compound;
}

AST *parser_parse_expression(Parser *parser) {}

AST *parser_parse_factor(Parser *parser) {}

AST *parser_parse_term(Parser *parser) {}

AST *parser_parse_function_call(Parser *parser) {}

AST *parser_parse_variable_definition(Parser *parser) {
    parser_eat(parser, TOKEN_IDENTIFIER); // var
    char *variable_definition_variable_name = parser->current_token->value;
    parser_eat(parser, TOKEN_IDENTIFIER); // var name
    parser_eat(parser, TOKEN_EQUALS);     // var name =
    AST *variable_definition_value = parser_parse_expression(parser);

    AST *variable_definition = init_ast(AST_VARIABLE_DEFINITION);

    variable_definition->variable_definition_variable_name =
        variable_definition_variable_name;

    variable_definition->variable_definition_value = variable_definition_value;

    return variable_definition;
}

AST *parser_parse_variable(Parser *parser) {
    char *token_value = parser->current_token->value;
    parser_eat(parser, TOKEN_IDENTIFIER);

    if (parser->current_token->type == TOKEN_LPAREN)
        return parser_parse_function_call(parser);

    AST *ast_variable = init_ast(AST_VARIABLE);
    ast_variable->variable_name = token_value;

    return ast_variable;
}

AST *parser_parse_string(Parser *parser) {}

AST *parser_parse_identifier(Parser *parser) {
    if (strcmp(parser->current_token->value, "var") == 0) {
        return parser_parse_variable_definition(parser);
    } else {
        return parser_parse_variable(parser);
    }
}
