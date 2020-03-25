# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

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
	if [ $(use static-libs) ]; then
		econf --enable-shared --enable-static
	else
		econf --enable-shared --disable-static
	fi
}

src_install() {
	# libdwarf
	cd "${S}"/libdwarf

	install -d "${D}"/usr/"$(get_libdir)"
	if [ $(use static-libs) ]; then
		install .libs/libdwarf.a "${D}"/usr/"$(get_libdir)"
	fi
	install .libs/libdwarf.so "${D}"/usr/"$(get_libdir)"

	install -d "${D}"/usr/include/libdwarf
	install dwarf.h libdwarf.h "${D}"/usr/include/libdwarf

	dodoc README NEWS *.pdf

	# dwarfdump
	cd "${S}"/dwarfdump

	install -D dwarfdump "${D}"/usr/bin/dwarfdump
	install -D dwarfdump.conf "${D}"/usr/"$(get_libdir)"/dwarfdump.conf

	doman dwarfdump.1
}
