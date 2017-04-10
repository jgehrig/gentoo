# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors (Cortex-M0/M0+/M3/M4, Cortex-R4/R5/R7)."
HOMEPAGE="https://launchpad.net/gcc-arm-embedded"
SRC_URI="https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2"

LICENSE="BSD GPL GPL-2 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc samples"
RESTRICT="strip binchecks"

DEPEND=""
RDEPEND="amd64? ( sys-libs/glibc[multilib] )"

S="${WORKDIR}"/gcc-arm-none-eabi-5_4-2016q3

src_install() {
	if ! use samples ; then
		rm -rf "${S}"/share/gcc-arm-none-eabi/samples
	fi
	if ! use doc ; then
		rm -rf "${S}"/share/doc
	fi

	dodir /opt/${PN}
	cp -r "${S}"/* "${ED}"/opt/${PN} || die "cp failed"
	fowners -R root:0 /opt/${PN}

	local DEST=/opt/${PN}
	cat > "${T}/env" << EOF
PATH=${DEST}/bin
ROOTPATH=${DEST}/bin
LDPATH=${DEST}/lib
MANPATH=${DEST}/share/doc/arm-arm-none-eabi/man
EOF
	newenvd "${T}/env" 99gcc-arm-embedded-bin
}

pkg_postinst() {
	env-update
}
