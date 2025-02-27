#include <iostream>

int main()
{
    char op;
    double num1;
    double num2;
    double result;

    std::cout << "******************************* CALCULATOR *******************************\n\n";

    while (true) {
        std::cout << "Welcome to the Calculator! \n\nEnter your operation (+, -, *, /): ";
        std::cin >> op;

        if (op == '+' || op == '-' || op == '*' || op == '/') {
            break;
        } else {
            std::cout << "\nPlease enter only valid operators (+, -, *, /).\n\n";
        }
    }

    std::cout << "\nEnter First Number: ";
    std::cin >> num1;

    std::cout << "\nEnter Second Number: ";
    std::cin >> num2;

    switch (op) {
    case '+':
        result = num1 + num2;
        break;
    case '-':
        result = num1 - num2;
        break;
    case '*':
        result = num1 * num2;
        break;
    case '/':
        if (num2 != 0) {
            result = num1 / num2;
        } else {
            std::cout << "\nError: Division by zero is not allowed.\n";
            return 1; // Exit the program with an error code
        }
        break;
    default:
        std::cout << "\nInvalid operator.\n";
        return 1; // Exit the program with an error code
    }

    std::cout << "\nThe answer is: " << result << "\n\n";
    std::cout << "**************************************************************************\n\n";

    std::cout << "\nPress Enter to exit...";
    std::cin.ignore();
    std::cin.get();
    
    return 0;
}
