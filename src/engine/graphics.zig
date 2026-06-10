const std = @import("std");
const rl = @import("raylib");

var cam_x: i32 = 0;
var cam_y: i32 = 0;

pub fn cls(color: rl.Color) void {
    rl.clearBackground(color);
}

pub fn print(text: [:0]const u8, x: i32, y: i32, color: rl.Color, size: ?i32) void {
    rl.drawText(text, x - cam_x, y - cam_y, size orelse 16, color);
}

pub fn measureText(text: [:0]const u8, size: i32) i32 {
    return rl.measureText(text, size);
}

pub fn rect(x: i32, y: i32, w: i32, h: i32, color: rl.Color, fill: bool) void {
    if (fill) {
        rl.drawRectangle(x - cam_x, y - cam_y, w, h, color);
    } else {
        rl.drawRectangleLines(x - cam_x, y - cam_y, w, h, color);
    }
}

pub fn circ(x: i32, y: i32, r: i32, color: rl.Color, fill: bool) void {
    const radius: f32 = @floatFromInt(r);
    if (fill) {
        rl.drawCircle(x - cam_x, y - cam_y, radius, color);
    } else {
        rl.drawCircleLines(x - cam_x, y - cam_y, radius, color);
    }
}

pub fn line(x1: i32, y1: i32, x2: i32, y2: i32, color: rl.Color) void {
    rl.drawLine(x1 - cam_x, y1 - cam_y, x2 - cam_x, y2 - cam_y, color);
}

pub fn camera(x: i32, y: i32) void {
    cam_x = x;
    cam_y = y;
}

pub fn loadImg(comptime path: [:0]const u8) rl.Texture {
    const dot = comptime (std.mem.lastIndexOfScalar(u8, path, '.') orelse
        @compileError("loadImg: path must include a file extension, e.g. \"assets/star.png\""));
    const ext: [:0]const u8 = path[dot..];
    const data = @embedFile("../" ++ path);
    const image = rl.loadImageFromMemory(ext, data) catch @panic("loadImg: failed to decode image");
    defer rl.unloadImage(image);
    return rl.loadTextureFromImage(image) catch @panic("loadImg: failed to create texture");
}

pub fn img(texture: rl.Texture, x: i32, y: i32, w: ?i32, h: ?i32, r: ?f32) void {
    const width = w orelse texture.width;
    const height = h orelse texture.height;
    const rotation = r orelse 0.0;
    const src = rl.Rectangle{
        .x = 0,
        .y = 0,
        .width = @floatFromInt(texture.width),
        .height = @floatFromInt(texture.height),
    };
    const dst = rl.Rectangle{
        .x = @floatFromInt(x - cam_x),
        .y = @floatFromInt(y - cam_y),
        .width = @floatFromInt(width),
        .height = @floatFromInt(height),
    };
    const origin = rl.Vector2{
        .x = @as(f32, @floatFromInt(width)) / 2.0,
        .y = @as(f32, @floatFromInt(height)) / 2.0,
    };
    rl.drawTexturePro(texture, src, dst, origin, rotation, rl.Color.white);
}
