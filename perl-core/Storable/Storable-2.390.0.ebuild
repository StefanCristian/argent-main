# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=AMS
MODULE_VERSION=2.39
inherit perl-module

DESCRIPTION="The Perl Storable Module"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

#RDEPEND="
#	virtual/perl-XSLoader
#"
#DEPEND="${RDEPEND}"

SRC_TEST="do"
