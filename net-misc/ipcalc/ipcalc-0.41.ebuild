# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="calculates broadcast/network/etc... from an IP address and netmask"
LICENSE="GPL-2+"
HOMEPAGE="http://jodies.de/ipcalc"
SRC_URI="${HOMEPAGE}-archive/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=dev-lang/perl-5.6.0"

src_install () {
	dobin ${PN}
	dodoc changelog contributors
}
