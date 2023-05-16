# semantic-release-action

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Contents

- [Description](#description)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Usage](#usage)
  - [Github Action](#github-action)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

# Description

This repo provides a [Dockerfile](./Dockerfile) that wraps [semantic-release](https://github.com/semantic-release/semantic-release) which can be used 1 of 2 ways.
1. As a Github Action
2. As the image of a CI job

See [Usage](#usage).

---

# Inputs

<!-- TODO -->

---

# Outputs

<!-- TODO -->

---

# Usage

When you use a docker based github action in your workflow, it will build Just in Time([JIT](https://en.wikipedia.org/wiki/Just-in-time_compilation)), as your workflow starts.

Therefore, using a pre-built image will provide a faster CI job execution, with the caveat that the image has all the tooling required already installed.

---

## Github Action
```yaml
uses: kloud-cnf/semantic-release-action@v0.1.0
```

---
<!-- TODO -->
<!-- ## CI Image
```yaml
name: Release

on:
  push:
    branches: ["main"]

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write

``` -->
