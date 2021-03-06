# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"
inherit autotools-multilib

DESCRIPTION="A lightweight, speed optimized color management engine"
HOMEPAGE="http://www.littlecms.com/"
SRC_URI="mirror://sourceforge/${PN}/lcms2-${PV}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE="doc jpeg static-libs +threads test tiff zlib"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.3-r6:0=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r10
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/lcms2-${PV}

PATCHES=( "${FILESDIR}"/lcms-2.6-cve-2014-0459.patch )

src_configure() {
	local myeconfargs=(
		$(use_with jpeg)
		$(use_with tiff)
		$(use_with zlib)
		$(use_with threads)
	)
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install

	if use doc; then
		docinto pdf
		dodoc doc/*.pdf
	fi
}
