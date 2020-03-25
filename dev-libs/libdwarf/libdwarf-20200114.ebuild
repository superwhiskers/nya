# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A DWARF object file access library"
HOMEPAGE="https://www.prevanders.net/dwarf.html"
SRC_URI="https://www.prevanders.net/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dwarfgen dwarfexample"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable dwarfgen) $(use_enable dwarfexample)
}