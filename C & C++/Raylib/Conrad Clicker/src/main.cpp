#include "button.h"
#include "text.h"
#include <raylib.h>

int main() {
    Vector2 screenSize = (Vector2){1152.0f, 648.0f};

    InitWindow(screenSize.x, screenSize.y, "Conrad Clicker");
    SetTargetFPS(GetMonitorRefreshRate(GetCurrentMonitor()));

    Button testButton(screenSize.x / 2, screenSize.y / 2, 200.0f, 50.0f,
                      Text("testButton", CENTERED, 16));

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(DARKGRAY);

        testButton.Draw();

        DrawFPS(10, 10);
        EndDrawing();
    }

    CloseWindow();
}
