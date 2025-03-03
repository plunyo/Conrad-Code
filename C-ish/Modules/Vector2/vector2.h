#ifndef VECTOR2_H
#define VECTOR2_H

#include <iostream>

class Vector2 
{
    public:
        float x;
        float y;

        Vector2();

        Vector2(float xParam, float yParam);

        Vector2 operator+(const Vector2& other) const;
        Vector2 operator-(const Vector2& other) const;

        Vector2 operator*(float scalar) const;
        Vector2 operator/(float scalar) const;

        void print() const;
};

#endif
