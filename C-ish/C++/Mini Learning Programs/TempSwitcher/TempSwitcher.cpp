#include <iostream>

int main()
{
    double temp;
    char unit;

    std::cout << "******** TEMP CONVERSION ********\n";

    while (true) {
        std::cout << "F = Fahrenheit\n";
        std::cout << "C = Celsius\n";
        std::cout << "What would you like to convert to?: ";
        std::cin >> unit;

        if (unit == 'F' || unit == 'f' || unit == 'C' || unit == 'c' ){
            while(true) {
                if (unit == 'F' || unit == 'f'){
                    std::cout << "Enter the temp in Celcius: ";
                    std::cin >> temp;

                    temp = (1.8 * temp) + 32.0;
                    std::cout << "Temp is: " << temp << "F\n";
                    break;
                }
                else if (unit == 'C' || unit == 'c'){
                    std::cout << "Enter the temp in Fahrenheit: ";
                    std::cin >> temp;

                    temp = (temp - 32) / 1.8;
                    std::cout << "Temp is: " << temp << "C\n";
                    break;
                }
                else{
                    std::cout << "Please enter only valid units (C or F).\n";
                }
            }
        } 
        else {
            std::cout << "Please enter only valid units (C or F).\n";
        }
    }
    
    std::cout << "*********************************\n";

    std::cout << "\nPress Enter to exit...";
    std::cin.ignore();
    std::cin.get();

    return 0;
}