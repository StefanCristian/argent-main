# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="small and fast portage helper tools written in C"
HOMEPAGE="https://wiki.gentoo.org/wiki/Portage-utils"
SRC_URI="mirror://gentoo/${P}.tar.xz
	http://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="nls static"

RDEPEND="dev-libs/iniparser"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	static? ( dev-libs/iniparser[static-libs] )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-qcheck-tz.patch #551718
	epatch "${FILESDIR}"/${P}-qlop-tz.patch #551806
	epatch_user
}

src_configure() {
	use static && append-ldflags -static

	# Avoid slow configure+gnulib+make if on an up-to-date Linux system
	if use prefix || ! use kernel_linux || \
	   has_version '<sys-libs/glibc-2.10'
	then
		econf --with-eprefix="${EPREFIX}"
	else
		tc-export CC
	fi
}

src_compile() {
	emake NLS=$(usex nls)
}

src_install() {
	default

	exeinto /etc/portage/bin
	doexe "${FILESDIR}"/post_sync
	insinto /etc/portage/postsync.d
	doins "${FILESDIR}"/q-reinitialize

	# Portage fixes shebangs, we just need to fix the paths in the files
	sed -i \
		-e "s:\(/etc/portage/postsync.d\|/usr/bin/q\):${EPREFIX}&:g" \
		"${ED}"/etc/portage/bin/post_sync \
		"${ED}"/etc/portage/postsync.d/q-reinitialize || die
}

pkg_preinst() {
	# preserve +x bit on postsync files #301721
	local x
	pushd "${ED}" >/dev/null
	for x in etc/portage/postsync.d/* ; do
		[[ -x ${EROOT}/${x} ]] && chmod +x "${x}"
	done
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "${EPREFIX}/etc/portage/postsync.d/q-reinitialize has been installed for convenience"
		elog "If you wish for it to be automatically run at the end of every --sync:"
		elog "   # chmod +x ${EPREFIX}/etc/portage/postsync.d/q-reinitialize"
		elog "Normally this should only take a few seconds to run but file systems"
		elog "such as ext3 can take a lot longer.  To disable, simply do:"
		elog "   # chmod -x ${EPREFIX}/etc/portage/postsync.d/q-reinitialize"
	fi
}
