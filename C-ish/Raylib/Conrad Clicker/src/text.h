#pragma once

#include <iostream>
#include "raylib.h"

enum AlignmentType { LEFT, RIGHT, UP, DOWN, CENTERED };

class Text {
public:
    std::string text;
    AlignmentType alignment;
    int fontSize;
    Font font;

    Text(std::string text, AlignmentType alignment, int fontSize);
    void SetPosition(Vector2 newPosition);
    void Draw();
private:
    Vector2 position;
};
