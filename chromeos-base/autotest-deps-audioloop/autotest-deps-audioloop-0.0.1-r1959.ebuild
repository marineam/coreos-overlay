# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="905504d4cc7f645affe6f65eaac7dcd5387f5622"
CROS_WORKON_TREE="cd9db859e66098efdf81b48e78e0d519d02c33af"

EAPI=2
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit cros-workon autotest-deponly

DESCRIPTION="Autotest audioloop dep"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"

# Autotest enabled by default.
IUSE="+autotest"

CROS_WORKON_LOCALNAME=../third_party/autotest
CROS_WORKON_SUBDIR=files

AUTOTEST_DEPS_LIST="audioloop"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

# deps/audioloop
RDEPEND="${RDEPEND}
	media-libs/alsa-lib
	media-sound/adhd"

DEPEND="${RDEPEND}"
