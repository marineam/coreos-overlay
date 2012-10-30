# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="10cb0c151f82dca1e56d48c0c2faa44ce6d52e11"
CROS_WORKON_TREE="d6ecb200b5701e95f003363e5dd1a67acf611b5b"

EAPI="4"
CROS_WORKON_PROJECT="chromiumos/platform/touchbot"
CROS_WORKON_LOCALNAME="touchbot"

inherit cros-workon distutils

DESCRIPTION="Suite of control scripts for the Touchbot"
HOMEPAGE="http://www.chromium.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"