```
██╗  ██╗ ██████╗ ███╗   ██╗███████╗███████╗████████╗
██║  ██║██╔═══██╗████╗  ██║██╔════╝██╔════╝╚══██╔══╝
███████║██║   ██║██╔██╗ ██║█████╗  ███████╗   ██║   
██╔══██║██║   ██║██║╚██╗██║██╔══╝  ╚════██║   ██║   
██║  ██║╚██████╔╝██║ ╚████║███████╗███████║   ██║   
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝   ╚═╝   
                                                    
```

# Honest

Are your installed packages _really_ the same as you saw on GitHub?

Verify the source code before you installed it!

## Why

All open-source projects can be reviewed on GitHub, BitBucket, GitLab, etc.

But are you sure those packages published to pypi/npm/gem *exactly* same as they are in git-repositories?

Imagine this:
What if a developer hide an one-line backdoor in a millions-downloads package?

Let's find out whether the packages you installed are **Honest**!

## Installation

WIP

## Usage

```bash
$ honest --help
# Usage: honest [-h/--help] [-v/--version] <path-to-source-code> [--commit|--branch|--tag|--latest] <package>
#        honest --version
#        honest github://pypa/setuptools --tag v39.0.1 pip:setuptools-39.0.1
#        honest github://david942j/one_gadget --latest gem:one_gadget
#        honest ~/path_on_my_laptop/bower npm:bower-1.8.4
```

## Supported Package Manager

- [ ] PyPi (Python)
- [ ] RubyGems (Ruby)
- [ ] npm (JavaScript)
