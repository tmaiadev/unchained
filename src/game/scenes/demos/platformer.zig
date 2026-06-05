const rl = @import("raylib");
const std = @import("std");
const engine = @import("engine");
const g = engine.graphics;
const intro = @import("../intro.zig");

const TILE: i32 = 16;
const WORLD_W: f32 = 1280.0;
const GROUND_Y: i32 = 296; // engine.HEIGHT (360) - 64 (ground height)
const PS: i32 = TILE;
const SPEED: f32 = 140.0;
const JUMP_VEL: f32 = -280.0;
const GRAVITY: f32 = 650.0;

const Rect = struct { x: i32, y: i32, w: i32, h: i32 };

const obstacles = [_]Rect{
    .{ .x = 300, .y = 248, .w = 32, .h = 48 }, // wall pillar, 3 tiles tall (jump over)
    .{ .x = 600, .y = 264, .w = 80, .h = 16 }, // platform, 2 tiles above ground (jump onto)
    .{ .x = 900, .y = 264, .w = 32, .h = 32 }, // shorter wall, 2 tiles tall
    .{ .x = 1050, .y = 248, .w = 64, .h = 16 }, // high platform, 3 tiles above ground
};

var px: f32 = 32.0;
var py: f32 = 280.0;
var vx: f32 = 0.0;
var vy: f32 = 0.0;
var on_ground: bool = false;
var facing_right: bool = true;
var cam_x: f32 = 0.0;

pub fn init() void {
    px = 32.0;
    py = 280.0;
    vx = 0.0;
    vy = 0.0;
    on_ground = false;
    facing_right = true;
    cam_x = 0.0;
}

fn overlaps(ax: f32, ay: f32, obs: Rect) bool {
    const ox: f32 = @floatFromInt(obs.x);
    const oy: f32 = @floatFromInt(obs.y);
    const ow: f32 = @floatFromInt(obs.w);
    const oh: f32 = @floatFromInt(obs.h);
    const pf: f32 = @floatFromInt(PS);
    return ax < ox + ow and ax + pf > ox and ay < oy + oh and ay + pf > oy;
}

pub fn update() void {
    if (rl.isKeyPressed(.escape)) {
        engine.scene.init(intro);
        return;
    }

    const dt = rl.getFrameTime();
    const pf: f32 = @floatFromInt(PS);
    const gy: f32 = @floatFromInt(GROUND_Y);
    const sw: f32 = @floatFromInt(engine.WIDTH);

    // Input
    vx = 0.0;
    if (rl.isKeyDown(.left)) {
        vx = -SPEED;
        facing_right = false;
    }
    if (rl.isKeyDown(.right)) {
        vx = SPEED;
        facing_right = true;
    }
    if (rl.isKeyPressed(.x) and on_ground) {
        vy = JUMP_VEL;
        on_ground = false;
    }

    // Horizontal movement + collision
    px += vx * dt;
    if (px < 0.0) px = 0.0;
    if (px + pf > WORLD_W) px = WORLD_W - pf;
    for (obstacles) |obs| {
        if (overlaps(px, py, obs)) {
            const ox: f32 = @floatFromInt(obs.x);
            const ow: f32 = @floatFromInt(obs.w);
            if (vx > 0.0) {
                px = ox - pf;
            } else if (vx < 0.0) {
                px = ox + ow;
            } else {
                if ((px + pf) - ox < (ox + ow) - px) {
                    px = ox - pf;
                } else {
                    px = ox + ow;
                }
            }
        }
    }

    // Vertical movement + collision
    vy += GRAVITY * dt;
    py += vy * dt;
    on_ground = false;
    for (obstacles) |obs| {
        if (overlaps(px, py, obs)) {
            const oy: f32 = @floatFromInt(obs.y);
            const oh: f32 = @floatFromInt(obs.h);
            if (vy >= 0.0) {
                py = oy - pf;
                vy = 0.0;
                on_ground = true;
            } else {
                py = oy + oh;
                vy = 0.0;
            }
        }
    }
    if (py + pf >= gy) {
        py = gy - pf;
        vy = 0.0;
        on_ground = true;
    }

    // Look-ahead camera: player at 1/3 screen when facing right, 2/3 when facing left
    const look: f32 = if (facing_right) sw / 3.0 else sw * 2.0 / 3.0;
    var target = px + pf / 2.0 - look;
    if (target < 0.0) target = 0.0;
    if (target > WORLD_W - sw) target = WORLD_W - sw;
    cam_x += (target - cam_x) * 6.0 * dt;
}

pub fn draw() void {
    g.cls(rl.Color.black);
    g.camera(@intFromFloat(cam_x), 0);

    // Ground
    g.rect(0, GROUND_Y, 1280, 64, rl.Color.white, true);

    // Obstacles
    for (obstacles) |obs| {
        g.rect(obs.x, obs.y, obs.w, obs.h, rl.Color.white, true);
    }

    // Player (outline so it stays visible against white obstacles)
    g.rect(@intFromFloat(px), @intFromFloat(py), PS, PS, rl.Color.white, true);

    // HUD (screen-space)
    g.camera(0, 0);
    g.print("X: Jump", 8, 8, rl.Color.white, 8);
    g.print("Arrows: Run", 8, 24, rl.Color.white, 8);

    var fps_buf: [16:0]u8 = undefined;
    const fps_text = std.fmt.bufPrintZ(&fps_buf, "{d} FPS", .{rl.getFPS()}) catch "?";
    const fps_w = g.measureText(fps_text, 8);
    const sw: i32 = @intCast(engine.WIDTH);
    g.print(fps_text, sw - fps_w - 8, 8, rl.Color.white, 8);
}
