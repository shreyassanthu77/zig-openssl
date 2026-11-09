const std = @import("std");
const manifest = @import("manifest.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("openssl", .{});

    // `zig build gen` regenerates the checked-in configuration headers,
    // generated C sources and perlasm assembly. It needs Perl and make, but
    // the resulting files are committed, so a normal build only needs Zig.
    const gen_step = b.step("gen", "Regenerate the checked-in OpenSSL sources");
    const gen_cmd = b.addSystemCommand(&.{"perl"});
    gen_cmd.addFileArg(b.path("scripts/gen.pl"));
    gen_cmd.addDirectoryArg(upstream.path(""));
    gen_cmd.addArg("generated");
    const manifest_out = gen_cmd.addOutputFileArg2("manifest.zon", .{});
    const update_manifest = b.addUpdateSourceFiles();
    update_manifest.addCopyFileToSource(manifest_out, "generated/manifest.zon");
    gen_step.dependOn(&update_manifest.step);

    // The manifest is read at build-script runtime rather than imported, so
    // regenerating it never invalidates the build script itself. When it is
    // usable, declare it as a configure dependency so `zig build gen` changes
    // are picked up on the next invocation. When it is missing or invalid,
    // poison the configuration cache so the next invocation re-runs configure
    // instead of reusing a failing configuration; this is what lets
    // `zig build gen` create the manifest in the first place.
    const manifest_path = b.path("generated/manifest.zon");
    const data = loadManifest(b) orelse {
        b.graph.poisonCache();
        failInstall(b, "generated/manifest.zon is missing or invalid; run `zig build gen`");
        return;
    };
    b.dependOnFileContents(manifest_path);

    const platform = findPlatform(data, target.result) orelse {
        failInstall(b, b.fmt("OpenSSL generated sources do not support target {t}-{t}-{t}", .{
            target.result.cpu.arch,
            target.result.os.tag,
            target.result.abi,
        }));
        return;
    };

    buildLibraries(b, upstream, target, optimize, data, platform);
}

fn buildLibraries(
    b: *std.Build,
    upstream: *std.Build.Dependency,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize,
    data: manifest.Manifest,
    platform: *const manifest.Platform,
) void {
    const gen_dir = b.path(platform.generated_dir);
    const is_windows = target.result.os.tag == .windows;
    const pic: ?bool = if (is_windows) null else true;
    // Zig's clang defaults to IEEE 128-bit long double on powerpc64le, which
    // makes libc calls reference glibc's "__*ieee128" aliases (only available
    // since glibc 2.32). OpenSSL does not use long double, so use the
    // traditional IBM double-double ABI for maximum compatibility.
    const extra_flags: []const []const u8 = if (target.result.cpu.arch == .powerpc64le)
        &.{"-mabi=ibmlongdouble"}
    else
        &.{};

    const libcrypto_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .pic = pic,
    });
    const libssl_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .pic = pic,
    });

    addIncludeDirs(b, libcrypto_mod, upstream, gen_dir, data.include_dirs);
    addIncludeDirs(b, libssl_mod, upstream, gen_dir, data.include_dirs);

    addSourceGroups(libcrypto_mod, upstream, gen_dir, platform.crypto, extra_flags);
    addSourceGroups(libssl_mod, upstream, gen_dir, platform.ssl, extra_flags);

    const libcrypto = b.addLibrary(.{
        .name = "crypto",
        .linkage = .static,
        .root_module = libcrypto_mod,
    });
    const libssl = b.addLibrary(.{
        .name = "ssl",
        .linkage = .static,
        .root_module = libssl_mod,
    });

    // The public headers are split between the upstream source tree and the
    // generated configuration headers.
    libcrypto.installHeadersDirectory(upstream.path("include"), "", .{});
    libcrypto.installHeadersDirectory(gen_dir.path(b, "include"), "", .{});

    b.installArtifact(libcrypto);
    b.installArtifact(libssl);
}

fn addIncludeDirs(
    b: *std.Build,
    mod: *std.Build.Module,
    upstream: *std.Build.Dependency,
    gen_dir: std.Build.LazyPath,
    include_dirs: []const []const u8,
) void {
    // A generated directory shadows the matching directory in the source tree
    // (for example include/openssl/configuration.h lives only in the generated
    // tree, while the rest of include/openssl is upstream).
    for (include_dirs) |dir| {
        mod.addIncludePath(gen_dir.path(b, dir));
        mod.addIncludePath(upstream.path(dir));
    }
}

fn addSourceGroups(
    mod: *std.Build.Module,
    upstream: *std.Build.Dependency,
    gen_dir: std.Build.LazyPath,
    groups: []const manifest.SourceGroup,
    extra_flags: []const []const u8,
) void {
    for (groups) |group| {
        const language: std.Build.Module.CSourceLanguage = switch (group.language) {
            .c => .c,
            .assembly => .assembly,
            .assembly_with_preprocessor => .assembly_with_preprocessor,
        };

        const flags = if (group.language == .c)
            appendFlags(mod.owner, group.defines, extra_flags)
        else
            group.defines;

        if (group.src_files.len != 0) {
            mod.addCSourceFiles(.{
                .root = upstream.path(""),
                .files = group.src_files,
                .flags = flags,
                .language = language,
            });
        }
        if (group.gen_files.len != 0) {
            mod.addCSourceFiles(.{
                .root = gen_dir,
                .files = group.gen_files,
                .flags = flags,
                .language = language,
            });
        }
    }
}

fn appendFlags(
    b: *std.Build,
    base: []const []const u8,
    extra: []const []const u8,
) []const []const u8 {
    if (extra.len == 0) return base;
    const out = b.allocator.alloc([]const u8, base.len + extra.len) catch @panic("OOM");
    @memcpy(out[0..base.len], base);
    @memcpy(out[base.len..], extra);
    return out;
}

fn loadManifest(b: *std.Build) ?manifest.Manifest {
    const io = b.graph.io;
    const file = b.root.openFile(io, "generated/manifest.zon", .{}) catch |err| {
        std.log.err("failed to open generated/manifest.zon: {s}", .{@errorName(err)});
        return null;
    };
    defer file.close(io);

    var file_reader = file.reader(io, &.{});
    const source = file_reader.interface.allocRemainingAlignedSentinel(
        b.allocator,
        .unlimited,
        .of(u8),
        0,
    ) catch |err| {
        std.log.err("failed to read generated/manifest.zon: {s}", .{@errorName(err)});
        return null;
    };

    var diagnostics: std.zon.parse.Diagnostics = undefined;
    return std.zon.parse.fromSlice(manifest.Manifest, .{
        .gpa = b.allocator,
        .arena = b.graph.arena,
        .source = source,
        .diagnostics = &diagnostics,
    }) catch |err| switch (err) {
        error.OutOfMemory => @panic("out of memory"),
        error.ParseZon => {
            diagnostics.log("generated/manifest.zon");
            return null;
        },
    };
}

fn findPlatform(data: manifest.Manifest, target: std.Target) ?*const manifest.Platform {
    const arch = @tagName(target.cpu.arch);
    const os = @tagName(target.os.tag);
    const abi = @tagName(target.abi);

    for (data.platforms) |*platform| {
        if (!std.mem.eql(u8, platform.arch, arch)) continue;
        if (!std.mem.eql(u8, platform.os, os)) continue;
        for (platform.abis) |candidate| {
            if (std.mem.eql(u8, candidate, abi)) return platform;
        }
    }
    return null;
}

fn failInstall(b: *std.Build, message: []const u8) void {
    b.getInstallStep().dependOn(&b.addFail(message).step);
}
