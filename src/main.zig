const std = @import("std");
const rl = @import("raylib");
const mn = @import("menu.zig");
const cons = @import("constants.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const startGame = mn.menu();
    if (startGame) {
        rl.initWindow(cons.ScreenWidth, cons.ScreenHeight, cons.Title);
        defer rl.closeWindow(); // Close window and OpenGL context

        rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
        //--------------------------------------------------------------------------------------
        const topBorder = rl.Rectangle.init(0, 1, cons.ScreenWidth, 10);
        const bottomBorder = rl.Rectangle.init(0, cons.ScreenHeight - 11, cons.ScreenWidth, 10);
        const leftBorder = rl.Rectangle.init(-10, 0, 10, cons.ScreenHeight);
        const rightBorder = rl.Rectangle.init(cons.ScreenWidth, 0, 10, cons.ScreenHeight);
        var player = rl.Rectangle.init(100 - 5, cons.Origin.y - 30, 10, 60);
        var playerHeightVar: f32 = 0;
        var misunderstoodBot = rl.Rectangle.init(cons.ScreenWidth - 100 - 5, cons.Origin.y - 30, 10, 60);
        var ball = rl.Vector2.init(cons.Origin.x, cons.Origin.y);
        var ballVector = rl.Vector2.init(5, 2.5);
        var playerScore: i32 = 0;
        var botScore: i32 = 0;
        var playerScoreText = try std.fmt.allocPrintZ(allocator, "Player: {d}", .{playerScore});
        var botScoreText = try std.fmt.allocPrintZ(allocator, "Bot: {d}", .{botScore});

        const gameTime: f32 = 60.0;
        var timeLeft: f32 = gameTime;
        var timerText = try std.fmt.allocPrintZ(allocator, "Time: {d:.1}", .{timeLeft});
        var gameOver = false;
        var winnerText: [:0]u8 = undefined;

        // Main game loop
        while (!rl.windowShouldClose()) { // Detect window close button or ESC key
            // Logic
            //----------------------------------------------------------------------------------
            if (!gameOver) {
                timeLeft -= rl.getFrameTime();
                if (timeLeft <= 0) {
                    gameOver = true;
                    if (playerScore > botScore) {
                        winnerText = try std.fmt.allocPrintZ(allocator, "Player Wins!", .{});
                    } else if (botScore > playerScore) {
                        winnerText = try std.fmt.allocPrintZ(allocator, "Bot Wins!", .{});
                    } else {
                        winnerText = try std.fmt.allocPrintZ(allocator, "It's a Tie!", .{});
                    }
                }
                timerText = try std.fmt.allocPrintZ(allocator, "Time: {d:.1}", .{@max(timeLeft, 0)});

                if (rl.isKeyDown(rl.KeyboardKey.key_up)) {
                    playerHeightVar = 10;
                } else if (rl.isKeyDown(rl.KeyboardKey.key_down)) {
                    playerHeightVar = -10;
                } else {
                    playerHeightVar = 0;
                }

                if (rl.checkCollisionCircleRec(ball, 5, player) or rl.checkCollisionCircleRec(ball, 5, misunderstoodBot)) {
                    ballVector.x = -ballVector.x;
                }
                if (rl.checkCollisionCircleRec(ball, 5, topBorder) or rl.checkCollisionCircleRec(ball, 5, bottomBorder)) {
                    ballVector.y = -ballVector.y;
                }
                if (rl.checkCollisionCircleRec(ball, 5, leftBorder)) {
                    botScore += 1;
                    ball = rl.Vector2.init(cons.Origin.x, cons.Origin.y);
                    ballVector.x = 5;
                    botScoreText = try std.fmt.allocPrintZ(allocator, "Bot: {d}", .{botScore});
                }
                if (rl.checkCollisionCircleRec(ball, 5, rightBorder)) {
                    playerScore += 1;
                    ball = rl.Vector2.init(cons.Origin.x, cons.Origin.y);
                    ballVector.x = -5;
                    playerScoreText = try std.fmt.allocPrintZ(allocator, "Player: {d}", .{playerScore});
                }

                // Update
                player.y -= playerHeightVar;
                misunderstoodBot.y = ball.y - 30; // Bot follows the ball
                ball.x -= ballVector.x;
                ball.y -= ballVector.y;

                // Clamp paddles to screen
                player.y = std.math.clamp(player.y, 10, cons.ScreenHeight - 70);
                misunderstoodBot.y = std.math.clamp(misunderstoodBot.y, 10, cons.ScreenHeight - 70);
            }

            //----------------------------------------------------------------------------------
            // Draw
            //----------------------------------------------------------------------------------
            rl.beginDrawing();
            defer rl.endDrawing();
            rl.clearBackground(rl.Color.black);

            // Draw borders
            rl.drawRectangle(0, 0, cons.ScreenWidth, 10, rl.Color.white); // Top border
            rl.drawRectangle(0, cons.ScreenHeight - 10, cons.ScreenWidth, 10, rl.Color.white); // Bottom border
            rl.drawRectangle(0, 0, 10, cons.ScreenHeight, rl.Color.white); // Left border
            rl.drawRectangle(cons.ScreenWidth - 10, 0, 10, cons.ScreenHeight, rl.Color.white); // Right border

            // Draw dotted center line
            const lineSpacing: i32 = 10;
            const lineHeight: i32 = 5;
            var yPos: i32 = 10;
            while (yPos < cons.ScreenHeight - 10) : (yPos += lineSpacing) {
                rl.drawRectangle(@divExact(cons.ScreenWidth, 2) - 2, yPos, 4, lineHeight, rl.Color.gray);
            }

            rl.drawRectangleRec(player, rl.Color.blue);
            rl.drawRectangleRec(misunderstoodBot, rl.Color.red);
            rl.drawCircleV(ball, 5, rl.Color.yellow);

            // Draw scores and timer
            rl.drawText(playerScoreText, 20, 20, 20, rl.Color.blue);
            rl.drawText(botScoreText, cons.ScreenWidth - 120, 20, 20, rl.Color.red);
            rl.drawText(timerText, @divExact(cons.ScreenWidth, 2) - 40, 20, 20, rl.Color.white);

            if (gameOver) {
                rl.drawText(winnerText, @divExact(cons.ScreenWidth, 2) - 50, @divExact(cons.ScreenHeight, 2), 30, rl.Color.green);
            }
            //----------------------------------------------------------------------------------
        }
    }
}
