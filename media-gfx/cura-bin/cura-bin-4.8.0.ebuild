# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on: https://github.com/gentoo/gentoo/blob/ded8091b58d975b4269265d60f13c333c4fc261d/media-gfx/cura/cura-4.8.0.ebuild
# Based on: https://github.com/Hummer12007/gentoo/blob/a761a7fb9ec235151297ffa0ee947c1e4e515d64/eclass/appimage.eclass

EAPI=7

APPIMAGE_BIN="Ultimaker_Cura-${PV}.AppImage"
SYM_BIN_NAME=${PN/-bin/}

inherit desktop xdg

DESCRIPTION="A 3D model slicing application for 3D printing"
HOMEPAGE="https://github.com/Ultimaker/Cura"
SRC_URI="https://github.com/Ultimaker/Cura/releases/download/${PV}/Ultimaker_Cura-${PV}.AppImage"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

# No Gentoo mirror, download from Github
RESTRICT="mirror"

# AppImage Binary: no dependencies
RDEPEND=""
BDEPEND=""

src_unpack() {
	local EXTRACT_DIR="${APPIMAGE_EXTRACT_DIR:-squashfs-root}"
	local EXTRACT_DEST="${APPIMAGE_EXTRACT_DEST:-${P}}"

	cp "${DISTDIR}/${APPIMAGE_BIN}" "${WORKDIR}"

	chmod +x "${APPIMAGE_BIN}" \
		|| die "Failed to add execute permissions to bundle"

	"${WORKDIR}/${APPIMAGE_BIN}" --appimage-extract >/dev/null 2>/dev/null \
		|| die "Failed to extract AppImage bundle"

	mv "${EXTRACT_DIR}" "${EXTRACT_DEST}" \
		|| die "Failed to move AppImage bundle to destination"
}

src_prepare() {
	default

	# Replace bash script call with AppImage symlink
	sed -i 's/Exec=cura.sh\ %F/Exec=cura\ %F/g' cura.desktop
}

src_install() {
	doicon cura-icon.png
	domenu cura.desktop

	exeinto /opt/${PN}
	doexe ../${APPIMAGE_BIN}
	dosym /opt/${PN}/${APPIMAGE_BIN} usr/bin/${SYM_BIN_NAME}
}
