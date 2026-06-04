const engine = @import("./engine/engine.zig");
const intro = @import("./game/scenes/intro.zig");

pub fn main() !void {
    intro.init();
    try engine.init("Unchained", intro.update, intro.draw);
}
