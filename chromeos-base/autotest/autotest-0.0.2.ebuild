# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Autotest scripts and tools"
HOMEPAGE="http://src.chromium.org"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~arm ~amd64"
IUSE="+autox buildcheck +xset +tpmtools opengles hardened"

# TODO(snanda): Remove xset dependence once power_LoadTest is switched over
# to use power manager
# TODO(semenzato): tpm-tools is included for hardware_TpmFirmware (and at this
# time only one binary is used, tpm_takeownership).  Once we have a testing
# image, a better way would be to add tpm-tools to the image.
RDEPEND="
  chromeos-base/crash-dumper
  dev-cpp/gtest
  dev-lang/python
  autox? ( chromeos-base/autox )
  xset? ( x11-apps/xset )
  tpmtools? ( app-crypt/tpm-tools )
  "

DEPEND="
	${RDEPEND}"

export PORTAGE_QUIET=1

# Ensure the configures run by autotest pick up the right config.site
export CONFIG_SITE=/usr/share/config.site
export AUTOTEST_SRC="${CHROMEOS_ROOT}/src/third_party/autotest/files"

# Create python package init files for top level test case dirs.
function touch_init_py() {
	local dirs=${1}
	for base_dir in $dirs
	do
		local sub_dirs="$(find ${base_dir} -maxdepth 1 -type d)"
		for sub_dir in ${sub_dirs}
		do
			touch ${sub_dir}/__init__.py
		done
		touch ${base_dir}/__init__.py
	done
}

function setup_ssh() {
	eval $(ssh-agent) > /dev/null
	ssh-add \
		${CHROMEOS_ROOT}/src/scripts/mod_for_test_scripts/ssh_keys/testing_rsa
}

function teardown_ssh() {
	ssh-agent -k > /dev/null
}

function setup_cross_toolchain() {
	if tc-is-cross-compiler ; then
		tc-getCC
		tc-getCXX
		tc-getAR
		tc-getRANLIB
		tc-getLD
		tc-getNM
		tc-getSTRIP
		export PKG_CONFIG_PATH="${ROOT}/usr/lib/pkgconfig/"
		export CCFLAGS="$CFLAGS"
	fi

	# TODO(fes): Check for /etc/hardened for now instead of the hardened
	# use flag because we aren't enabling hardened on the target board.
	# Rather, right now we're using hardened only during toolchain compile.
	# Various tests/etc. use %ebx in here, so we have to turn off PIE when
	# using the hardened compiler
	if use x86 ; then
		if use hardened ; then
			#CC="${CC} -nopie"
			append-flags -nopie
		fi
	fi
}

function copy_src() {
	local dst=$1
	mkdir -p "${dst}"
	cp -fpru "${AUTOTEST_SRC}"/{client,conmux,server,tko,utils} "${dst}" || die
	cp -fpru "${AUTOTEST_SRC}/shadow_config.ini" "${dst}" || die
}

src_configure() {
	copy_src "${S}"
	sed "/^enable_server_prebuild/d" "${AUTOTEST_SRC}/global_config.ini" > \
		"${S}/global_config.ini"
	cd "${S}"
	touch_init_py client/tests client/site_tests
	touch __init__.py
	# Cleanup checked-in binaries that don't support the target architecture
	[[ ${E_MACHINE} == "" ]] && return 0;
	rm -fv $( scanelf -RmyBF%a . | grep -v -e ^${E_MACHINE} )
}

src_compile() {
	setup_cross_toolchain

	if use opengles ; then
		graphics_backend=OPENGLES
	else
		graphics_backend=OPENGL
	fi

	# Do not use sudo, it'll unset all your environment
	GRAPHICS_BACKEND="$graphics_backend" LOGNAME=${SUDO_USER} \
		client/bin/autotest_client --quiet --client_test_setup=${TEST_LIST} \
		|| ! use buildcheck || die "Tests failed to build."
	# Cleanup some temp files after compiling
	find . -name '*.[ado]' -delete

}

src_install() {
	insinto /usr/local/autotest
	doins -r "${S}"/*
}

pkg_postinst() {
	chown -R ${SUDO_UID}:${SUDO_GID} "${SYSROOT}/usr/local/autotest"
	chmod -R 755 "${SYSROOT}/usr/local/autotest"
}
