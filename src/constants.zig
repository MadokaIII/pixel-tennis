const std = @import("std");
const rl = @import("raylib");
pub const ScreenWidth = 720;
pub const ScreenHeight = 480;
pub const Title = "Pixel Tennis";
pub const Origin = rl.Vector2.init(@divExact(ScreenWidth, 2), @divExact(ScreenHeight, 2));
