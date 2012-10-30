# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="eb5e9911bd5165b7de14edd330a2b663946cd064"
CROS_WORKON_TREE="fdf9ce605b7b93f209a1754cde412b288f098519"

EAPI="4"

CROS_WORKON_PROJECT="chromiumos/platform/inputcontrol"

inherit cros-workon

DESCRIPTION="A collection of utilities for configuring input devices"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="+X"

RDEPEND="app-arch/gzip
	 x11-apps/xinput"
DEPEND="${RDEPEND}"

src_prepare() {
	if ! use X; then
		epatch "${FILESDIR}"/0001-chgrp-dev-input-devices-to-chronos-for-DRM.patch
	fi
}