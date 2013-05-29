#
# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Copyright (c) 2013 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
# $Header:$
#

EAPI=2
CROS_WORKON_PROJECT="coreos/etcd-client"
CROS_WORKON_LOCALNAME="etcd-client"
CROS_WORKON_REPO="git://github.com"
CROS_WORKON_COMMIT="350501cefd98d7d816efaf7c650ad49c6c3dbc89"
inherit toolchain-funcs cros-workon systemd

DESCRIPTION="etcd-client"
HOMEPAGE="https://github.com/xiangli-cmu/etcd-client"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND=">=dev-lang/go-1.0.2"
GOROOT="${ED}usr/$(get_libdir)/go"
GOPKG="${PN}"

src_compile() {
	export GOPATH="${S}"
	go get
	go build -o ${PN} || die
}

src_install() {
	dobin ${S}/${PN} || die
}
