const std = @import("std");
const rl = @import("raylib");
const mn = @import("menu.zig");
const Cons = @import("constants.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const startGame = mn.menu();
    if (startGame) {
        rl.initWindow(Cons.ScreenWidth, Cons.ScreenHeight, Cons.Title);
        defer rl.closeWindow(); // Close window and OpenGL context

        rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
        //--------------------------------------------------------------------------------------
        const topBorder = rl.Rectangle.init(0, 1, Cons.ScreenWidth, 10);
        const bottomBorder = rl.Rectangle.init(0, Cons.ScreenHeight - 11, Cons.ScreenWidth, 10);
        var player = rl.Rectangle.init(100 - 5, Cons.Origin.y - 30, 10, 60);
        var playerHeightVar: f32 = 0;
        var misunderstoodBot = rl.Rectangle.init(Cons.ScreenWidth - 100 - 5, Cons.Origin.y - 30, 10, 60);
        var ball = rl.Vector2.init(Cons.Origin.x, Cons.Origin.y);
        var ballVector = rl.Vector2.init(5, 2.5);

        // Main game loop
        while (!rl.windowShouldClose()) { // Detect window close button or ESC key
            // Logic
            //----------------------------------------------------------------------------------
            if (rl.isKeyPressed(rl.KeyboardKey.key_up)) {
                playerHeightVar = 10;
            }
            if (rl.isKeyPressed(rl.KeyboardKey.key_down)) {
                playerHeightVar = -10;
            }
            if (rl.isKeyUp(rl.KeyboardKey.key_up) and (rl.isKeyUp(rl.KeyboardKey.key_down)) or
                rl.checkCollisionRecs(player, bottomBorder) and playerHeightVar == -10 or
                rl.checkCollisionRecs(player, topBorder) and playerHeightVar == 10)
            {
                playerHeightVar = 0;
            }
            if (rl.checkCollisionCircleRec(ball, 5, player) or rl.checkCollisionCircleRec(ball, 5, misunderstoodBot)) {
                ballVector.x = -ballVector.x;
            }
            if (rl.checkCollisionCircleRec(ball, 5, topBorder) or rl.checkCollisionCircleRec(ball, 5, bottomBorder)) {
                ballVector.y = -ballVector.y;
            }
            //----------------------------------------------------------------------------------

            // Draw
            //----------------------------------------------------------------------------------
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(rl.Color.black);

            rl.drawRectangle(0, 0, Cons.ScreenWidth, 10, rl.Color.white);
            rl.drawRectangle(0, Cons.ScreenHeight - 10, Cons.ScreenWidth, 10, rl.Color.white);
            rl.drawRectangle(@divExact(Cons.ScreenWidth, 2) - 5, 10, 10, Cons.ScreenHeight - 20, rl.Color.white);

            rl.drawRectangleRec(player, rl.Color.blue);
            rl.drawRectangleRec(misunderstoodBot, rl.Color.gray);

            rl.drawCircleV(ball, 5, rl.Color.red);
            //----------------------------------------------------------------------------------

            // Update
            //----------------------------------------------------------------------------------
            player.y -= playerHeightVar;
            ball.x -= ballVector.x;
            ball.y -= ballVector.y;
            //----------------------------------------------------------------------------------
        }
    }
}
