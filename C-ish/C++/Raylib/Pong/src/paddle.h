#pragma once

#include <raylib.h>
#include <algorithm>
#include "utils.h"

class Paddle : private Rectangle {
public: 
    Paddle(Vector2 position, float width, float height);
    void Update(float delta);
    void Draw();

    KeyboardKey UpAction;
    KeyboardKey DownAction;

    Vector2 position;
    float width;
    float height;
    float speed;
    Color color;

    int score;
};