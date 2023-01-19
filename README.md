<div align="center">

# asdf-tea [![Build](https://github.com/0ghny/asdf-tea/actions/workflows/build.yml/badge.svg)](https://github.com/0ghny/asdf-tea/actions/workflows/build.yml) [![Lint](https://github.com/0ghny/asdf-tea/actions/workflows/lint.yml/badge.svg)](https://github.com/0ghny/asdf-tea/actions/workflows/lint.yml)


[tea](https://gitea.com/gitea/tea) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-tea  ](#asdf-tea--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- **Optional**: `ASDF_TEA_OVERWRITE_ARCH` if present you can specify arch to download an specific one.

# Install

Plugin:

```shell
asdf plugin add tea
# or
asdf plugin add tea https://github.com/0ghny/asdf-tea.git
```

tea:

```shell
# Show all installable versions
asdf list-all tea

# Install specific version
asdf install tea latest

# Set a version globally (on your ~/.tool-versions file)
asdf global tea latest

# Now tea commands are available
tea --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/0ghny/asdf-tea/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [0ghny](https://github.com/0ghny/)
