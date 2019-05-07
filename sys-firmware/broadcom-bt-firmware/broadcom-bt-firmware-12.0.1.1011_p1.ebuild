# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
#inherit toolchain-funcs

DESCRIPTION="Firmware images for Broadcom Bluetooth devices."
HOMEPAGE="https://github.com/winterheart/broadcom-bt-firmware"
SRC_URI="https://github.com/winterheart/broadcom-bt-firmware/archive/v${PV}.tar.gz"
KEYWORDS="amd64 x86"

LICENSE="MIT"
SLOT="0"

src_install() {
	insinto /lib/firmware/brcm
	doins brcm/*.hcd
}
