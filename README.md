# John Gehrig's Gentoo Overlay
The following is my personal layman overlay for Gentoo. It contains various packages which I am experimenting with.

## To Add This Overlay
In the directory `/etc/portage/repros.conf/` add the following to a file 'jgehrig.conf':  
  
```
[jgehrig-gentoo]
priority = 50
location = /var/lib/layman/jgehrig-gentoo
layman-type = git
auto-sync = yes
```
