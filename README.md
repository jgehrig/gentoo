# John Gehrig's Gentoo Overlay
This repository contains packages I am modifying, hacking on, or are otherwise unavailable in the main Gentoo Overlay.

**Disclaimer** These packages/scripts are experimental, some features may not work.

## How To Install This Overlay
Layman has been superseded by eselect-repository, which is easier to configure... Yay!

To use this overlay, you will need to `emerge eselect-repository`.

[Gentoo Wiki eselect/repository](https://wiki.gentoo.org/wiki/Eselect/Repository)

**Installation Commands:**  
1. `eselect repository add jgehrig git https://github.com/jgehrig/jgehrig-gentoo.git`
2. `emerge --sync`

### Common Error Messages
`!!! Section 'jgehrig' in repos.conf has location attribute set to nonexistent directory: '/var/db/repos/jgehrig'`

You need to perform an `emerge --sync` command so the repository is downloaded.

`!!! Section '{repo-name}' in repos.conf has name different from repository name 'jgehrig' set inside repository`

You must call this repository 'jgehrig' in the eselect repository command.

### Using Layman (Deprecated)
Previously, this overlay was added to layman by creating the file `/etc/portage/repros.conf/jgehrig.conf`:
```
[jgehrig-gentoo]
priority = 50
location = /var/lib/layman/jgehrig-gentoo
layman-type = git
auto-sync = Yes
```
