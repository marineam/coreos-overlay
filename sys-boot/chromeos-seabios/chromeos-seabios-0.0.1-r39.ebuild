# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
CROS_WORKON_COMMIT="8884ddc035127623418d2a1c0d1233f32789851b"
CROS_WORKON_TREE="b0c5a1f8632a6c8063eaffcba2be02da008d1c6e"

EAPI=2
CROS_WORKON_PROJECT="chromiumos/third_party/seabios"

inherit toolchain-funcs

DESCRIPTION="Open Source implementation of X86 BIOS"
HOMEPAGE="http://www.coreboot.org/SeaBIOS"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

CROS_WORKON_LOCALNAME="seabios"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon

src_compile() {
	export LD="$(tc-getLD).bfd"
	export CC="$(tc-getCC) -fuse-ld=bfd"
	emake defconfig || die "${P}: configuration failed"
	emake || die "${P}: compilation failed"
}

src_install() {
	dodir /firmware
	insinto /firmware
	doins out/bios.bin.elf || die
}