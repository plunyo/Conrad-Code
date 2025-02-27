#pragma once

#include <raylib.h>
#include <iostream>
#include <vector>
#include "paddle.h"
#include "utils.h"

class Ball {
public: 
    Ball(Vector2 position, float radius);
    void Update(float delta, std::vector<Paddle> paddles);
    void Draw();
private:
    Vector2 position;
    Vector2 direction;
    float radius;
    float speed;
    Color color;
};