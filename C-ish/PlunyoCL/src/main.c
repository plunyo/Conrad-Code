#include <stdio.h>
#include <stdlib.h>

#include "include/parser.h"

int main(int argc, char *argv[]) {
    Lexer *lexer = init_lexer("var name = \"john doe\";\n"
                              "print(name);\n");
    Parser *parser = init_parser(lexer);
    AST *root = parser_parse(parser);

    printf("%d\n", root->type);
    printf("%d\n", root->compound_size);

    return EXIT_SUCCESS;
}
