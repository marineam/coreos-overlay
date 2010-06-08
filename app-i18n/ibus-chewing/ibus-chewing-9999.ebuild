# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-chewing/ibus-chewing-1.2.0.20090917.ebuild,v 1.1 2009/09/17 16:17:22 matsuu Exp $

EAPI="2"
inherit cmake-utils

MY_P="${P}-Source"
DESCRIPTION="The Chewing IMEngine for IBus Framework"
HOMEPAGE="http://code.google.com/p/ibus/"
#SRC_URI="http://ibus.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.1
	>=dev-libs/libchewing-0.3.2
	dev-util/gob:2
	x11-libs/gtk+:2
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

CMAKE_IN_SOURCE_BUILD=1

DOCS="AUTHORS ChangeLog NEWS README"

# Chromium OS changes:
# - Add src_configure() and src_unpack().

src_configure() {
	tc-export CC CXX LD AR RANLIB NM
	cmake-utils_src_configure
}

src_unpack() {
	if [ -n "$CHROMEOS_ROOT" ] ; then
		local third_party="${CHROMEOS_ROOT}/src/third_party"
		local ibus="${third_party}/ibus-chewing/files"
		elog "Using ibus-chewing dir: $ibus"
		mkdir -p "${S}"
		cp -a "${ibus}"/* "${S}" || die
	else
		unpack ${A}
	fi
}
