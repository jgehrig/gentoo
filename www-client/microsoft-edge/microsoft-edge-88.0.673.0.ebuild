# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# FIXME Dev release doesn't appear to have all of these localizations yet...
#CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
#	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
#	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit chromium-2 eutils gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="Microsoft Edge Web Browser"
HOMEPAGE="https://www.microsoft.com/en-us/edge"

# FIXME Should a -dev be appended to this ebuild's name?
MY_PN="${PN}-dev"

SRC_URI="https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_${PV}-1_amd64.deb"

# Do not use Gentoo mirrors
RESTRICT="bindist mirror strip"

LICENSE=""
SLOT="0"

DEPEND=""
RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	app-arch/bzip2
	app-misc/ca-certificates
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	>=dev-libs/nss-3.26
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/mesa[gbm]
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libdrm
	>=x11-libs/libX11-1.5.0
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/google-chrome.*\\.desktop"
S=${WORKDIR}
CHROME_HOME="opt/microsoft/msedge-dev${PN#microsoft-edge}"

pkg_nofetch() {
	einfo "Please download Microsoft Edge"
	einfo "  - microsoft-edge-dev_${PV}-1_amd64.deb"
	einfo "from ${HOMEPAGE} and place them in your DISTDIR directory."
}

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "google-chrome only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	rm _gpgorigin || die
	rm -r etc usr/share/menu || die
	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die

	gzip -d usr/share/doc/${PF}/changelog.gz || die
	gzip -d usr/share/man/man1/${MY_PN}.1.gz || die
	if [[ -L usr/share/man/man1/google-chrome.1.gz ]]; then
		rm usr/share/man/man1/google-chrome.1.gz || die
		dosym ${MY_PN}.1 usr/share/man/man1/${MY_PN}.1
	fi

	pushd "${CHROME_HOME}/locales" > /dev/null || die
	#chromium_remove_language_paks
	popd > /dev/null || die

	#FIXME See above -dev comment... If so, MY_PN -> PN
	local suffix=
	[[ ${MY_PN} == microsoft-edge-dev ]] && suffix=_dev

	local size
	for size in 16 24 32 48 64 128 256 ; do
		newicon -s ${size} "${CHROME_HOME}/product_logo_${size}${suffix}.png" ${PN}.png
	done

	pax-mark m "${CHROME_HOME}/microsoft-edge"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
