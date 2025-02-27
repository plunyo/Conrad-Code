#include <iostream>

int main() {
    std::cout << "Starting count..." << std::endl;
    
    for (long long i = 1; i <= 1000000000; ++i) {
        if (i % 100000000 == 0) {  // Print progress every 100 million
            std::cout << "Reached: " << i << std::endl;
        }
    }

    std::cout << "Counting completed!" << std::endl;
    return 0;
}
