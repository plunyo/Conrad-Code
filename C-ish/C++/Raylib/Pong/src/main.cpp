#include <raylib.h>
#include "paddle.h"
#include "ball.h"

int main() {
    InitWindow(600, 800, "Pong");

    const float PADDLE_CENTER = GetScreenHeight() * 0.5f - 100.0f;

    Paddle playerOne((Vector2){0, PADDLE_CENTER}, 50.0f, 200.0f);
    playerOne.UpAction = KEY_W;
    playerOne.DownAction = KEY_S;

    Paddle playerTwo((Vector2){GetScreenWidth() - 50.0f, PADDLE_CENTER}, 50.0f, 200.0f);
    playerTwo.UpAction = KEY_UP;
    playerTwo.DownAction = KEY_DOWN;
    
    Ball ball((Vector2){(float)GetScreenWidth() / 2, (float)GetScreenHeight() / 2}, 15);

    while (!WindowShouldClose()) {
        float delta = GetFrameTime();

        playerOne.Update(delta);
        playerTwo.Update(delta);

        ball.Update(delta, {playerOne, playerTwo});

        BeginDrawing();
            ClearBackground(BLACK);

            playerOne.Draw();
            playerTwo.Draw();

            ball.Draw();

            DrawFPS(10, 10);
        EndDrawing();
    }
    
    CloseWindow();
}