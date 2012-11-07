# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="1dfa8ce05d77c8bddfdabcc4988b51f923428b08"
CROS_WORKON_TREE="ee67563fa40a5bcbc1596cdceeece1e1a3a15f89"
CROS_WORKON_LOCALNAME="../platform/chromiumos-wide-profiling"
CROS_WORKON_PROJECT="chromiumos/platform/chromiumos-wide-profiling"

inherit cros-workon toolchain-funcs

DESCRIPTION="Program used to collect performance data on ChromeOS machines"
HOMEPAGE=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="dev-util/perf
	net-misc/curl
	sys-libs/zlib"
DEPEND="test? ( dev-cpp/gtest )
	net-misc/curl
	sys-libs/zlib"

src_configure() {
	tc-export CXX
}

src_test() {
	emake check
}

src_install() {
	dobin ${PN}.exe
}