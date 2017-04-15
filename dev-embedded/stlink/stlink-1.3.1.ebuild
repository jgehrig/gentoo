# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

DESCRIPTION="Open Source STMicroelectronics STLink Command Line Tools"
HOMEPAGE="https://github.com/texane/stlink"

if [[ ${PV} == "9999" ]]; then
	SRC_URI="https://github.com/texane/stlink/archive/master.zip"
else
	SRC_URI="https://github.com/texane/stlink/archive/${PV}.zip"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-libs/libusb-1.0.9
	virtual/pkgconfig"
RDEPEND="
	>=virtual/libusb-1.0.9
"

pkg_setup() {
	CONFIG_CHECK="~USB_STORAGE"
	ERROR_USB_STORAGE="The kernel option CONFIG_USB_STORAGE is required for STLink-V1 to work."
}

src_configure() {
	local mycmakeargs=(
		-DSTLINK_UDEV_RULES_DIR="/lib/udev/rules.d"
	)

	cmake-utils_src_configure
}

src_install() {
	enable_cmake-utils_src_install
	cp -r etc $D
	einfo "You may want to run \`udevadm control --reload-rules'."
	dodoc README.md
}

