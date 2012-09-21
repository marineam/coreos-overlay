# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="afb0413dfe78b66ab6075fdd228f18969ae9f3d8"
CROS_WORKON_TREE="dbf0646d224f40317e4e2c49477fbb694aacd639"

EAPI=4
CROS_WORKON_PROJECT="chromiumos/platform/mtpd"
CROS_WORKON_LOCALNAME="mtpd"

inherit toolchain-funcs cros-debug cros-workon

DESCRIPTION="MTP daemon for Chromium OS"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="splitdebug test"

LIBCHROME_VERS="125070"

RDEPEND="
	chromeos-base/libchromeos
	dev-cpp/gflags
	dev-libs/dbus-c++
	>=dev-libs/glib-2.30
	dev-libs/protobuf
	media-libs/libmtp
	sys-fs/udev
"

DEPEND="${RDEPEND}
	chromeos-base/libchrome:${LIBCHROME_VERS}[cros-debug=]
	chromeos-base/system_api
	test? ( dev-cpp/gtest )"

src_compile() {
	tc-export CXX CC PKG_CONFIG
	cros-debug-add-NDEBUG
	export BASE_VER=${LIBCHROME_VERS}
	emake OUT=build-opt
}

src_test() {
	emake OUT=build-opt tests
}

src_install() {
	exeinto /opt/google/mtpd
	doexe build-opt/mtpd

	# Install seccomp policy file.
	insinto /opt/google/mtpd
	newins "mtpd-seccomp-${ARCH}.policy" mtpd-seccomp.policy

	# Install upstart config file.
	insinto /etc/init
	doins mtpd.conf

	# Install D-Bus config file.
	insinto /etc/dbus-1/system.d
	doins org.chromium.Mtpd.conf
}