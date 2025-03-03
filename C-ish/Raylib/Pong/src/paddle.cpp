#include "paddle.h"

Paddle::Paddle(Vector2 position, float width, float height)
    : position(position)
    , width(width)
    , height(height)
    , speed(600.0f)
    , color(RAYWHITE) 
{}

void Paddle::Update(float delta) {
    int direction = 0;

    if (IsKeyDown(UpAction)) direction -= 1;
    if (IsKeyDown(DownAction)) direction += 1;

    position.y += direction * speed * delta;
    position.y = Utils::Clamp(position.y, 0, GetScreenHeight() - height);
}

void Paddle::Draw() {
    DrawRectangle(position.x, position.y, width, height, color);
}