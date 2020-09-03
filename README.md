# Experimental Gentoo Overlay
This is a repository for my own experimentation. It contains experimental software, or packages otherwise unavailable in the main Gentoo Overlay.

## How To Install This Overlay
Layman has been superseded by eselect-repository, which is easier to configure... Yay!

To use this overlay, you will need to `emerge eselect-repository`.

[Gentoo Wiki eselect/repository](https://wiki.gentoo.org/wiki/Eselect/Repository)

**Installation Commands:**  
1. `eselect repository add jgehrig git https://github.com/jgehrig/gentoo.git`
2. `emerge --sync`

### Common Error Messages
`!!! Section 'jgehrig' in repos.conf has location attribute set to nonexistent directory: '/var/db/repos/jgehrig'`

You need to perform an `emerge --sync` command so the repository is downloaded.

`!!! Section '{repo-name}' in repos.conf has name different from repository name 'jgehrig' set inside repository`

You must call this repository 'jgehrig' in the eselect repository command.
