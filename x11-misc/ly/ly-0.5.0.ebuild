# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam systemd

DESCRIPTION="A TUI display manager"
HOMEPAGE="https://github.com/cylgom/ly"
SRC_URI="https://github.com/cylgom/ly/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="systemd wayland X"

DEPEND=""
RDEPEND="x11-apps/xauth
	sys-libs/ncurses
	sys-apps/util-linux
	sys-libs/pam"

src_install() {
	dopamd res/pam.d/ly
	if use systemd; then
		systemd_dounit res/ly.service
	fi
	dobin bin/ly

	dodir /etc/ly
	insinto /etc/ly
	doins res/config.ini
	if use X; then
		doins res/xsetup.sh
	fi
	if use wayland; then
		doins res/wsetup.sh
	fi

	dodir /etc/ly/lang
	insinto /etc/ly/lang
	doins res/lang/*

}
