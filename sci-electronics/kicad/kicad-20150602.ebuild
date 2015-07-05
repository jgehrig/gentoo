# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"
WX_PYTHON_VER="3.0"
CMAKE_VER="2.6.0"

inherit cmake-utils wxwidgets fdo-mime gnome2-utils python-r1 flag-o-matic

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://www.kicad-pcb.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doxygen debug doc examples minimal python sexpr github help"

# don't download from distfiles.gentoo.org, use github instead
RESTRICT="primaryuri"

# github commit codes
SRC_VERSION="705c4ef4c583a2ab8802410044d85f5193416690"
LIB_VERSION="7db5dcaccd36e0424a578b2e1837ab686d3ace8f"
DOC_VERSION="b2bf4e3a4edc7650027ac8c3cde8ca356a958fa4"

# github source download urls
SRC_URI="
		https://github.com/KiCad/kicad-source-mirror/tarball/${SRC_VERSION} -> ${P}.tar.gz
		https://github.com/KiCad/kicad-library/tarball/${LIB_VERSION} -> ${P}-library.tar.gz
		https://github.com/KiCad/kicad-doc/tarball/${DOC_VERSION} -> ${P}-doc.tar.gz"


LANGS="bg ca cs de el_GR en es fi fr hu it ja ko nl pl pt ru sl sv zh_CN"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

CDEPEND="
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
		media-libs/glew"
DEPEND="
		${CDEPEND}
		>=dev-util/cmake-${CMAKE_VER}
		>=dev-libs/boost-1.40[context,threads,python?]
		app-arch/xz-utils
		dev-python/wxpython:${WX_PYTHON_VER}
		doxygen? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
		sys-libs/zlib
		sci-electronics/electronics-menu
		!minimal? ( !sci-electronics/kicad-library )"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	mv KiCad-kicad-doc-b2bf4e3 ${P}-doc
	mv KiCad-kicad-library-7db5dca ${P}-library
	mv KiCad-kicad-source-mirror-705c4ef ${S}
}

src_prepare() {
	if use help; then
		ln -s ${WORKDIR}/${P}-doc ${S}/${PN}-doc || die "ln failed"
    fi

    # If not minimal link the unpacked libraries dir into the main source
    if ! use minimal; then
        ln -s ${WORKDIR}/${P}-library ${S}/${PN}-library || die "ln failed"
	fi

	if use python;then
		# dev-python/wxpython don't support python3
		sed '/set(_PYTHON3_VERSIONS 3.3 3.2 3.1 3.0)/d' -i CMakeModules/FindPythonLibs.cmake || die "sed failed"
	fi

	#if use doc;then
	#	for lang in ${LANGS};do
	#		for x in ${lang};do
	#			if ! use linguas_${x}; then
	#				sed "s| \<${x}\>||" -i kicad-doc/{internat,doc/{help,tutorials}}/CMakeLists.txt || die "sed failed"
	#			fi
	#		done
	#	done
	#fi

	#fdo
	sed -e 's/Categories=Development;Electronics$/Categories=Development;Electronics;/' \
		-i resources/linux/mime/applications/*.desktop || die 'sed failed'

	# Add important doc files
	sed -e 's/INSTALL.txt/AUTHORS.txt CHANGELOG.txt README.txt TODO.txt/' -i CMakeLists.txt || die "sed failed"

	# Handle optional minimal install
	if use minimal; then
		sed -e '/add_subdirectory( template )/d' -i CMakeLists.txt || die "sed failed"
	else
		sed '/add_subdirectory( bitmaps_png )/a add_subdirectory( kicad-library )' -i CMakeLists.txt || die "sed failed"
		sed '/make uninstall/,/# /d' -i kicad-library/CMakeLists.txt || die "sed failed"
	fi

	# Add documentation and fix necessary code if requested
	if use doc; then
		sed '/add_subdirectory( bitmaps_png )/a add_subdirectory( kicad-doc )' -i CMakeLists.txt || die "sed failed"
		sed '/make uninstall/,$d' -i kicad-doc/CMakeLists.txt || die "sed failed"
	fi

	# Install examples in the right place if requested
	if use examples; then
		sed -e 's:${KICAD_DATA}/demos:${KICAD_DOCS}/examples:' -i CMakeLists.txt || die "sed failed"
	else
		sed -e '/add_subdirectory( demos )/d' -i CMakeLists.txt || die "sed failed"
	fi
}


src_configure() {
	bzr whoami "anonymous"
	if use amd64;then
		append-cxxflags -fPIC
	fi

	need-wxwidgets unicode

	mycmakeargs="${mycmakeargs}
		-DKICAD_DOCS=/usr/share/doc/${PN}
		-DKICAD_HELP=/usr/share/doc/${PN}/help
		-DwxUSE_UNICODE=ON
		-DKICAD_TESTING_VERSION=ON
		-DKICAD_MINIZIP=OFF
		-DKICAD_AUIMANAGER=OFF
		-DKICAD_AUITOOLBAR=OFF
		-DUSE_PCBNEW_NANOMETRES=ON
		$(cmake-utils_use sexpr USE_PCBNEW_SEXPR_FILE_FORMAT)
		$(cmake-utils_use github BUILD_GITHUB_PLUGIN)
		$(cmake-utils_use python KICAD_SCRIPTING)
		$(cmake-utils_use python KICAD_SCRIPTING_MODULES)
		$(cmake-utils_use python KICAD_SCRIPTING_WXPYTHON)"
	cmake-utils_src_configure
}

src_compile() {
	use doc && doxygen Doxyfile
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		insinto /usr/share/doc/${PN}
		doins uncrustify.cfg
		cd Documentation
		doins -r GUI_Translation_HOWTO.pdf guidelines/UIpolicies.txt doxygen/*
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	if use minimal ; then
		ewarn "If the schematic and/or board editors complain about missing libraries when you"
		ewarn "open old projects, you will have to take one or more of the following actions :"
		ewarn "- Install the missing libraries manually."
		ewarn "- Remove the libraries from the 'Libs and Dir' preferences."
		ewarn "- Fix the libraries' locations in the 'Libs and Dir' preferences."
		ewarn "- Emerge kicad without the 'minimal' USE flag."
		elog
	fi
	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
