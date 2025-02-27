#include "button.h"

Button::Button(float x, float y, float width, float height, Text textComponent) 
    : UIElement{x, y, width, height}
    , textComponent(textComponent)
    , pressed{[](){}}
{}

void Button::Draw() {
    textComponent.SetPosition((Vector2){width / 2, height / 2});

    color = Fade(color, 1.0f);
    if (CheckCollisionPointRec(GetMousePosition(), *this)) {
        color = Fade(color, 0.8f);
        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT)) {
            pressed.Fire();
        }
    }

    UIElement::Draw();
    textComponent.Draw();
}
