#include "ball.h"
#include <random>

Ball::Ball(Vector2 position, float radius)
    : position(position)
    , direction({-1, -1})
    , radius(radius)
    , speed(250.0f)
    , color(WHITE) 
{}

int score = 0;

void Ball::Update(float delta, std::vector<Paddle> paddles) {
    position.x += direction.x * delta * speed;
    position.y += direction.y * delta * speed;

    // Handle vertical bounds
    if (position.y - radius <= 0 || position.y + radius >= GetScreenHeight()) {
        direction.y = -direction.y;
        position.y = Utils::Clamp(position.y, radius, GetScreenHeight() - radius);
    }

    // Check paddle collisionss
    for (const Paddle& paddle : paddles) {
        Rectangle paddleRect = {paddle.position.x, paddle.position.y, paddle.width, paddle.height};
        if (CheckCollisionCircleRec(position, radius, paddleRect)) {
            speed = Utils::Clamp(speed * 1.05, 0.0f, 1000.0f);
            direction.x = -direction.x;
            position.x = Utils::Clamp(position.x, radius + paddle.width, GetScreenWidth() - radius - paddle.width);
        }
    }

    // Handle horizontal bounds
    if (position.x <= 0 || position.x >= GetScreenWidth()) {
        score += (position.x <= 0) ? 1 : -1;
        position = (Vector2){(float)GetScreenWidth() / 2, (float)GetScreenHeight() / 2};

        direction = (Vector2){-1, 1};
    }
}

void Ball::Draw() {
    DrawCircleV(position, radius, color);

    DrawText(std::to_string(score).c_str(), GetScreenWidth() / 2 - MeasureText(std::to_string(score).c_str(), 16) / 2, 10, 50, color);
}
