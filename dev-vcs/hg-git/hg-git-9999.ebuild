# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 mercurial

MY_PV=${PV/_rc/a}
DESCRIPTION="Use Mercurial to push and pull from Git repositories"
HOMEPAGE="https://hg-git.github.io https://pypi.org/project/hg-git/"
EHG_REPO_URI="https://foss.heptapod.net/mercurial/hg-git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-vcs/mercurial-4.3[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.19.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${MY_PV}"
