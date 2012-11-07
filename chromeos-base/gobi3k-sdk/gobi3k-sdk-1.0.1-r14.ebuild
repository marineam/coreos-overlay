# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
EAPI="2"

CROS_WORKON_COMMIT="150ef6765590447eda106ceeadf4aa8b31a13599"
CROS_WORKON_TREE="4afbea1b8695b5f88826ee96afbc9d8ae6763034"
CROS_WORKON_PROJECT="chromiumos/third_party/gobi3k-sdk"
CROS_WORKON_LOCALNAME=../third_party/gobi3k-sdk
inherit cros-workon toolchain-funcs

DESCRIPTION="SDK for Qualcomm Gobi 3000 modems"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

# TODO(jglasgow): remove realpath dependency
RDEPEND="
	app-misc/realpath
"

src_compile () {
	tc-export LD CXX CC OBJCOPY AR
	emake || die Building
}

src_install () {
	emake DESTDIR="${D}" install || die Installing
}