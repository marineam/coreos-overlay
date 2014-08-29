# Copyright (c) 2014 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="coreos/updateservicectl"
CROS_WORKON_LOCALNAME="updateservicectl"
CROS_WORKON_REPO="git://github.com"

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64"
else
	CROS_WORKON_COMMIT="49c4d164bfeee2ea9c9743197c103eaa1368eff5"  # tag v1.3.3
	KEYWORDS="amd64"
fi

inherit cros-workon

DESCRIPTION="CoreUpdate Management CLI"
HOMEPAGE="https://github.com/coreos/updateservicectl"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.2"
RDEPEND="!app-admin/updatectl"

src_compile() {
	./build || die
}

src_install() {
	dobin bin/updateservicectl
}
