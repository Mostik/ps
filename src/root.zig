const std = @import("std");

pub const ProcStat = struct {
    pid: i32,
    comm: []const u8,
    state: []const u8,
    ppid: i32, //parent pid
    pgrp: i32, //process group id
    session: i32,
    tty_nr: i32,
    tpgid: i32,
    flags: u32,
    minflt: u64,
    cminflt: u64,
    majflt: u64,
    cmajflt: u64,
    utime: u64,
    stime: u64,
    cutime: u64,
    cstime: u64,
    priority: i64,
    nice: i64,
    num_threads: i64,
    itrealvalue: i64,
    starttime: u64,
    vsize: u64, // in bytes
    rss: i64,
    rsslim: u64,
    startcode: u64,
    endcode: u64,
    startstack: u64,
    kstkesp: u64,
    kstkeip: u64,
    signal: u64,
    blocked: u64,
    sigignore: u64,
    sigcatch: u64,
    wchan: u64,
    nspaw: u64,
    cnswap: u64,
    exit_signal: i32,
    processor: i32,
    rt_priority: u32,
    policy: u32,
    delayacct_blkio_ticks: i64,
    guest_time: u64,
    cguest_time: i64,
    start_data: u64,
    end_data: u64,
    start_brk: u64,
    arg_start: u64,
    arg_end: u64,
    env_start: u64,
    env_end: u64,
    exit_code: i32,
};

pub fn current(allocator: std.mem.Allocator) !void {
    return try get(allocator, std.os.linux.getpid());
}

pub fn get(allocator: std.mem.Allocator, pid: i32) !ProcStat {
    const path = try std.fmt.allocPrint(allocator, "/proc/{d}/stat", .{pid});

    defer allocator.free(path);

    const file = try std.fs.openFileAbsolute(path, .{});

    const raw_stat: []u8 = try file.reader().readAllAlloc(allocator, 1000);

    defer allocator.free(raw_stat);

    var iter = std.mem.splitAny(u8, trim(raw_stat), " ");

    var stat: ProcStat = undefined;

    var i: usize = 0;
    while (iter.next()) |val| {
        switch (i) {
            0 => stat.pid = try std.fmt.parseInt(i32, val, 10),
            1 => stat.comm = val,
            2 => stat.state = val,
            3 => stat.ppid = try std.fmt.parseInt(i32, val, 10),
            4 => stat.pgrp = try std.fmt.parseInt(i32, val, 10),
            5 => stat.session = try std.fmt.parseInt(i32, val, 10),
            6 => stat.tty_nr = try std.fmt.parseInt(i32, val, 10),
            7 => stat.tpgid = try std.fmt.parseInt(i32, val, 10),
            8 => stat.flags = try std.fmt.parseInt(u32, val, 10),
            9 => stat.minflt = try std.fmt.parseInt(u64, val, 10),
            10 => stat.cminflt = try std.fmt.parseInt(u64, val, 10),
            11 => stat.majflt = try std.fmt.parseInt(u64, val, 10),
            12 => stat.cmajflt = try std.fmt.parseInt(u64, val, 10),
            13 => stat.utime = try std.fmt.parseInt(u64, val, 10),
            14 => stat.stime = try std.fmt.parseInt(u64, val, 10),
            15 => stat.cutime = try std.fmt.parseInt(u64, val, 10),
            16 => stat.cstime = try std.fmt.parseInt(u64, val, 10),
            17 => stat.priority = try std.fmt.parseInt(i64, val, 10),
            18 => stat.nice = try std.fmt.parseInt(i64, val, 10),
            19 => stat.num_threads = try std.fmt.parseInt(i64, val, 10),
            20 => stat.itrealvalue = try std.fmt.parseInt(i64, val, 10),
            21 => stat.starttime = try std.fmt.parseInt(u64, val, 10),
            22 => stat.vsize = try std.fmt.parseInt(u64, val, 10),
            23 => stat.rss = try std.fmt.parseInt(i64, val, 10),
            24 => stat.rsslim = try std.fmt.parseInt(u64, val, 10),
            25 => stat.startcode = try std.fmt.parseInt(u64, val, 10),
            26 => stat.endcode = try std.fmt.parseInt(u64, val, 10),
            27 => stat.startstack = try std.fmt.parseInt(u64, val, 10),
            28 => stat.kstkesp = try std.fmt.parseInt(u64, val, 10),
            29 => stat.kstkeip = try std.fmt.parseInt(u64, val, 10),
            30 => stat.signal = try std.fmt.parseInt(u64, val, 10),
            31 => stat.blocked = try std.fmt.parseInt(u64, val, 10),
            32 => stat.sigignore = try std.fmt.parseInt(u64, val, 10),
            33 => stat.sigcatch = try std.fmt.parseInt(u64, val, 10),
            34 => stat.wchan = try std.fmt.parseInt(u64, val, 10),
            35 => stat.nspaw = try std.fmt.parseInt(u64, val, 10),
            36 => stat.cnswap = try std.fmt.parseInt(u64, val, 10),
            37 => stat.exit_signal = try std.fmt.parseInt(i32, val, 10),
            38 => stat.processor = try std.fmt.parseInt(i32, val, 10),
            39 => stat.rt_priority = try std.fmt.parseInt(u32, val, 10),
            40 => stat.policy = try std.fmt.parseInt(u32, val, 10),
            41 => stat.delayacct_blkio_ticks = try std.fmt.parseInt(i64, val, 10),
            42 => stat.guest_time = try std.fmt.parseInt(u64, val, 10),
            43 => stat.cguest_time = try std.fmt.parseInt(i64, val, 10),
            44 => stat.start_data = try std.fmt.parseInt(u64, val, 10),
            45 => stat.end_data = try std.fmt.parseInt(u64, val, 10),
            46 => stat.start_brk = try std.fmt.parseInt(u64, val, 10),
            47 => stat.arg_start = try std.fmt.parseInt(u64, val, 10),
            48 => stat.arg_end = try std.fmt.parseInt(u64, val, 10),
            49 => stat.env_start = try std.fmt.parseInt(u64, val, 10),
            50 => stat.env_end = try std.fmt.parseInt(u64, val, 10),
            51 => stat.exit_code = try std.fmt.parseInt(i32, val, 10),
            else => {},
        }

        i += 1;
    }

    return stat;
}

pub fn trim(str: []const u8) []const u8 {
    var last: usize = l: {
        if (str.len - 1 > 0) {
            break :l str.len - 1;
        } else {
            break :l 0;
        }
    };

    for (str, 0..) |val, i| {
        if (val == 10) {
            last = i;

            return str[0..last];
        }
    }

    return str[0..last];
}
