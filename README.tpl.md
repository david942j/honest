# Honest: Are your installed packages honest?
[![Build Status](https://travis-ci.org/david942j/honest.svg?branch=master)](https://travis-ci.org/david942j/honest)

Are your installed packages _really_ the same as you saw on GitHub?

Verify the source code before you installed it!

## Why

All open-source projects can be reviewed on GitHub, BitBucket, GitLab, etc.

But are you sure those packages published to pip/gem *exactly* same as they are in git-repositories?

Imagine this:
It looks all good, secure, many-users on GitHub, but who has checked *the packge pushed* to PyPI?
What if the developer hide an one-line backdoor in source-code before pushing it?
Once you installed it, you got owned!

Let's find out whether the packages you installed are **Honest**!

## Installation

```bash
$ git clone https://github.com/david942j/honest
$ cd honest
$ ./install.sh /usr/local # you may need sudo before the command
# or you can install somewhere under your home directory, such as:
# $ mkdir ~/local && ./install.sh ~/local && export PATH="$HOME/local/bin:$PATH"

$ honest --version # check if the installation succeed!
```

## Usage

```bash
$ honest github:david942j/one_gadget gem:one_gadget
# [INFO] OK, one_gadget is Honest!
```

#### See help for more details

```bash
SHELL_OUTPUT_OF(honest)
```

## Screenshots

![honest gem](https://github.com/david942j/honest/blob/master/screenshots/one_gadget.png?raw=true)

## Supported Package Manager

- [x] RubyGems (Ruby)
- [ ] PyPi (Python)
