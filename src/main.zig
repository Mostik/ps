const std = @import("std");
const ps = @import("root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    const dir = try std.fs.openDirAbsolute("/proc", .{ .iterate = true });

    var it = dir.iterate();

    while (true) {
        while (try it.next()) |entity| {
            if (std.fmt.parseInt(i32, entity.name, 10)) |value| {
                var stat: ps.ProcStat = try ps.ProcStat.get(allocator, value);
                defer stat.deinit();

                std.debug.print("{s} - ", .{stat.comm});
                std.debug.print("{d}\n", .{stat.vsize / 1000 / 1000});
            } else |_| {}
        }

        it.reset();

        std.time.sleep(1);
    }
}
