#include "ui_element.h"

UIElement::UIElement(float x, float y, float width, float height)
    : Rectangle{x, y, width, height}
    , color(WHITE)
    , visible(true)
{}

void UIElement::Update() {}


void UIElement::Draw() {
    if (!visible) return;
    std::cout << x << ", " << y << std::endl;

    DrawRectangleRec(*this, color);
}
