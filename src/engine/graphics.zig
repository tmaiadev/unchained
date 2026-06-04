const rl = @import("raylib");
pub const graphics = @import("graphics.zig");

var cam_x: i32 = 0;
var cam_y: i32 = 0;

pub fn cls(color: rl.Color) void {
    rl.clearBackground(color);
}

pub fn print(text: [:0]const u8, x: i32, y: i32, color: rl.Color) void {
    rl.drawText(text, x - cam_x, y - cam_y, 8, color);
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
