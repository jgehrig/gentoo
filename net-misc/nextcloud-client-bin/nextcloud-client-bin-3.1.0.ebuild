# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

APPIMAGE_BIN="Nextcloud-${PV}-x86_64.AppImage"
SYM_BIN_NAME=${PN/-client-bin/}

inherit desktop

DESCRIPTION="Desktop Syncing Client for Nextcloud"
HOMEPAGE="https://github.com/nextcloud/desktop"
SRC_URI="https://github.com/nextcloud/desktop/releases/download/v${PV}/${APPIMAGE_BIN}"

RESTRICT="mirror"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=""
BDEPEND=""

src_unpack() {
	# Based on code from: https://github.com/Hummer12007/gentoo
	# See file: eclass/appimage.eclass
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

src_install() {
	doicon Nextcloud.png
	domenu com.nextcloud.desktopclient.nextcloud.desktop

	exeinto /opt/${PN}
	doexe ../${APPIMAGE_BIN}
	dosym /opt/${PN}/${APPIMAGE_BIN} usr/bin/${SYM_BIN_NAME}
}
