const engine = @import("engine");
const intro = @import("./game/scenes/intro.zig");

pub fn main() !void {
    engine.scene.init(intro);
    try engine.init("Unchained");
}
