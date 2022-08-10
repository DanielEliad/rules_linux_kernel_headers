load("@rules_foreign_cc//foreign_cc:defs.bzl", "make")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")

def linux_kernel_headers(name, config, environment = None):
    config_name = name + "_kernel_config"
    config_file = name + ".kernel_config"

    # we have to copy the file because we need to tell the make command where our config is
    # which is hard because the config can be a complicated genrule
    # so we copy it under a predictable name
    copy_file(
        # Name of the rule.
        name = config_name,
        # A Label
        src = config,
        # Path of the output file, relative to this package.
        out = config_file,
    )

    env = {
        "INSTALL_HDR_PATH": "$$INSTALLDIR",
        # "KCONFIG_CONFIG": "$$EXT_BUILD_DEPS/" + config_file,
        "KCONFIG_CONFIG": "$(execpath :" + config_name + ")",
    }
    if not environment == None:
        env.update(environment)

    make(
        name = name,
        out_headers_only = True,
        # olddefconfig chooses default values for all missing keys in config
        # It also changes your configuration if it doesn't make sense
        # For example if your config had x86_64 everywhere but you specified CONFIG_64BIT=n
        # It would change things like:
        # CONFIG_X86_32=y
        # The default is chosen from the environment variables for ARCH and maybe more
        # set them using environment variable here
        targets = ["olddefconfig", "headers_install"],
        lib_source = "@kernel_headers//:src",
        build_data = [":" + config_name],
        env = env,
        out_include_dir = "include",
        visibility = ["//visibility:public"],
    )
