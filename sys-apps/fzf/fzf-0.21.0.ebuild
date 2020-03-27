# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_VENDOR=(
	"github.com/gdamore/tcell 4d152cc2622d491e1b0a034c3211b9df28c0ba2d"
	"github.com/lucasb-eyer/go-colorful fadcb7c7fa1e47844a23f5ebea95219172166a56"
	"github.com/mattn/go-isatty 7b513a986450394f7bbf1476909911b3aa3a55ce"
	"github.com/mattn/go-runewidth a4df4ddbff020e131056d91f580a1cdcd806e3ae"
	"github.com/mattn/go-shellwords 15c6c4ba21242f0256740b9417601db2d57a263b"
	"github.com/saracen/walker 324a081bae7e580aa0bf3afe8164acb16634afca"
	"golang.org/x/crypto 69ecbb4d6d5dab05e49161c6e77ea40a030884e1 github.com/golang/crypto"
	"golang.org/x/sys d101bd2416d505c0448a6ce8a282482678040a89 github.com/golang/sys"
	"golang.org/x/text 342b2e1fbaa52c93f31447ad2c6abc048c63e475 github.com/golang/text"
	)

DESCRIPTION="A command-line fuzzy finder"
HOMEPAGE="https://github.com/junegunn/fzf"
SRC_URI="
	https://github.com/junegunn/fzf/archive/${PV}.tar.gz
	$(go-module_vendor_uris)
	"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=">=dev-lang/go-1.13"

src_compile() {
	go build -o fzf
}

src_install() {
	cd "${S}"

	dobin fzf
	doman man/man1/*
	dodoc README.md README-VIM.md CHANGELOG.md
}
