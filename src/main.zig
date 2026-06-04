const engine = @import("engine");
const intro = @import("./game/scenes/intro.zig");

pub fn main() !void {
    intro.init();
    try engine.init("Unchained", intro.update, intro.draw);
}
