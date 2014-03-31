# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/open-vm-tools/open-vm-tools-2013.09.16.1328054-r3.ebuild,v 1.1 2014/02/02 15:47:56 floppym Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils eutils multilib pam versionator systemd toolchain-funcs

MY_PV="$(replace_version_separator 3 '-')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="http://open-vm-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc dnet icu pam +pic"

COMMON_DEPEND="
	dev-libs/glib:2
	sys-process/procps
	dnet? ( dev-libs/libdnet )
	pam? ( virtual/pam )
	icu? ( dev-libs/icu:= )
"

DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	virtual/linux-sources
	sys-apps/findutils
"

PATCHES=( "${FILESDIR}/0001-add-extra-configure-flags.patch" )

S="${WORKDIR}/${MY_P}"

src_configure() {
	# http://bugs.gentoo.org/402279
	if has_version '>=sys-process/procps-3.3.2'; then
		export CUSTOM_PROCPS_NAME=procps
		export CUSTOM_PROCPS_LIBS="$($(tc-getPKG_CONFIG) --libs libprocps)"
	fi

	# Don't call dnet-config
	if use dnet; then
		export CUSTOM_DNET_LIBS=-ldnet
	fi

	local myeconfargs=(
		--disable-hgfs-mounter
		--disable-multimon
		--disable-static
		--disable-tests
		--with-procps
		--without-fuse
		--without-gtk2
		--without-gtkmm
		--without-kernel-modules
		--without-x
		$(use_with dnet)
		$(use_with icu)
		$(use_with pam)
		$(use_with pic)
		$(use_enable doc docs)
		--docdir=/usr/share/doc/${PF}
	)

	econf "${myeconfargs[@]}"

	# Bugs 260878, 326761
	find ./ -name Makefile | xargs sed -i -e 's/-Werror//g'  || die "sed out Werror failed"
}

src_install() {
	default

	rm "${D}"/etc/pam.d/vmtoolsd
	if use pam; then
		pamd_mimic_system vmtoolsd auth account
	fi

	rm "${D}"/usr/$(get_libdir)/*.la
	rm "${D}"/usr/$(get_libdir)/open-vm-tools/plugins/common/*.la

	systemd_dounit "${FILESDIR}"/vmtoolsd.service
}
