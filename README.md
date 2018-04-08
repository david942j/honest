# Honest: Are your installed packages honest?
[![Build Status](https://travis-ci.org/david942j/honest.svg?branch=master)](https://travis-ci.org/david942j/honest)

Are your installed packages _really_ the same as you saw on GitHub?

Verify the source code before you installed it!

## Why

All open-source projects can be reviewed on GitHub, BitBucket, GitLab, etc.

But are you sure those packages published to pip/npm/gem *exactly* same as they are in git-repositories?

Imagine this:
It looks all good, secure, many-users on GitHub, but who has checked *the packge pushed* to PyPI?
What if the developer hide an one-line backdoor in source-code before pushing it?
Once you installed it, you got owned!

Let's find out whether the packages you installed are **Honest**!

## Installation

WIP

## Usage

```bash
$ honest
# Usage: honest [-h/--help] [-V/--version]
#               <path-to-source-code> [--commit=|--latest|--tag=]
#               <package> [-v=]
# Examples:
#        honest --version
#        honest github://pypa/setuptools --tag v39.0.1 pip:setuptools -v 39.0.1
#        honest github://david942j/one_gadget --latest gem:one_gadget
#        honest ~/path_on_my_laptop/bower npm:bower
```

## Supported Package Manager

- [ ] PyPi (Python)
- [ ] RubyGems (Ruby)
- [ ] npm (JavaScript)
