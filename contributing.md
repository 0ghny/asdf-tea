# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test tea https://github.com/0ghny/asdf-tea.git "tea --help"
```

Tests are automatically run in GitHub Actions on push and PR.
