const rl = @import("raylib");
const engine = @import("engine");
const g = engine.graphics;
const intro = @import("../intro.zig");

var texture: rl.Texture = undefined;
var angle: f32 = 0.0;
var time: f32 = 0.0;

pub fn init() void {
    texture = g.loadImg("assets/star.png");
    angle = 0.0;
    time = 0.0;
}

pub fn update() void {
    if (rl.isKeyPressed(.escape)) {
        rl.unloadTexture(texture);
        engine.scene.init(intro);
        return;
    }
    const dt = rl.getFrameTime();
    angle += 90.0 * dt;
    time += dt;
}

pub fn draw() void {
    g.cls(rl.Color.black);

    const scale: f32 = 1.0 + 0.35 * @sin(time * 2.0);
    const size: i32 = @intFromFloat(64.0 * scale);
    const cx: i32 = @intCast(engine.WIDTH / 2);
    const cy: i32 = @intCast(engine.HEIGHT / 2);

    g.img(texture, cx, cy, size, size, angle);

    g.print("Image Demo", 8, 8, rl.Color.white, null);
    g.print("ESC: Back", 8, 24, rl.Color.white, 8);
}
