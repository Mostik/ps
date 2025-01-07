const std = @import("std");
const ps = @import("root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    while (true) {
        const stat: ps.ProcStat = try ps.get(allocator, std.os.linux.getpid());

        std.debug.print("{d:.2}Mb {d} \n", .{ @as(f32, @floatFromInt(stat.vsize)) / 1024.0 / 1024.0, stat.vsize });

        std.time.sleep(std.time.ns_per_s);
    }
}
