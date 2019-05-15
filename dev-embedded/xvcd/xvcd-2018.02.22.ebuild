# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_VERSION="8b47d64a440355526b1826e1c868badcb514ddf8"

DESCRIPTION="Xilinx Virtual Cable Daemon"
HOMEPAGE="https://github.com/tmbinc/xvcd"
SRC_URI="https://github.com/tmbinc/xvcd/archive/${SRC_VERSION}.zip -> ${P}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-embedded/libftdi"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	mv xvcd-8b47d64a440355526b1826e1c868badcb514ddf8 ${P}
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	exeinto /usr/bin
	doexe bin/xvcd
}
