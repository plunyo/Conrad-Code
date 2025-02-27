#include "vector2.h"

Vector2::Vector2() : x(0), y(0) {}

Vector2::Vector2(float xParam, float yParam) : x(xParam), y(yParam) {}


Vector2 Vector2::operator+(const Vector2& other) const
{
    return Vector2(x + other.x, y + other.y);
}

Vector2 Vector2::operator-(const Vector2& other) const
{
    return Vector2(x - other.x, y - other.y);
}

Vector2 Vector2::operator*(float scalar) const
{
    return Vector2(x * scalar, y * scalar);
}

Vector2 Vector2::operator/(float scalar) const
{
    if (scalar != 0) {
        return Vector2(x / scalar, y / scalar);
    } else {
        std::cerr << "Error: Division by zero!" << std::endl;
        return *this;
    }
}

void Vector2::print() const {
    std::cout << "(" << x << ", " << y << ")" << std::endl;
}
