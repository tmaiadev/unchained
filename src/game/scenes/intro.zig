const rl = @import("raylib");
const bouncingball_scene = @import("./demos/bouncingball.zig");
const platformer_scene = @import("./demos/platformer.zig");
const engine = @import("engine");
const g = engine.graphics;

const items = [_][:0]const u8{ "Bouncing Ball", "Platformer", "Sprites", "Map" };
var selected: usize = 0;

pub fn init() void {}

pub fn update() void {
    if (rl.isKeyPressed(.escape)) {
        engine.should_quit = true;
        return;
    }
    if (rl.isKeyPressed(.up)) {
        selected = if (selected == 0) items.len - 1 else selected - 1;
    }
    if (rl.isKeyPressed(.down)) {
        selected = if (selected == items.len - 1) 0 else selected + 1;
    }
    if (rl.isKeyPressed(.enter)) {
        if (selected == 0) {
            engine.scene.init(bouncingball_scene);
        } else if (selected == 1) {
            engine.scene.init(platformer_scene);
        }
    }
}

pub fn draw() void {
    const title = "Welcome";
    const title_size: i32 = 32;
    const title_w = g.measureText(title, title_size);
    const title_x = @divTrunc(@as(i32, 640) - title_w, 2);
    g.print(title, title_x, 90, .white, title_size);

    g.print("Scenarios:", 220, 165, .white, null);

    const cursor_x: i32 = 220;
    const item_x: i32 = 238;
    const item_y_start: i32 = 190;
    const line_height: i32 = 22;

    for (items, 0..) |item, i| {
        const y = item_y_start + @as(i32, @intCast(i)) * line_height;
        const color: rl.Color = if (i == selected) rl.Color.white else rl.Color.gray;
        if (i == selected) {
            g.print(">", cursor_x, y, .white, null);
        }
        g.print(item, item_x, y, color, null);
    }
}
