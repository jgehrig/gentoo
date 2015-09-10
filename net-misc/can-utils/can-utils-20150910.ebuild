# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="SocketCAN Utilites"
HOMEPAGE="http://elinux.org/Can-utils"
#SRC_URI="https://codeload.github.com/linux-can/can-utils/zip/0e3ff3b3157e456d4b6343f5d4b42ef692bce538"

# github commit codes
SRC_VERSION="0e3ff3b3157e456d4b6343f5d4b42ef692bce538"

# github source download urls
SRC_URI="https://codeload.github.com/linux-can/can-utils/zip/${SRC_VERSION} -> ${P}.zip"



LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	mv can-utils-${SRC_VERSION} ${P}
	echo ${P}
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
