# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="c64fe51989a605e53bb26cc03b0b62e3b2090ec7"
CROS_WORKON_TREE="8ca8a2c3cfcd1c6fd8f63e9d1e3e18161801f773"

EAPI=2
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest
CROS_WORKON_SUBDIR=files

inherit cros-workon autotest-deponly

DESCRIPTION="Autotest chromium ffmpeg dep"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="ffmpeg"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

# deps/ffmpeg
RDEPEND="${RDEPEND}
	chromeos-base/chromeos-chrome
"

DEPEND="${RDEPEND}"
