# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

inherit cros-workon

DESCRIPTION="Chrome OS verified boot tools"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="minimal rbtest tpmtests"
EAPI="2"
CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"

DEPEND="app-crypt/trousers
	dev-libs/openssl
	sys-apps/util-linux
        !minimal? ( dev-libs/libyaml )"

src_compile() {
	tc-export CC AR CXX
	local err_msg="${PN} compile failed. "
	err_msg+="Try running 'make clean' in the package root directory"
        # Vboot reference knows the flags to use
        unset CFLAGS
	emake ARCH=$(tc-arch) MINIMAL=$(usev minimal) || die "${err_msg}"
	if use rbtest; then
		emake ARCH=$(tc-arch) rbtest || die "${err_msg}"
	fi
}

src_install() {
	local dst_dir

	if use minimal ; then
		# Installing on the target. Cherry pick programs generated
		# by src_compile in the source tree build/ subdirectory
		einfo "Installing target programs"
		local progs='utility/dump_kernel_config'
		progs+=' utility/crossystem'
		progs+=' utility/dev_sign_file'
		progs+=' utility/tpm_init_temp_fix'
		progs+=' utility/tpmc'
		progs+=' utility/vbutil_key'
		progs+=' utility/vbutil_keyblock'
		progs+=' utility/vbutil_kernel'
		progs+=' utility/vbutil_firmware'
		progs+=' utility/vbutil_what_keys'
		progs+=' utility/gbb_utility'
		progs+=' utility/dump_fmap'
		progs+=' utility/dev_debug_vboot'
		progs+=' cgpt/cgpt'

		into /usr
		for prog in ${progs}; do
			dobin "${S}"/build/"${prog}"
		done

                einfo "Installing TPM tools"
                exeinto /usr/sbin
                doexe "utility/tpm-nvsize"
                doexe "utility/chromeos-tpm-recovery"

		einfo "Installing dev tools"
		dst_dir='/usr/share/vboot/bin'
		local src_dir='scripts/image_signing'
		dodir "${dst_dir}"
		exeinto "${dst_dir}"
		doexe "${src_dir}/common_minimal.sh"
		doexe "${src_dir}/resign_firmwarefd.sh"
		doexe "${src_dir}/make_dev_firmware.sh"
		doexe "${src_dir}/make_dev_ssd.sh"

		# TODO(hungte) Since we now install all keyset into
		# /usr/share/vboot/devkeys, maybe SAFT does not need to install
		# its own keys anymore.
		einfo "Installing keys for SAFT"
		local keys_to_install='recovery_kernel_data_key.vbprivk'
		keys_to_install+=' firmware.keyblock '
		keys_to_install+=' firmware_data_key.vbprivk'
		keys_to_install+=' kernel_subkey.vbpubk'
		keys_to_install+=' kernel_data_key.vbprivk'

		dst_dir='/usr/sbin/firmware/saft'
		dodir "${dst_dir}"
		insinto "${dst_dir}"
		for key in ${keys_to_install}; do
			doins "tests/devkeys/${key}"
		done

	else
		# Installing on host.
		emake DESTDIR="${D}/usr/bin" install || \
			die "${PN} install failed."

		# Install bitmap-generating scripts to /usr/share/vboot/bitmaps
		einfo "Installing bitmap-generating scripts"
		dst_dir='/usr/share/vboot/bitmaps'
		dodir "${dst_dir}"
		exeinto "${dst_dir}"
		doexe scripts/bitmaps/*.sh
		dst_dir='/usr/share/vboot/bitmaps/originals'
		dodir "${dst_dir}"
		insinto "${dst_dir}"
		doins scripts/bitmaps/originals/*

	fi
	if use rbtest; then
		emake DESTDIR="${D}/usr/bin" BUILD="${S}"/build -C tests \
		      install-rbtest || die "${PN} install failed."
	fi
	if use tpmtests; then
		into /usr
		# copy files starting with tpmtest, but skip .d files.
		dobin "${S}"/build/tests/tpm_lite/tpmtest*[^.]?
		dobin "${S}"/build/utility/tpm_set_readsrkpub
	fi

	# Install devkeys to /usr/share/vboot/devkeys
	# (shared by host and target)
	einfo "Installing devkeys"
	dst_dir='/usr/share/vboot/devkeys'
	dodir "${dst_dir}"
	insinto "${dst_dir}"
	doins tests/devkeys/*
	
	# Install static library needed by install programs.
  einfo "Installing dump_kernel_config library"
  dolib.a build/libdump_kernel_config.a || die
  insinto /usr/include/vboot/${subdir}
  doins "utility/include/kernel_blob.h" || die
  doins "utility/include/dump_kernel_config.h" || die
}
