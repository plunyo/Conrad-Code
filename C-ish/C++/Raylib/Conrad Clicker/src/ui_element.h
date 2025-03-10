#pragma once

#include <raylib.h>
#include <iostream>

class UIElement : public Rectangle {
public:
    Color color;
    bool visible;

    UIElement(float x, float y, float width, float height);
    virtual void Draw();
    virtual void Update();
};
