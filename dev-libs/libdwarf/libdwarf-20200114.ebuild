# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A DWARF object file access library"
HOMEPAGE="https://www.prevanders.net/dwarf.html"
SRC_URI="https://www.prevanders.net/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_configure() {
	econf --enable-shared $(use_enable dwarfgen) $(use_enable static-libs)
}

src_install() {
	# libdwarf
	cd "${S}"/libdwarf

	install -d "${D}"/usr/lib
	if [ $(use static-libs) ]; then
		install libdwarf.a "${D}"/usr/lib
	fi
	install libdwarf.so "${D}"/usr/lib

	install -d "${D}"/usr/include/libdwarf
	install dwarf.h libdwarf.h "${D}"/usr/include/libdwarf

	dodoc README NEWS *.pdf

	# dwarfdump
	cd "${S}"/dwarfdump

	install -D dwarfdump "${D}"/usr/bin/dwarfdump
	install -D dwarfdump.conf "${D}"/usr/lib/dwarfdump.conf

	doman dwarfdump.1
}
