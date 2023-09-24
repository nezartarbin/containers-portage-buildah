# Distroless Container Build System with Portage and Buildah

A declarative build system for ultra-light distroless containers with compile optimizations.

## Motivation

It always pained me seeing so many of the docker images out there in public use manually installing software packages and binaries and setting up the environment, replicating the work that has already been done by at least a dozen package managers out there. Why are we manually dealing with dependency hell again? Is this the 1990's? (I wasn't even born then!)

It made me wonder: Why isn't there a tool that you can declaratively give a list of software packages you want included, and it does the work of installing, dependency resolution and building for you?

So I thought why not take this a step further:
- make this tool capable of building distroless images: They only contain the applications we want and their dependencies, for enhanced security and reduced size.
- make this tool use an extensible build system that builds applications from source, supporting most languages, unlocking loads of compile options and customizations for optimizing performance and size
- make this tool use a large library of install and build recipes for most common software, so that developers need only to worry about managing their own software's build and installation

And this is how I arrived to this yet-unnamed container build tool!

## Features

- Builds tiny, distroless container images containing only your application and its dependencies
- Optimized build system and package manager that can build your software from source code and resolves dependencies
- Fully Compatible with Dockerfile, docker runtime and other OCI tools
- Declarative and global management of compile flags and options, for increased performance and size optimizations
- A large library of highly customizable build recipes for most common software
- Helper functions to help you compile software in most common languages

## Dependencies

The templater requires Python with pyyaml and jinja2 installed. A container Dockerfile is provided in template.Containerfile if that is preferred. You can build using `docker build -f template.Containerfile .` then run as `docker run [container-name] --volume ./:/code -- python /code/template/py`

The build step requires buildah installed. Please install it using your package manager. I do not have a containerized environment for this, as I then have to deal with running containers inside containers.

## Usage

The steps:

- Create and fill out `config.yaml` (or modify one of the examples)
- Run the template engine to fill in your configurations into the code. You need python and jinja for this.
- Run the builder. You need buildah installed for this.

Some optional steps (well, some are not optional unless you make slight modifications to the code):

- **Setup a gentoo repository mirror.** You can use the official mirror, but they discourage its use more than once a day.
- **Setup a custom ebuild repository hosting your custom build scripts.** This should only be necessary if you want to write a custom build script or if the program you want is not in the official repository. **Warning:** currently it is assumed you do have one, but this will be changed soon
- **Add a TLS certificate for your custom repository.** This should only be necessary if you're using self-signed certificates. I was using one, so I added this feature.

Let's breakdown the steps further, using an example.

### Config.yaml

Let's use the python example, and discuss each section separately.

```
portage_mirror:
    sync_type: git
    uri: https://github.com/gentoo-mirror/gentoo.git
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
custom_ebuild_repository: false
target:
    container_tag: mycontainers/python
    package_atoms: dev-lang/python
```

#### Portage Mirror

This points to the server to synchronize Gentoo's repository from. This example uses the git repository instead of rsync, as the rsync mirror has a limit of one sync per day.

#### Build

Build specific configurations:
- `threads` denotes the number of CPU threads to tell portage to use when compiling
- `max_parallel_jobs` tells portage how many packages can it compile in parallel at once. Usually leaving that as the same as threads is a good idea unless you are RAM restricted.
- `global_use_flags` are globally-managed compile flags and options. This is one of the most important features of Portage and this project. You can declaratively customize compile options across all your packages here. In this example, I listed flags to remove from all packages. You can optionally customize them by package below. For a list of possible values, please check out [The USE flag index](https://www.gentoo.org/support/use-flags/)
- `package_use_flags`: same as the above, but granular per package. As an example, [here is a list of USE flags for Python](https://packages.gentoo.org/packages/dev-lang/python)

#### Custom Ebuild Repository

This is where you can add a custom repository for build recipes for packages not found in the main repos. This would usually be your own application.

The remainder of this section will be added soon. In the meantime, please reference the `nodejs` example config.

#### Target

These are configurations for the target container image to be produced.

- `container_tag`: the name of the container that is used when referring to it in docker cli, etc.
- `package_atoms`: the names of the packages to install. It can be one package or a list of packages. No need to list dependencies.

##### Options Not Yet Added

- `entrypoint`: the containers entry poin. See Docker documentation
- `cmd`: the containers CMD. See Docker documentation

### Templating

To run the templater, simply run the `template.py` file from the project root. You need python installed with pyyaml and jinja2.

### Building

After the `dist` directory is generated by the templating, run the `build.bash` script right inside the `dist` directory. This will run subsequent build files in each of the generated directories to build your final image.


## Future Considerations

- Add instructions for software not found in standard repositories
- Allow setting CMD and Entrypoint for target containers
- Instructions for package-specific USE flags
- Allow the user to insert custom build recipes locally instead of referencing a remote repository of them
- Instructions on using buildah's containers and pushing to a registry
