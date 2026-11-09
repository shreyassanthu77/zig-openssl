# zig-openssl

A dependency-free Zig build of OpenSSL 4.1.0's `libcrypto` and `libssl`.

The normal build does **not** run `Configure`, `make`, or Perl. Every file that
OpenSSL normally generates (configuration headers, generated C sources and
perlasm assembly) is checked into [`generated/`](generated) by the `gen` step.

## Building

```sh
zig build
```

This builds static libraries for the native target. Use the standard Zig
options to select another target or optimization mode:

```sh
zig build -Dtarget=x86_64-linux-gnu
zig build -Dtarget=aarch64-linux-musl -Doptimize=fast
```

Supported targets:

| Target | Artifacts |
| --- | --- |
| `x86_64-linux-gnu` | `libcrypto.a`, `libssl.a` |
| `aarch64-linux-gnu` | `libcrypto.a`, `libssl.a` |
| `riscv64-linux-gnu` | `libcrypto.a`, `libssl.a` |
| `powerpc64le-linux-gnu` | `libcrypto.a`, `libssl.a` |
| `s390x-linux-gnu` | `libcrypto.a`, `libssl.a` |
| `x86_64-linux-musl` | `libcrypto.a`, `libssl.a` |
| `aarch64-linux-musl` | `libcrypto.a`, `libssl.a` |
| `riscv64-linux-musl` | `libcrypto.a`, `libssl.a` |
| `powerpc64le-linux-musl` | `libcrypto.a`, `libssl.a` |
| `s390x-linux-musl` | `libcrypto.a`, `libssl.a` |
| `aarch64-macos` | `libcrypto.a`, `libssl.a` |
| `x86_64-macos` | `libcrypto.a`, `libssl.a` |
| `x86_64-windows-gnu` | `crypto.lib`, `ssl.lib` |

Artifacts are installed using the normal Zig layout:

```text
zig-out/lib/libcrypto.a
zig-out/lib/libssl.a
zig-out/include/openssl/...
```

Only one target/optimization pair is built at a time, matching Zig's standard
build behavior.

When linking the Windows archives, add the Windows system libraries OpenSSL
uses:

```text
-lws2_32 -lcrypt32 -luserenv -ladvapi32 -lgdi32 -lbcrypt
```

On `powerpc64le`, OpenSSL is compiled with `-mabi=ibmlongdouble` so it does not
depend on the glibc 2.32+ IEEE 128-bit long-double aliases. Link consumers with
the same flag.

## Regenerating checked-in files

`gen` is the only step that needs Perl and `make`. It configures OpenSSL for
each platform, generates the configuration headers/assembly with the OpenSSL
perlasm scripts, and updates:

- [`generated/`](generated): generated headers, C sources and assembly.
- [`generated/manifest.zon`](generated/manifest.zon): the source lists and
  compiler defines for each supported platform.

```sh
zig build gen
```

The manifest types live in [`manifest.zig`](manifest.zig), which is checked in
and imported by `build.zig`. The data is loaded from `generated/manifest.zon`
at build-script runtime, so regenerating the manifest never creates a build
dependency cycle.

OpenSSL itself is a Zig package dependency (see `build.zig.zon`), so the
generator gets the exact pinned upstream sources.
