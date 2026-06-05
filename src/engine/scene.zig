var _update: ?*const fn () void = null;
var _draw: ?*const fn () void = null;

pub fn init(comptime scene: type) void {
    scene.init();

    _update = scene.update;
    _draw = scene.draw;
}

pub fn update() void {
    if (_update) |u| u();
}

pub fn draw() void {
    if (_draw) |d| d();
}
