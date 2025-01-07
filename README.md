# Proc stat

## Install
```
zig fetch --save https://github.com/Mostik/ps/archive/v0.0.1.tar.gz
```
```zig
//build.zig
const ps = b.dependency("ps", .{}).module("ps");

exe.root_module.addImport("ps", ps);

```
```zig
const std = @import("std");
const ps = @import("ps");

pub fn main() !void {
    
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    const stat: ps.ProcStat = try ps.get(allocator, std.os.linux.getpid());

    std.debug.print("PID: {d} Vsize: {d} \n", .{ stat.pid, stat.vsize });

}

```

