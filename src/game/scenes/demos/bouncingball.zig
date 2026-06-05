const rl = @import("raylib");
const engine = @import("engine");
const intro = @import("../intro.zig");

const RADIUS: f32 = 12.0;
const SPEED: f32 = 180.0;

var pos_x: f32 = 80.0;
var pos_y: f32 = 80.0;
var vel_x: f32 = SPEED;
var vel_y: f32 = SPEED;

pub fn init() void {
    pos_x = 80.0;
    pos_y = 80.0;
    vel_x = SPEED;
    vel_y = SPEED;
}

pub fn update() void {
    if (rl.isKeyPressed(.escape)) {
        engine.scene.init(intro);
        return;
    }

    const dt = rl.getFrameTime();
    const w: f32 = @floatFromInt(engine.WIDTH);
    const h: f32 = @floatFromInt(engine.HEIGHT);

    pos_x += vel_x * dt;
    pos_y += vel_y * dt;

    if (pos_x - RADIUS <= 0.0) {
        pos_x = RADIUS;
        vel_x = @abs(vel_x);
    } else if (pos_x + RADIUS >= w) {
        pos_x = w - RADIUS;
        vel_x = -@abs(vel_x);
    }

    if (pos_y - RADIUS <= 0.0) {
        pos_y = RADIUS;
        vel_y = @abs(vel_y);
    } else if (pos_y + RADIUS >= h) {
        pos_y = h - RADIUS;
        vel_y = -@abs(vel_y);
    }
}

pub fn draw() void {
    rl.drawCircle(@intFromFloat(pos_x), @intFromFloat(pos_y), RADIUS, rl.Color.white);
}
