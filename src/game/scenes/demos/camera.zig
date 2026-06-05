const rl = @import("raylib");
const engine = @import("engine");
const g = engine.graphics;
const intro = @import("../intro.zig");

const SPEED: f32 = 150.0;
const BORDER_W: i32 = 640;
const BORDER_H: i32 = 360;

var cam_x: f32 = 0.0;
var cam_y: f32 = 0.0;

pub fn init() void {
    cam_x = 0.0;
    cam_y = 0.0;
}

pub fn update() void {
    if (rl.isKeyPressed(.escape)) {
        engine.scene.init(intro);
        return;
    }

    const dt = rl.getFrameTime();

    if (rl.isKeyDown(.left)) cam_x -= SPEED * dt;
    if (rl.isKeyDown(.right)) cam_x += SPEED * dt;
    if (rl.isKeyDown(.up)) cam_y -= SPEED * dt;
    if (rl.isKeyDown(.down)) cam_y += SPEED * dt;
}

pub fn draw() void {
    g.cls(rl.Color.black);
    g.camera(@intFromFloat(cam_x), @intFromFloat(cam_y));

    g.rect(0, 0, BORDER_W, BORDER_H, rl.Color.white, false);

    const msg = "Use the Arrows to move the camera";
    const size: i32 = 16;
    const msg_w = g.measureText(msg, size);
    g.print(msg, @divTrunc(BORDER_W - msg_w, 2), @divTrunc(BORDER_H - size, 2), rl.Color.white, size);

    g.camera(0, 0);
    g.print("ESC: Back", 8, 8, rl.Color.gray, 8);
}
