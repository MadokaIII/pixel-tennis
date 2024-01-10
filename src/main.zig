const std = @import("std");
const rl = @import("raylib");
const screenWidth = 1280;
const screenHeight = 720;
const title = "Pong";

pub fn getCenteredxPos(text: [:0]const u8, fontSize: i32) i32 {
    const textSize = rl.measureText(text, fontSize);
    return @divFloor((screenWidth - textSize), 2);
}

pub fn menu() bool {
    const play = "Press ENTER to launch Game";
    var enterPressed = false;

    rl.initWindow(screenWidth, screenHeight, title);
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main menu loop
    while (!rl.windowShouldClose()) {
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.drawText(title, getCenteredxPos(title, 100), 150, 100, rl.Color.white);
        rl.drawText(play, getCenteredxPos(play, 40), 380, 40, rl.Color.white);
        //----------------------------------------------------------------------------------
        // Check for Enter key
        if (rl.isKeyPressed(rl.KeyboardKey.key_enter)) {
            enterPressed = true;
            break; // Exit the loop if Enter is pressed
        }
    }
    return enterPressed;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const startGame = menu();
    if (startGame) {
        rl.initWindow(screenWidth, screenHeight, title);
        defer rl.closeWindow(); // Close window and OpenGL context

        rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
        //--------------------------------------------------------------------------------------
        var player = rl.Rectangle.init(@divTrunc(screenWidth, 5) - 5, @divExact(screenHeight, 2) - 30, 10, 60);
        var misunderstoodBot = rl.Rectangle.init((@divTrunc(screenWidth, 5) * 4) - 5, @divExact(screenHeight, 2) - 30, 10, 60);
        var ball = rl.Rectangle.init(@divExact(screenWidth, 2) - 5, @divExact(screenHeight, 2) - 5, 10, 10);
        var ballVector = rl.Vector2.init(0, 0);
        var rotation = @as(f32, 1.0);

        // Main game loop
        while (!rl.windowShouldClose()) { // Detect window close button or ESC key
            // Update
            //----------------------------------------------------------------------------------
            ballVector.x += 5;
            ballVector.y += 2.5;
            //----------------------------------------------------------------------------------

            // Draw
            //----------------------------------------------------------------------------------
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(rl.Color.black);

            rl.drawRectangle(@divExact(screenWidth, 2) - 5, 0, 10, screenHeight, rl.Color.white);
            rl.drawRectangleRec(player, rl.Color.blue);
            rl.drawRectangleRec(misunderstoodBot, rl.Color.gray);
            rl.drawRectanglePro(ball, ballVector, rotation, rl.Color.red);
            //----------------------------------------------------------------------------------

            // Logic
            //----------------------------------------------------------------------------------
            if (rl.isKeyDown(rl.KeyboardKey.key_up)) {
                player.y -= 10;
            }
            if (rl.isKeyDown(rl.KeyboardKey.key_down)) {
                player.y += 10;
            }
            if (rl.checkCollisionRecs(ball, player)) {
                rotation += 90;
            }
            //----------------------------------------------------------------------------------
        }
    }
}
