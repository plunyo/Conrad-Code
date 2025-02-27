#include <iostream>

int main()
{
    char grade;

    while (true) {
        std::cout << "What letter grade: ";
        std::cin >> grade;

        if (grade == 'A' || grade == 'B' || grade == 'C' || grade == 'D' || grade == 'F') {
            break;
        } else {
            std::cout << "Please enter only letter grades (A - F).\n";
        }
    }

    switch(grade){
        case 'A':
            std::cout << "You did amazing!";
            break;
        case 'B':
            std::cout << "You did good!";
            break;
        case 'C':
            std::cout << "You did ok!";
            break;
        case 'D':
            std::cout << "You did not do good!";
            break;
        case 'F':
            std::cout << "You failed ;(";
            break;
        default:
            std::cout << "Please only enter in a letter grade (A - F)";
    }

    std::cout << "\nPress Enter to exit...";
    std::cin.ignore();
    std::cin.get();

    return 0;
}