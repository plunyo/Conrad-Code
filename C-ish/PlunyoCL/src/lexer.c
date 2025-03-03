#include "include/lexer.h"

Lexer *init_lexer(char *source_code) {
    Lexer *lexer = calloc(1, sizeof(Lexer));

    lexer->source_code = source_code;
    lexer->index = 0;
    lexer->current_char = source_code[lexer->index]; // Use index instead of i

    return lexer;
}

void lexer_advance(Lexer *lexer) {
    if (lexer->current_char != '\0' &&
        lexer->index < strlen(lexer->source_code)) {
        lexer->index++;
        lexer->current_char = lexer->source_code[lexer->index];
    }
};

void lexer_skip_whitespace(Lexer *lexer) {
    while (lexer->current_char == ' ' || lexer->current_char == '\n' ||
           lexer->current_char == '\t' || isspace(lexer->current_char)) {
        lexer_advance(lexer);
    }
}

Token *lexer_advance_with_token(Lexer *lexer, Token *token) {
    lexer_advance(lexer);

    return token;
};

Token *lexer_get_next_token(Lexer *lexer) {
    while (lexer->current_char != '\0' &&
           lexer->index < strlen(lexer->source_code)) {

        if (lexer->current_char == ' ' || lexer->current_char == '\n' ||
            lexer->current_char == '\t' || isspace(lexer->current_char))
            lexer_skip_whitespace(lexer);

        if (isalnum(lexer->current_char))
            return lexer_collect_identifier(lexer);

        if (lexer->current_char == '"')
            return lexer_collect_string(lexer);

        switch (lexer->current_char) {
        case '=':
            return lexer_advance_with_token(
                lexer,
                init_token(TOKEN_EQUALS, lexer_current_char_string(lexer)));

        case ';':
            return lexer_advance_with_token(
                lexer,
                init_token(TOKEN_SEMI, lexer_current_char_string(lexer)));

        case '(':
            return lexer_advance_with_token(
                lexer,
                init_token(TOKEN_LPAREN, lexer_current_char_string(lexer)));
        case ')':
            return lexer_advance_with_token(
                lexer,
                init_token(TOKEN_RPAREN, lexer_current_char_string(lexer)));
        default:
            return NULL;
        }
    }

    return NULL;
};

char *lexer_current_char_string(Lexer *lexer) {
    char *str = calloc(2, sizeof(char));
    str[0] = lexer->current_char;
    str[1] = '\0';

    return str;
};

Token *lexer_collect_identifier(Lexer *lexer) {
    char *value = calloc(1, sizeof(char));
    value[0] = '\0';

    while (isalnum(lexer->current_char)) {
        char *string = lexer_current_char_string(lexer);
        value =
            realloc(value, (strlen(value) + strlen(string) + 1) * sizeof(char));
        strcat(value, string);

        lexer_advance(lexer);
    }

    return init_token(TOKEN_STRING, value);
};

Token *lexer_collect_string(Lexer *lexer) {
    lexer_advance(lexer);

    char *value = calloc(1, sizeof(char));
    value[0] = '\0';

    while (lexer->current_char != '"') {
        char *string = lexer_current_char_string(lexer);
        value =
            realloc(value, (strlen(value) + strlen(string) + 1) * sizeof(char));
        strcat(value, string);

        lexer_advance(lexer);
    }

    lexer_advance(lexer);

    return init_token(TOKEN_STRING, value);
};
