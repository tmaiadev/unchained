const rl = @import("raylib");

pub fn init() void {}

pub fn update() void {}

pub fn draw() void {
    rl.drawText("Hello", 0, 0, 20, rl.Color.white);
}
