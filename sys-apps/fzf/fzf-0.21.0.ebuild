# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A command-line fuzzy finder"
HOMEPAGE="https://github.com/junegunn/fzf"
SRC_URI="https://github.com/junegunn/fzf/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=">=dev-lang/go"

src_compile() {
	cd "${S}"
	go build -o fzf
}

src_install() {
	cd "${S}"
	doman man/man1/*
	dodoc README.md README-VIM.md CHANGELOG.md
	dobin fzf
}
