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

WIP

## Usage

```bash
$ honest
# Usage: honest [-h/--help] [-V/--version]
#               <git-url>
#               <package> [-v=]
# Examples:
#        honest --version
#        honest github:david942j/one_gadget@448e73dfcc60feb08cc71b843387e63a00791477 gem:one_gadget
#        honest https://github.com/pypa/setuptools@v39.0.1 pip:setuptools -v 39.0.1
#        honest ~/path_on_my_laptop/seccomp-tools gem:seccomp-tools -v 1.2.0
#
# Options:
#        -h, --help
#               Show this usage.
#        -V, --version
#               Display version information and exit.
#
# Git Url Parameter:
#        <git-url> can be:
#               - A relative/absolute path.
#               - https://<git org>/<author>/<project>[@<branch|commit|tag>]
#               - <github|bitbucket|gitlab>:<author>/<project>[@<branch|commit|tag>]
```

## Supported Package Manager

- [ ] PyPi (Python)
- [ ] RubyGems (Ruby)
- [ ] npm (JavaScript)
