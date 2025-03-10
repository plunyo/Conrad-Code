#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NUM_LENGTH 64

typedef enum { NUMBER, MULTIPLY, ADD, DIVIDE, SUBTRACT, MODULO } TokenType;

typedef struct {
        TokenType type;
        double value;
} Token;

typedef struct {
        int token_count;
        Token *tokens;
} TokenizerInfo;

void print_token(Token *token) {
    printf("{ Value: %f | Type: %d }\n", token->value, token->type);
}

TokenizerInfo tokenize(char *source_code) {
    int token_count = 0;
    Token *tokens = malloc(strlen(source_code) * sizeof(Token));

    if (tokens == NULL) {
        printf("token array malloc failed ;(\n");
        return (TokenizerInfo){0, NULL}; // Return empty info
    }

    for (int i = 0; i < strlen(source_code);) {
        if (isdigit(source_code[i])) { // Build number tokens
            char num_str[MAX_NUM_LENGTH];
            int num_index = 0;

            // Copy digits into num_str
            while (isdigit(source_code[i]) && num_index < MAX_NUM_LENGTH - 1) {
                num_str[num_index++] = source_code[i++];
            }
            num_str[num_index] = '\0'; // Null-terminate the string

            tokens[token_count++] = (Token){NUMBER, atof(num_str)};
        } else {
            // Handle other token types if needed (e.g., operators)
            i++; // Move to the next character
        }
    }

    return (TokenizerInfo){token_count, tokens};
}

int main(int argc, char *argv[]) {
    // Basic REPL
    while (1) {
        char input[128];

        printf("> ");
        fgets(input, sizeof(input), stdin);
        input[strcspn(input, "\n")] = '\0'; // Strip newline

        if (strcmp("exit", input) == 0)
            break;

        TokenizerInfo tokenizer_info = tokenize(input);

        if (tokenizer_info.tokens == NULL) {
            printf("token malloc failed ;(\n");
            continue;
        }

        for (int i = 0; i < tokenizer_info.token_count; i++) {
            print_token(&tokenizer_info.tokens[i]);
        }

        free(tokenizer_info.tokens); // Free allocated memory
    }

    return EXIT_SUCCESS;
}
