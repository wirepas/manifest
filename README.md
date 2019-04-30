# manifest
This repository servers as an aggregator for common configuration files as well as xml manifest for usage with the repo tool.

## Repo

The repo tool is an utility developed under the [Android project](https://source.android.com/setup/develop). Its purpose is to
facilitate repository management, especially for repositories which depend on other repositories. 

## Installation and usage

For installation please refer to:

-  https://source.android.com/setup/build/downloading

For help on using the repo tool, please refer to:

-  https://source.android.com/setup/develop/repo


## Development tools

There are other configuration files present in this repository which handle general configuration of 3rd party tools and services, such as
hound and pre-commit. 

### Pre-commit 

[Pre-commit](https://pre-commit.com/) is a Python tool that allows easy management of pre commit hooks. It relies on (./.pre-commit-config.yaml) 
to specify which hooks to install and execute on a given stage.

### Installation and dependencies

Pre-commit requires Python and Pip to be installed and available on the system or user's path. 

The official instructions are avialable from:

-  https://pre-commit.com/#install

A few of the hooks depend on other Python and host packages. Necessary Python packages are described in (./dev-requirements.txt)
and other system packages consist of:

- [Shellcheck](https://www.shellcheck.net/)

- [Clang format](https://clang.llvm.org/docs/ClangFormat.html)


## License

Licensed under the Apache License, Version 2.0. See LICENSE for the full license text.
