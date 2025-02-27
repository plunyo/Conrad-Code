#include "text.h"

Text::Text(std::string text, AlignmentType alignment, int fontSize)
    : text(std::move(text))
    , alignment(alignment)
    , fontSize(fontSize)
    , font(GetFontDefault())
{}

void Text::SetPosition(Vector2 newPosition) {
    position = newPosition;
}

void Text::Draw() {
    Vector2 textSize = MeasureTextEx(font, text.c_str(), fontSize, 1);

    Vector2 alignedPosition = position;
    switch (alignment) {
        case LEFT:
            break;
        case RIGHT:
            alignedPosition.x -= textSize.x;
            break;
        case UP:
            alignedPosition.y -= textSize.y;
            break;
        case DOWN:
            alignedPosition.y += textSize.y;
            break;
        case CENTERED:
            alignedPosition.x -= textSize.x / 2;
            alignedPosition.y -= textSize.y / 2;
            break;
    }

    DrawTextEx(font, text.c_str(), alignedPosition, fontSize, 1, WHITE);
}
