#!/usr/bin/env perl
# Generate the configuration headers, generated C sources and perlasm
# assembly that OpenSSL normally produces during `Configure` / `make`.
#
# The output is checked into the repository so that `zig build` only needs
# Zig and the upstream OpenSSL sources -- no Perl, no make, no Configure.
#
# Usage: perl scripts/gen.pl <openssl-source-dir> [output-dir] [manifest.zon] [manifest.txt]
#
# The generated platform trees are written under <output-dir> (default:
# "generated"), the Zig build manifest is written to <manifest.zon> (default:
# "<output-dir>/manifest.zon"), and the plain-text manifest for non-Zig build
# systems is written to <manifest.txt> (default: "<output-dir>/manifest.txt").

use strict;
use warnings;

use Cwd qw(abs_path getcwd);
use File::Basename qw(dirname);
use File::Copy qw(copy);
use File::Find ();
use File::Path qw(make_path remove_tree);
use File::Spec;
use File::Temp qw(tempdir);
use Text::ParseWords qw(shellwords);

my $root    = abs_path(File::Spec->catdir(dirname(abs_path($0)), '..'));
my $srcdir  = abs_path($ARGV[0] // die "usage: $0 <openssl-source-dir> [output-dir] [manifest.zon]\n");
my $outdir  = File::Spec->rel2abs($ARGV[1] // File::Spec->catdir($root, 'generated'), $root);
my $manifest = File::Spec->rel2abs(
    $ARGV[2] // File::Spec->catfile($outdir, 'manifest.zon'),
    $root,
);
my $manifest_txt = File::Spec->rel2abs(
    $ARGV[3] // File::Spec->catfile($outdir, 'manifest.txt'),
    $root,
);

# Every line is: <name> <Configure target> <zig triple> <generator key>
#
# The generator key groups targets that share the exact same generated files.
# The musl targets reuse the glibc-generated files: OpenSSL's platform
# configuration is the same, only the libc ABI of the final Zig target differs.
my @targets = (
    [ 'x86_64-linux-gnu',       'linux-x86_64',     'x86_64-linux-gnu',       'linux-x86_64' ],
    [ 'aarch64-linux-gnu',      'linux-aarch64',    'aarch64-linux-gnu',      'linux-aarch64' ],
    [ 'riscv64-linux-gnu',      'linux64-riscv64',  'riscv64-linux-gnu',      'linux64-riscv64' ],
    [ 'powerpc64le-linux-gnu',  'linux-ppc64le',    'powerpc64le-linux-gnu',  'linux-ppc64le' ],
    [ 's390x-linux-gnu',        'linux64-s390x',    's390x-linux-gnu',        'linux64-s390x' ],
    [ 'x86_64-linux-musl',      'linux-x86_64',     'x86_64-linux-musl',      'linux-x86_64' ],
    [ 'aarch64-linux-musl',     'linux-aarch64',    'aarch64-linux-musl',     'linux-aarch64' ],
    [ 'riscv64-linux-musl',     'linux64-riscv64',  'riscv64-linux-musl',     'linux64-riscv64' ],
    [ 'powerpc64le-linux-musl', 'linux-ppc64le',    'powerpc64le-linux-musl', 'linux-ppc64le' ],
    [ 's390x-linux-musl',       'linux64-s390x',    's390x-linux-musl',       'linux64-s390x' ],
    [ 'aarch64-macos',          'darwin64-arm64',   'aarch64-macos',          'darwin64-arm64' ],
    [ 'x86_64-macos',           'darwin64-x86_64',  'x86_64-macos',           'darwin64-x86_64' ],
    [ 'x86_64-windows-gnu',     'mingw64',          'x86_64-windows-gnu',     'mingw64' ],
);

my %generators;
for my $target (@targets) {
    my ($name, $config, $triple, $key) = @$target;
    my ($arch, $os, $abi) = split(/-/, $triple, 3);
    $abi //= 'none';
    my $gen = $generators{$key} //= {
        config  => $config,
        triple  => $triple,
        arch    => $arch,
        os      => $os,
        abis    => {},
        triples => [],
    };
    $gen->{abis}{$abi} = 1;
    push @{$gen->{triples}}, $triple;
}

my $zig = $ENV{ZIG} // `which zig`;
chomp $zig;
die "gen: could not find zig in PATH\n" unless $zig && -x $zig;
$zig = abs_path($zig);

make_path($outdir);

my %generated_by_key;

for my $key (sort keys %generators) {
    my $gen = $generators{$key};
    print "==> $key (Configure target: $gen->{config}, triple: $gen->{triple})\n";

    my $work = tempdir("zig-openssl-$key-XXXXXX", TMPDIR => 1, CLEANUP => 1);
    # OpenSSL 4.1's out-of-tree configuration writes apps/include/configuration.h
    # without creating apps/include first.
    make_path(File::Spec->catdir($work, 'apps', 'include'));

    my $shimdir = File::Spec->catdir($work, '.shim');
    make_path($shimdir);
    write_shim(File::Spec->catfile($shimdir, 'zig'), $zig);

    configure($work, $gen->{config}, $gen->{triple});
    my $commands = dry_run($work);
    my $groups = parse_commands($commands, $work);

    generate($work, $shimdir);

    my $dest = File::Spec->catdir($outdir, $key);
    remove_tree($dest);
    make_path($dest);
    my $copied = copy_generated($work, $dest);
    print "    generated $copied files\n";

    $generated_by_key{$key} = {
        groups => $groups,
    };
}

write_manifest_zon($manifest, \%generated_by_key, \%generators);
write_manifest_txt($manifest_txt, \%generated_by_key, \%generators);

# Older versions wrote the types and data into a generated Zig file. Remove it
# so the checked-in tree does not end up with two manifests.
my $legacy = File::Spec->catfile($outdir, 'manifest.zig');
unlink $legacy if -e $legacy;

sub configure {
    my ($work, $config, $triple) = @_;
    my @cmd = (
        $^X, File::Spec->catfile($srcdir, 'Configure'),
        $config,
        'no-shared', 'no-tests', 'no-apps', 'no-docs', 'no-demos',
    );
    local $ENV{CC} = "zig cc -target $triple";
    local $ENV{SOURCE_DATE_EPOCH} = '0';
    my $cwd = getcwd();
    chdir($work) or die "gen: cannot chdir to $work: $!\n";
    my $ok = run_logged($work, 'configure.log', @cmd);
    chdir($cwd) or die "gen: cannot chdir back to $cwd: $!\n";
    die "gen: Configure failed for $config\n" unless $ok;
}

sub dry_run {
    my ($work) = @_;
    my $cwd = getcwd();
    chdir($work) or die "gen: cannot chdir to $work: $!\n";
    open(my $fh, '-|', 'make', '-n', 'build_libs')
        or die "gen: cannot run make -n: $!\n";
    local $/;
    my $output = <$fh>;
    close($fh) or die "gen: make -n failed\n";
    chdir($cwd) or die "gen: cannot chdir back to $cwd: $!\n";
    return $output;
}

sub generate {
    my ($work, $shimdir) = @_;
    my $jobs = `nproc` // 4;
    chomp $jobs;
    $jobs = 4 unless $jobs =~ /^\d+$/;
    my $cwd = getcwd();
    chdir($work) or die "gen: cannot chdir to $work: $!\n";
    local $ENV{PATH} = "$shimdir:$ENV{PATH}";
    local $ENV{SOURCE_DATE_EPOCH} = '0';
    my $ok = run_logged($work, 'make.log', 'make', "-j$jobs", 'build_libs');
    chdir($cwd) or die "gen: cannot chdir back to $cwd: $!\n";
    die "gen: make build_libs failed\n" unless $ok;
}

sub run_logged {
    my ($work, $logname, @cmd) = @_;
    my $log = File::Spec->catfile($work, $logname);
    open(my $fh, '>', $log) or die "gen: cannot write $log: $!\n";
    open(my $saveout, '>&', \*STDOUT) or die "gen: cannot dup stdout: $!\n";
    open(my $saveerr, '>&', \*STDERR) or die "gen: cannot dup stderr: $!\n";
    open(STDOUT, '>&', $fh) or die "gen: cannot redirect stdout: $!\n";
    open(STDERR, '>&', $fh) or die "gen: cannot redirect stderr: $!\n";
    my $ok = system(@cmd) == 0;
    open(STDOUT, '>&', $saveout) or die "gen: cannot restore stdout: $!\n";
    open(STDERR, '>&', $saveerr) or die "gen: cannot restore stderr: $!\n";
    close($fh);
    unless ($ok) {
        print STDERR "gen: command failed: @cmd\n";
        system('tail', '-n', '40', $log);
    }
    return $ok;
}

sub write_shim {
    my ($path, $real_zig) = @_;
    my $quoted = $real_zig;
    $quoted =~ s/'/'\\''/g;
    open(my $fh, '>', $path) or die "gen: cannot write $path: $!\n";
    print $fh <<"SHIM";
#!/bin/sh
# Used only by scripts/gen.pl. Compilations are faked (we only need the
# generated assembly/headers), but `zig cc --version` must be real so that
# OpenSSL's perlasm selects the LLVM-compatible output flavour.
if [ "\$1" = "cc" ]; then
    for a in "\$@"; do
        if [ "\$a" = "--version" ]; then
            exec '$quoted' "\$@"
        fi
    done
    out=
    prev=
    for a in "\$@"; do
        if [ "\$prev" = "-o" ]; then out="\$a"; fi
        prev="\$a"
    done
    if [ -n "\$out" ]; then
        mkdir -p "\$(dirname "\$out")"
        : > "\$out"
    fi
    exit 0
fi
exec '$quoted' "\$@"
SHIM
    close($fh);
    chmod(0755, $path) or die "gen: cannot chmod $path: $!\n";
}

sub parse_commands {
    my ($output, $work) = @_;
    my %groups;

    for my $line (split(/\n/, $output)) {
        next unless $line =~ / -c -o /;
        my @tok = shellwords($line);
        my $ci = first_index(\@tok, '-c');
        next if $ci < 0;
        my $oi = first_index(\@tok, '-o');
        next if $oi < 0 || $oi + 1 >= @tok;
        my $obj = $tok[$oi + 1];
        my $src = $tok[-1];
        next if $src =~ /^-/;

        # make prints source files as absolute paths when the build directory
        # is outside the source tree.  Normalise them back to paths relative
        # to the OpenSSL source root (and generated files relative to the
        # build root, which mirrors the source layout).
        my $abs_src = canon_abs($src, $work);
        my $rel_src;
        for my $base ($srcdir, $work) {
            my $rel = File::Spec->abs2rel($abs_src, $base);
            next if $rel =~ m{^\.\.(?:/|$)} || File::Spec->file_name_is_absolute($rel);
            $rel_src = $rel;
            last;
        }
        next unless defined $rel_src;

        my $lib;
        if ($obj =~ m{(?:^|/)(?:libcrypto|libdefault|libcommon)-lib-}) {
            $lib = 'crypto';
        } elsif ($obj =~ m{(?:^|/)libssl-lib-}) {
            $lib = 'ssl';
        } else {
            next;   # legacy/template providers are not part of libcrypto/libssl
        }

        my $lang;
        if ($rel_src =~ /\.c$/) {
            $lang = 'c';
        } elsif ($rel_src =~ /\.S$/) {
            $lang = 'assembly_with_preprocessor';
        } elsif ($rel_src =~ /\.s$/) {
            $lang = 'assembly';
        } else {
            next;
        }

        # Skip the compiler prefix ("zig cc -target <triple>").
        my $start = 0;
        if (@tok >= 2 && $tok[0] eq 'zig' && $tok[1] eq 'cc') {
            $start = 2;
            while ($start < $ci && ($tok[$start] eq '-target' || $tok[$start] eq '--target')) {
                $start += 2;
            }
        } else {
            $start = 1;
        }

        my @defines;
        my $i = $start;
        while ($i < $ci) {
            my $t = $tok[$i];
            if ($t eq '-MMD' || $t eq '-MP') {
                $i++;
                next;
            }
            if ($t eq '-MF' || $t eq '-MT' || $t eq '-MQ') {
                $i += 2;
                next;
            }
            if ($t =~ /^-I/) {
                $i++;
                next;
            }
            push @defines, $t if $t =~ /^-D/;
            $i++;
        }

        # The perlasm generation decides on the output dialect from CC; it
        # does not need the C compiler flags.  All we need to reproduce are
        # the preprocessor definitions.
        my %seen;
        @defines = sort grep { !$seen{$_}++ } @defines;

        my $generated = !-e File::Spec->catfile($srcdir, $rel_src);
        my $gkey = join("\0", $lib, $lang, $generated ? 'g' : 's', @defines);
        $groups{$gkey} //= {
            lib       => $lib,
            language  => $lang,
            defines   => \@defines,
            generated => $generated,
            files     => [],
        };
        push @{$groups{$gkey}{files}}, $rel_src;
    }

    return \%groups;
}

sub first_index {
    my ($array, $needle) = @_;
    for my $i (0 .. $#$array) {
        return $i if $array->[$i] eq $needle;
    }
    return -1;
}

# Lexically canonicalise a path (the file does not need to exist).  Perl's
# File::Spec->canonpath deliberately leaves ".." alone, which is not useful
# for comparing paths printed by make in an out-of-tree build.
sub canon_abs {
    my ($path, $base) = @_;
    my $abs = File::Spec->file_name_is_absolute($path)
        ? $path
        : File::Spec->catfile($base, $path);
    my @parts;
    for my $part (File::Spec->splitdir($abs)) {
        next if $part eq '' || $part eq '.';
        if ($part eq '..') {
            pop @parts if @parts;
            next;
        }
        push @parts, $part;
    }
    return '/' . join('/', @parts);
}

sub copy_generated {
    my ($work, $dest) = @_;
    my $count = 0;
    my @files;
    File::Find::find({
        wanted => sub {
            return unless -f $_;
            my $rel = File::Spec->abs2rel($File::Find::name, $work);
            return unless $rel =~ /\.(?:h|c|inc|s|S)$/;
            return if -e File::Spec->catfile($srcdir, $rel);
            push @files, $rel;
        },
        no_chdir => 1,
    }, $work);

    for my $rel (@files) {
        my $target = File::Spec->catfile($dest, $rel);
        make_path(dirname($target));
        copy(File::Spec->catfile($work, $rel), $target)
            or die "gen: cannot copy $rel: $!\n";
        scrub_paths($target, $work);
        $count++;
    }
    return $count;
}

# The generated headers contain comments with the Configure-relative source
# path.  Replace it so the checked-in output does not leak the generator's
# temporary layout.
sub scrub_paths {
    my ($path, $work) = @_;
    open(my $in, '<', $path) or die "gen: cannot read $path: $!\n";
    local $/;
    my $data = <$in>;
    close($in);
    my $rel = File::Spec->abs2rel($srcdir, $work);
    my $changed = 0;
    for my $needle ($rel, $srcdir) {
        next unless length $needle;
        my $before = $data;
        $data =~ s/\Q$needle\E/openssl/g;
        $changed = 1 if $data ne $before;
    }
    return unless $changed;
    open(my $out, '>', $path) or die "gen: cannot write $path: $!\n";
    print $out $data;
    close($out);
}

sub write_manifest_zon {
    my ($path, $by_key, $generators) = @_;
    my @out;
    push @out, "// Generated by scripts/gen.pl. Do not edit.\n";
    push @out, ".{\n";
    push @out, "    .include_dirs = " . zon_list(include_dirs()) . ",\n";
    push @out, "    .platforms = .{\n";
    for my $key (sort keys %$generators) {
        my $gen = $generators->{$key};
        my $data = $by_key->{$key};
        my ($crypto, $ssl) = split_groups($data->{groups});
        push @out, "        .{\n";
        push @out, "            .arch = " . zstr($gen->{arch}) . ",\n";
        push @out, "            .os = " . zstr($gen->{os}) . ",\n";
        push @out, "            .abis = " . zon_list(sort keys %{$gen->{abis}}) . ",\n";
        push @out, "            .generated_dir = " . zstr("generated/$key") . ",\n";
        push @out, "            .crypto = " . zon_group_list($crypto, "            ") . ",\n";
        push @out, "            .ssl = " . zon_group_list($ssl, "            ") . ",\n";
        push @out, "        },\n";
    }
    push @out, "    },\n";
    push @out, "}\n";

    make_path(dirname($path));
    open(my $fh, '>', $path) or die "gen: cannot write $path: $!\n";
    print $fh @out;
    close($fh);
}

# Plain-text mirror of manifest.zon for build systems that do not read Zig
# data files. The format is line oriented so it can be consumed with awk, a
# shell loop, or a few lines of any scripting language.
sub write_manifest_txt {
    my ($path, $by_key, $generators) = @_;

    my @out;
    push @out, <<'HEADER';
# zig-openssl generated source manifest
#
# This file mirrors generated/manifest.zon and is generated by scripts/gen.pl.
# It describes the sources, languages, compiler definitions and include
# directories needed to build OpenSSL 4.1.0's libcrypto and libssl with any C
# compiler. It is intentionally line oriented and needs no parser.
#
# Format: one record per line, fields separated by spaces. Blank lines and
# lines starting with '#' are ignored. Values are literal, so definitions such
# as -DOPENSSLDIR="/usr/local/ssl" keep their quotes; pass them to the compiler
# as single argv elements rather than re-parsing them with a shell.
#
#   version <n>
#       Format version (currently 1).
#
#   include <dir>
#       An include directory, relative to both the OpenSSL source root and the
#       platform generated directory. For every include record, add
#       -I<openssl-src>/<dir> followed by -I<generated-dir>/<dir>. The
#       generated directory must come first so it can shadow upstream headers.
#
#   platform <arch> <os> <abis> <generated-dir>
#       Starts a platform block. <abis> is a comma-separated list of ABIs that
#       share the same generated files, and <generated-dir> is relative to the
#       repository root. All following group/source/generated records belong to
#       this platform until the next platform record.
#
#   triple <target>
#       A Zig-style target triple served by the current platform block.
#
#   group <id> <lib> <language> <define>...
#       Compile the files that reference <id> with these definitions. <lib> is
#       either "crypto" or "ssl". <language> is "c", "assembly" (compile .s as
#       assembly) or "assembly_with_preprocessor" (compile .S through the C
#       preprocessor). <define> entries are passed verbatim.
#
#   source <id> <path>
#       A source file relative to the OpenSSL source root, belonging to group
#       <id>.
#
#   generated <id> <path>
#       A generated source file relative to <generated-dir>, belonging to group
#       <id>.
#
# Build notes:
#   - Build libcrypto first, then libssl, which links against it.
#   - Add -fPIC when producing objects for a shared library; the definitions
#     already include OPENSSL_PIC.
#   - On powerpc64le, compile and link with -mabi=ibmlongdouble.
#   - On x86_64-windows-gnu, link with
#     -lws2_32 -lcrypt32 -luserenv -ladvapi32 -lgdi32 -lbcrypt.
HEADER

    push @out, "version 1\n";
    push @out, "\n";

    for my $dir (include_dirs()) {
        assert_token('include directory', $dir);
        push @out, "include $dir\n";
    }

    my $id = 0;
    for my $key (sort keys %$generators) {
        my $gen = $generators->{$key};
        my $dir = "generated/$key";
        my $abis = join(',', sort keys %{$gen->{abis}});
        assert_token('arch', $gen->{arch});
        assert_token('os', $gen->{os});
        assert_token('generated directory', $dir);

        push @out, "\n";
        push @out, "platform $gen->{arch} $gen->{os} $abis $dir\n";
        for my $triple (@{$gen->{triples}}) {
            assert_token('target triple', $triple);
            push @out, "triple $triple\n";
        }

        my ($crypto, $ssl) = split_groups($by_key->{$key}{groups});
        for my $group (@$crypto, @$ssl) {
            my @defines = @{$group->{defines}};
            for my $define (@defines) {
                assert_token('compiler definition', $define);
            }
            push @out, join(' ', 'group', $id, $group->{lib}, $group->{language}, @defines) . "\n";

            my $kind = $group->{generated} ? 'generated' : 'source';
            for my $file (sort @{$group->{files}}) {
                assert_token('source path', $file);
                push @out, "$kind $id $file\n";
            }
            $id++;
        }
    }

    make_path(dirname($path));
    open(my $fh, '>', $path) or die "gen: cannot write $path: $!\n";
    print $fh @out;
    close($fh);
}

# The text format is whitespace separated, so any value containing whitespace
# would silently split into several fields. Nothing OpenSSL uses today contains
# whitespace, but fail loudly if that ever changes.
sub assert_token {
    my ($what, $value) = @_;
    die "gen: $what contains whitespace and cannot be written to the text manifest: '$value'\n"
        if $value =~ /\s/;
}

sub include_dirs {
    return (
        '.', 'include',
        'crypto', 'crypto/asn1', 'crypto/bn', 'crypto/conf', 'crypto/modes', 'crypto/objects',
        'providers/common/include', 'providers/common/include/prov',
        'providers/implementations/ciphers', 'providers/implementations/include',
        'providers/fips/include',
    );
}

sub split_groups {
    my ($groups) = @_;
    my (@crypto, @ssl);
    my @sorted = sort {
        join("\0", @{$a->{defines}}) cmp join("\0", @{$b->{defines}})
            or $a->{language} cmp $b->{language}
            or ($a->{generated} ? 1 : 0) <=> ($b->{generated} ? 1 : 0)
    } values %$groups;
    for my $g (@sorted) {
        if ($g->{lib} eq 'crypto') {
            push @crypto, $g;
        } else {
            push @ssl, $g;
        }
    }
    return (\@crypto, \@ssl);
}

sub zon_group_list {
    my ($groups, $indent) = @_;
    return '.{}' unless @$groups;
    my @items;
    for my $g (@$groups) {
        my @src = sort @{$g->{files}};
        my (@gen, @real);
        for my $f (@src) {
            if ($g->{generated}) {
                push @gen, $f;
            } else {
                push @real, $f;
            }
        }
        push @items, $indent . "    .{ .language = ." . $g->{language}
            . ", .defines = " . zon_list(@{$g->{defines}})
            . ", .src_files = " . zon_list(@real)
            . ", .gen_files = " . zon_list(@gen)
            . " }";
    }
    return ".{\n" . join(",\n", @items) . ",\n" . $indent . "}";
}

sub zon_list {
    my (@items) = @_;
    return '.{}' unless @items;
    return '.{ ' . join(', ', map { zstr($_) } @items) . ' }';
}

sub zstr {
    my ($s) = @_;
    $s =~ s/\\/\\\\/g;
    $s =~ s/"/\\"/g;
    return '"' . $s . '"';
}
