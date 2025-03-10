#include <stdio.h>
#include <stdbool.h>

int main() {
    int num1;
    int num2;

    char operator;

    bool finished = false;

    printf("--------------- C Calculator ---------------\n\n");

    while (!finished) {
        printf("Enter First Number: ");
        scanf("%d", &num1);

        printf("Enter Operator (+, -, *, /): ");
        scanf(" %c", &operator);

        printf("Enter Second Number: ");
        scanf("%d", &num2);

        switch (operator) {
            case '+':
                printf("%d + %d = %d\n", num1, num2, num1 + num2);
                break;
            case '-':
                printf("%d - %d = %d\n", num1, num2, num1 - num2);
                break;
            case '*':
                printf("%d * %d = %d\n", num1, num2, num1 * num2);
                break;
            case '/':
                if (num2 != 0) {
                    printf("%d / %d = %d\n", num1, num2, num1 / num2);
                } else {
                    printf("Error: Division by zero\n");
                }
                break;
            default:
                printf("Error: Unknown operator %c\n", operator);
                break;
        }

        char choice;

        printf("Are you finished? [Y]es / [N]o: ");
        scanf(" %c", &choice);

        if (choice == 'Y' || choice == 'y') {
            finished = true;
        } else if (choice == 'N' || choice == 'n') {
            finished = false;
        } else {
            printf("Invalid choice. Please enter Y or N.\n");
        }
    }

    return 0;
}
