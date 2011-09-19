# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This project checks out the proto files from the read only repository
# linked to the src/chrome/browser/policy/proto directory of the Chromium
# project. It is not cros-work-able if changes to the protobufs are needed
# these should be done in the Chromium repository.

EGIT_REPO_SERVER="http://git.chromium.org"
EGIT_REPO_URI="${EGIT_REPO_SERVER}/chromium/src/chrome/browser/policy/proto.git"
EGIT_PROJECT="proto"

# Always being on the master revision should be fine in all cases. The protobufs
# MUST always stay backwards comaptible or else there will be data mismatches
# between data stored on the server from old and new versions of the protobuf.
EGIT_COMMIT="master"

EAPI="2"
inherit git

DESCRIPTION="Protobuf installer for the device policy proto definitions."
HOMEPAGE="http://chromium.org"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="!<=chromeos-base/chromeos-chrome-16.0.886.0_rc-r1
	!=chromeos-base/chromeos-chrome-16.0.882.0_alpha-r1"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/include/proto
	doins "${S}"/*.proto || die "Can not install protobuf files."
}
