#include <iostream>

int main()
{
    int month;
    char again;

    while(true){
        while (true) {
        std::cout << "Enter the month (1-12): ";
        std::cin >> month;

        if (month >= 1 && month <= 12) {
            break;
        } else {
            std::cout << "Please enter only NUMBERS (1-12).\n";
        }
        }
        switch(month) {
        case 1:
            std::cout << "It is January!";
            break;
        case 2:
            std::cout << "It is February!";
            break;
        case 3:
            std::cout << "It is March!";
            break;
        case 4:
            std::cout << "It is April!";
            break;
        case 5:
            std::cout << "It is May!";
            break;
        case 6:
            std::cout << "It is June!";
            break;
        case 7:
            std::cout << "It is July!";
            break;
        case 8:
            std::cout << "It is August!";
            break;
        case 9:
            std::cout << "It is September!";
            break;
        case 10:
            std::cout << "It is October!";
            break;
        case 11:
            std::cout << "It is November!";
            break;
        case 12:
            std::cout << "It is December!";
            break;
        
        }
    again?
    }
    
    std::cout << "\nPress Enter to exit...";
    std::cin.ignore();
    std::cin.get();

    return 0;
}
