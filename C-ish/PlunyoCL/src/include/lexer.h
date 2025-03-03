#pragma once

#include "token.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

typedef struct LEXER_STRUCT {
        char *source_code;
        char current_char;
        unsigned int index;
} Lexer;

// lexer functions
Lexer *init_lexer(char *source_code);

void lexer_advance(Lexer *lexer);
void lexer_skip_whitespace(Lexer *lexer);
Token *lexer_get_next_token(Lexer *lexer);
Token *lexer_collect_string(Lexer *lexer);
Token *lexer_collect_identifier(Lexer *lexer);
Token *lexer_advance_with_token(Lexer *lexer, Token *token);
char *lexer_current_char_string(Lexer *lexer);
