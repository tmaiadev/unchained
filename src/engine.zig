const rl = @import("raylib");
pub const scene = @import("engine/scene.zig");
pub const graphics = @import("engine/graphics.zig");

pub const WIDTH: u32 = 640;
pub const HEIGHT: u32 = 360;

pub var canvas: rl.RenderTexture2D = undefined;
pub var should_quit: bool = false;

fn draw() void {
    {
        rl.beginTextureMode(canvas);
        defer rl.endTextureMode();
        rl.clearBackground(rl.Color.black);
        scene.draw();
    }

    const w: f32 = @floatFromInt(WIDTH);
    const h: f32 = @floatFromInt(HEIGHT);
    const sw: f32 = @floatFromInt(rl.getScreenWidth());
    const sh: f32 = @floatFromInt(rl.getScreenHeight());
    const scale = @min(sw / w, sh / h);
    const dst = rl.Rectangle{
        .x = (sw - w * scale) / 2.0,
        .y = (sh - h * scale) / 2.0,
        .width = w * scale,
        .height = h * scale,
    };

    {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);
        rl.drawTexturePro(
            canvas.texture,
            .{ .x = 0, .y = 0, .width = w, .height = -h },
            dst,
            .{ .x = 0, .y = 0 },
            0.0,
            rl.Color.white,
        );
    }
}

fn update() void {
    if (rl.isKeyPressed(.f11)) {
        rl.toggleFullscreen();
    }

    scene.update();
}

pub fn init(title: [:0]const u8) !void {
    rl.setConfigFlags(.{ .window_resizable = true });
    rl.initWindow(WIDTH, HEIGHT, title);
    rl.setTargetFPS(60);
    rl.setExitKey(.null);

    defer rl.closeWindow();
    defer rl.unloadRenderTexture(canvas);

    canvas = try rl.loadRenderTexture(WIDTH, HEIGHT);

    while (!rl.windowShouldClose() and !should_quit) {
        update();
        draw();
    }
}
