# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2
CROS_WORKON_COMMIT="7104857773f790a549d399715482fa23d9b736cd"
CROS_WORKON_TREE="6ce294bb88229f44567404a1a5a9cd1b89157724"
CROS_WORKON_PROJECT="chromiumos/third_party/dbus-cplusplus"

inherit toolchain-funcs cros-workon

DESCRIPTION="C++ D-Bus bindings"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/dbus-c%2B%2B"
SRC_URI=""
LICENSE="LGPL-2"
SLOT="1"
IUSE="debug doc +glib"
KEYWORDS="amd64 x86 arm"

RDEPEND="
	glib? ( >=dev-libs/dbus-glib-0.76 )
	glib? ( >=dev-libs/glib-2.19:2 )
	>=sys-apps/dbus-1.0
        >=dev-cpp/ctemplate-1.0"
DEPEND="${DEPEND}
	doc? ( dev-libs/libxslt )
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${PN}-hack-Makefile.am-explicit-lpthread-to-fix-pthread.patch"
	./bootstrap || die "failed to bootstrap autotools"
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable doc doxygen-docs) \
		$(use_enable glib glib) || die "failed to congfigure"
}

src_compile() {
	append-flags -fPIC 
	emake || die "failed to compile dbus-c++"
}

src_install() {
	emake DESTDIR="${D}" install || die "failed to make"
	dodoc AUTHORS ChangeLog NEWS README || die "failed to intall doc"
}
