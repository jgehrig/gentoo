# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit desktop gnome2-utils xdg-utils

DESCRIPTION="Microsoft Teams Linux Client"
HOMEPAGE="https://products.office.com/en-us/microsoft-teams/group-chat-software"

SRC_URI="https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams-insiders/teams-insiders_${PV}_amd64.deb"

# Do not use Gentoo mirrors
RESTRICT="mirror"

LICENSE=""
SLOT="0"
IUSE=""

DEPEND="
	app-arch/unzip
	"

RDEPEND="
	app-crypt/libsecret
	"

PATCHES=(
	"${FILESDIR}"/${P}-desktop-onlyshowin-remove.patch
)

S="${WORKDIR}"

src_unpack() {
	default

	tar -xf "${WORKDIR}/data.tar.xz" \
		|| die "Unable to unpack *.DEB file!"
}

src_compile() { :; }

src_install() {
	dobin usr/bin/teams-insiders

	doicon usr/share/pixmaps/teams-insiders.png
	domenu usr/share/applications/teams-insiders.desktop

	insinto /usr/share/
	doins -r  usr/share/teams-insiders
	fperms +x /usr/share/teams-insiders/teams-insiders
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
