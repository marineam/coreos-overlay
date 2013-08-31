# Copyright 2013 The CoreOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Fully automated tests on Linux"
HOMEPAGE="http://autotest.github.io"
SRC_URI="https://github.com/autotest/autotest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-install-release-version.patch" )
