# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Neovim client library and GUI, in Qt5"
HOMEPAGE="https://github.com/equalsraf/neovim-qt"
SRC_URI="https://github.com/equalsraf/neovim-qt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gcov +msgpack"

DEPEND="
	msgpack? ( dev-libs/msgpack )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}
	app-editors/neovim"

src_configure() {
	CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-DUSE_GCOV=$(usex gcov ON OFF)
		-DUSE_SYSTEM_MSGPACK=$(usex msgpack ON OFF)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
    xdg_desktop_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
}
