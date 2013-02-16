# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/lcov/lcov-1.9.ebuild,v 1.3 2012/05/21 12:29:34 johu Exp $

EAPI="4"

inherit eutils

DESCRIPTION="A graphical front-end for GCC's coverage testing tool gcov"
HOMEPAGE="http://ltp.sourceforge.net/coverage/lcov.php"
SRC_URI="mirror://sourceforge/ltp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5
		dev-perl/GD[png]"

src_prepare() {
	epatch ${FILESDIR}/geninfo-gcov_4.6_compat.patch
}

src_install() {
	emake PREFIX="${D}" install || die "install failed"
}
