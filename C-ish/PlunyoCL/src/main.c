#include "include/lexer.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    Lexer *lexer = init_lexer("var name = \"john doe\";"
                              "print(name);");

    Token *token = NULL;

    while ((token = lexer_get_next_token(lexer)) != NULL) {
        printf("Token(%d, %s)\n", token->type, token->value);
    }

    return EXIT_SUCCESS;
}
