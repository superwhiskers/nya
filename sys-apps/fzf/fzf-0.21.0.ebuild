# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build

DESCRIPTION="A command-line fuzzy finder"
HOMEPAGE="https://github.com/junegunn/fzf"
SRC_URI="https://github.com/junegunn/fzf/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EGO_PN="github.com/junegunn/fzf"

BDEPEND=">=dev-lang/go-1.13"

src_install() {
	default

	cd "${S}"
	doman man/man1/*
	dodoc README.md README-VIM.md CHANGELOG.md
}
