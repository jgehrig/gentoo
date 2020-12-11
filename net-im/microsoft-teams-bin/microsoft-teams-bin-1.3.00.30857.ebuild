# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit desktop

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

S="${WORKDIR}"

src_unpack() {
	default

	ar x "${WORKDIR}/teams-insiders_${PV}_amd64.deb"
	tar -xf "${WORKDIR}/data.tar.xz"
}

src_compile() { :; }

src_install() {
	dobin usr/bin/teams-insiders

	domenu usr/share/applications/teams-insiders.desktop || die

	insinto /usr/share/
	doins -r  usr/share/teams-insiders
}
