<div align="center">

# asdf-amber [![Build](https://github.com/s3than/asdf-amber/actions/workflows/build.yml/badge.svg)](https://github.com/s3than/asdf-amber/actions/workflows/build.yml) [![Lint](https://github.com/s3than/asdf-amber/actions/workflows/lint.yml/badge.svg)](https://github.com/s3than/asdf-amber/actions/workflows/lint.yml)


[amber](https://amber-lang.com/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-amber  ](#asdf-amber--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add amber
# or
asdf plugin add amber https://github.com/s3than/asdf-amber.git
```

amber:

```shell
# Show all installable versions
asdf list-all amber

# Install specific version
asdf install amber latest

# Set a version globally (on your ~/.tool-versions file)
asdf global amber latest

# Now amber commands are available
amber --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/s3than/asdf-amber/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Tim Colbert](https://github.com/s3than/)
