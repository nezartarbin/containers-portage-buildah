# Distroless Container Build System with Portage and Buildah

This is a declarative, customizable container build system that builds very small container images containing only the application you need and its dependencies (Distroless), built from source code. It leverages [Portage](https://wiki.gentoo.org/wiki/Portage) to do most of the work for you, including functions to aid in building applications for most languages.

## Features

- Builds tiny, distroless container images containing only your application and its dependencies
- Optimized build system and package manager that can build your software from source code and resolves dependencies
- Fully Compatible with Dockerfile, docker runtime and other OCI tools
- Declarative and global management of compile flags and options, for extra optimization and space savings
- A large library of highly customizable build recipes for most common software
- Helper functions to help you compile software in most common languages

## Usage

The steps:

- Create and fill out `config.yaml`
- Run the template engine to fill in your configurations into the code
- Run the builder

Some optional steps (well, some are not optional unless you make slight modifications to the code):

- **Setup a gentoo repository mirror.** You can use the official mirror, but they discourage its use more than once a day.
- **Setup a custom ebuild repository hosting your custom build scripts.** This should only be necessary if you want to write a custom build script or if the program you want is not in the official repository. **Warning:** currently it is assumed you do have one, but this will be changed soon
- **Add a TLS certificate for your custom repository.** This should only be necessary if you're using self-signed certificates. I was using one, so I added this feature.

Let's breakdown the steps further

### Config.yaml

Let's discuss each section separately.

#### Portage Mirror

You can use the default 
portage_mirror:
    host: 132.145.133.173
    port: 11117
    rsync_module: gentoo-repos
build:
    threads: 12
    max_parallel_jobs: 12
    global_use_flags:
        add:
        remove:
            - systemd
            - openrc
            - man
            - bluetooth
            - X
            - wayland
    package_use_flags:
custom_ebuild_repository:
    name: oxa
    url: https://gitea.home/oxa/carboxamide-portage-overlay.git
    certificate_file_name: castle.crt
target:
    container_tag: oxa/nodejs:bin
    package_atoms: net-libs/nodejs-bin::oxa
