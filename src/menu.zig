const std = @import("std");
const rl = @import("raylib");
const Cons = @import("constants.zig");

pub fn getCenteredxPos(text: [:0]const u8, fontSize: i32) i32 {
    const textSize = rl.measureText(text, fontSize);
    return @divFloor((Cons.ScreenWidth - textSize), 2);
}

pub fn menu() bool {
    const play = "Press ENTER to launch Game";
    var enterPressed = false;

    rl.initWindow(Cons.ScreenWidth, Cons.ScreenHeight, Cons.Title);
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

        rl.drawText(Cons.Title, getCenteredxPos(Cons.Title, 100), 150, 100, rl.Color.white);
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
