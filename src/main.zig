const rl = @import("raylib");

const virtual_w = 640;
const virtual_h = 360;

pub fn main() !void {
    rl.setConfigFlags(.{ .window_resizable = true });
    rl.initWindow(virtual_w, virtual_h, "Unchained");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    const canvas = try rl.loadRenderTexture(virtual_w, virtual_h);
    defer rl.unloadRenderTexture(canvas);

    while (!rl.windowShouldClose()) {
        if (rl.isKeyPressed(.f11)) {
            rl.toggleFullscreen();
        }

        {
            rl.beginTextureMode(canvas);
            defer rl.endTextureMode();
            rl.clearBackground(rl.Color.black);
        }

        const sw: f32 = @floatFromInt(rl.getScreenWidth());
        const sh: f32 = @floatFromInt(rl.getScreenHeight());
        const scale = @min(sw / virtual_w, sh / virtual_h);
        const dst = rl.Rectangle{
            .x = (sw - virtual_w * scale) / 2.0,
            .y = (sh - virtual_h * scale) / 2.0,
            .width = virtual_w * scale,
            .height = virtual_h * scale,
        };

        {
            rl.beginDrawing();
            defer rl.endDrawing();
            rl.clearBackground(rl.Color.black);
            rl.drawTexturePro(
                canvas.texture,
                .{ .x = 0, .y = 0, .width = virtual_w, .height = -virtual_h },
                dst,
                .{ .x = 0, .y = 0 },
                0.0,
                rl.Color.white,
            );
        }
    }
}
