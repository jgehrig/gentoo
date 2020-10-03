# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Monospaced font with programming ligatures patched with glyphs"
HOMEPAGE="https://github.com/tonsky/FiraCode"
SRC_URI="https://github.com/ryanoasis/nerd-fonts/releases/download/v${PV}/FiraCode.zip -> ${P}.zip"

RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}"
FONT_S="${S}/distr/ttf"
FONT_SUFFIX="ttf otf"

#DOCS="README.md"

DEPEND="app-arch/unzip"

src_prepare() {
	default
	echo "WORKDIR: ${WORKDIR}"
	echo "S: ${S}"
	echo "FONT_S: ${FONT_S}"

	mkdir -p "${FONT_S}"
	mv "${WORKDIR}"/*.otf "${FONT_S}" || die
	mv "${WORKDIR}"/*.ttf "${FONT_S}" || die
	rm "${FONT_S}"/*Windows*.otf
	rm "${FONT_S}"/*Windows*.ttf
}
