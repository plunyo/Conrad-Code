#pragma once

#include <iostream>
#include "ui_element.h"
#include "text.h"
#include "signal.h"

class Button : public UIElement {
private:
    Text textComponent;
public:
    Signal pressed;

    Button(float x, float y, float width, float height, Text textComponent);
    void Draw() override;
};
