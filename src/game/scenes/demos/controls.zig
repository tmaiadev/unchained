const rl = @import("raylib");
const engine = @import("engine");
const g = engine.graphics;
const intro = @import("../intro.zig");

const W: f32 = 640.0;
const H: f32 = 360.0;
const SIZE: f32 = 16.0;
const SPEED: f32 = 120.0;

var px: f32 = (W - SIZE) / 2.0;
var py: f32 = (H - SIZE) / 2.0;

pub fn init() void {
    px = (W - SIZE) / 2.0;
    py = (H - SIZE) / 2.0;
}

pub fn update() void {
    if (rl.isKeyPressed(.escape)) {
        engine.scene.init(intro);
        return;
    }

    const dt = rl.getFrameTime();

    if (rl.isKeyDown(.left)) px -= SPEED * dt;
    if (rl.isKeyDown(.right)) px += SPEED * dt;
    if (rl.isKeyDown(.up)) py -= SPEED * dt;
    if (rl.isKeyDown(.down)) py += SPEED * dt;

    if (px < 0.0) px = 0.0;
    if (px > W - SIZE) px = W - SIZE;
    if (py < 0.0) py = 0.0;
    if (py > H - SIZE) py = H - SIZE;
}

pub fn draw() void {
    g.cls(rl.Color.black);
    g.rect(@intFromFloat(px), @intFromFloat(py), @intFromFloat(SIZE), @intFromFloat(SIZE), rl.Color.white, true);
    g.print("Arrows: Move   ESC: Back", 8, 8, rl.Color.gray, 8);
}
