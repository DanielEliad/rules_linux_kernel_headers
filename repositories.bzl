load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# buildifier: disable=unnamed-macro
def linux_kernel_headers_dependencies(
        kernel_version = "4.14.151"):
    """
    Call this function from the WORKSPACE file to initialize linux_kernel_headers dependencies

    Args:
        kernel_version: The kernel version
    """
    kernel_major = kernel_version[0]

    maybe(
        http_archive,
        name = "kernel_headers",
        build_file = "@linux_kernel_headers//:BUILD.kernel",
        patches = [
            "@linux_kernel_headers//:kernel_install_hdr_patch",
        ],
        sha256 = "9b481473b29e63b332ef3d62c08462489ccfcd12638b1279c5aba81065002132",
        strip_prefix = "linux-" + kernel_version + "/",
        urls = ["https://cdn.kernel.org/pub/linux/kernel/v" + kernel_major + ".x/linux-" + kernel_version + ".tar.gz"],
    )

    maybe(
        http_archive,
        name = "rules_foreign_cc",
        sha256 = "2a4d07cd64b0719b39a7c12218a3e507672b82a97b98c6a89d38565894cf7c51",
        strip_prefix = "rules_foreign_cc-0.9.0",
        url = "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/0.9.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
        ],
        sha256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
    )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "5fa3c738d33acca3b97622a13a741129f67ef43f5fdfcec63b29374cc0574c29",
        strip_prefix = "rules_python-0.9.0",
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.9.0.tar.gz",
    )
