//! Types for the generated OpenSSL build manifest.
//!
//! The data itself lives in `generated/manifest.zon` and is loaded by
//! `build.zig` at build-script runtime. Keeping the types out of the generated
//! data means the build script never imports a generated Zig file, so
//! `zig build gen` can replace the data without creating a build dependency
//! cycle.

pub const Language = enum { c, assembly, assembly_with_preprocessor };

pub const SourceGroup = struct {
    language: Language,
    defines: []const []const u8,
    src_files: []const []const u8,
    gen_files: []const []const u8,
};

pub const Platform = struct {
    arch: []const u8,
    os: []const u8,
    /// ABIs that share these generated files, for example `gnu` and `musl`.
    abis: []const []const u8,
    generated_dir: []const u8,
    crypto: []const SourceGroup,
    ssl: []const SourceGroup,
};

pub const Manifest = struct {
    include_dirs: []const []const u8,
    platforms: []const Platform,
};
