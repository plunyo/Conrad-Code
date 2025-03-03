#pragma once

#include <stdlib.h>

typedef struct TOKEN_STRUCT {
        enum {
            TOKEN_IDENTIFIER,
            TOKEN_EQUALS,
            TOKEN_STRING,
            TOKEN_SEMI,
            TOKEN_LPAREN,
            TOKEN_RPAREN
        } type;

        char *value;
} Token;

Token *init_token(int type, char *value);
