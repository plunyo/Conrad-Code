#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc < 3 || argc % 2 == 0) {
        printf("hey, just use it like this: calc <num> <operator> <num> "
               "[<operator> <num> ...]\n");
        return EXIT_FAILURE;
    }

    char *endptr;
    int result = strtol(argv[1], &endptr, 10);
    if (*endptr != '\0') {
        printf("invalid number: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    for (int i = 2; i < argc; i += 2) {

        printf("processing: %s %s\n", argv[i], argv[i + 1]);
        char operator= argv[i][0];
        if (!strchr("+-*/", operator)) {
            printf("invalid operator: %c. use +, -, *, or /\n", operator);
            return EXIT_FAILURE;
        }

        int num = strtol(argv[i + 1], &endptr, 10);
        if (*endptr != '\0') {
            printf("invalid number: %s\n", argv[i + 1]);
            return EXIT_FAILURE;
        }

        switch (operator) {
        case '+':
            result += num;
            break;
        case '-':
            result -= num;
            break;
        case '*':
            result *= num;
            break;
        case '/':
            if (num == 0) {
                printf("error: division by zero\n");
                return EXIT_FAILURE;
            }
            result /= num;
            break;
        }
    }

    printf("result: %d\n", result);
    return EXIT_SUCCESS;
}
