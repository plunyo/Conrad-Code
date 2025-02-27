#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_NUM_LENGTH 64

typedef enum {
    NUMBER,
    MULTIPLY,
    ADD,
    DIVIDE,
    SUBTRACT,
    MODULO
} TokenType;

typedef struct {
    TokenType type;
    double value;
} Token;

void print_token(Token *token) {
    printf("{ Value: %f | Type: %d }", token->value, token->type);
}

Token* tokenize(char* source_code) {
    int token_count = strlen(source_code); // every char is a token
    Token* tokens = malloc(token_count * sizeof(Token)); // malloc to token_count * sizeof(Token)
    
    if (tokens == NULL) printf("token array malloc failed ;(");

    for (int i = 0; i < token_count; i++) {
        if (isdigit(source_code[i])) { // build number tokens
            char num_str[MAX_NUM_LENGTH]; // 64 buffer
            int num_index = i;

            while (isdigit(source_code[num_index]) && num_index > MAX_NUM_LENGTH) { // while its still a number
                num_str[num_index] = source_code[num_index];
                num_index++;
            }

            tokens[num_index] = (Token){NUMBER, atof(num_str)};
            i += num_index;
        }
    }
    
    return tokens;
}

int main(int argc, char *argv[]) {
    // basic repl
    while (1) {
        char input[128];
        
        printf("> ");
        fgets(input, sizeof(input), stdin);
        input[strcspn(input, "\n")] = '\0';
        if (strcmp("exit", input) == 0) break;

        Token* tokens = tokenize(input);

        if (tokens == NULL) {
            printf("token malloc failed ;(");
            continue;
        }

        for (int i = 0; i < sizeof(&tokens) / sizeof(tokens[0]); i++) {
        } 
    
    }
    
    return EXIT_SUCCESS;
}
