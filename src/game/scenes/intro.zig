const engine = @import("engine");

pub fn init() void {}

pub fn update() void {}

pub fn draw() void {
    engine.graphics.print("Hello, world!", 10, 10, .white);
}
