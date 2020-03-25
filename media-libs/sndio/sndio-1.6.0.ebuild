# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A small audio and MIDI framework part of the OpenBSD project"
HOMEPAGE="http://www.sndio.org"
SRC_URI="http://www.sndio.org/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libbsd"

DEPEND="media-libs/alsa-lib
	libbsd? ( dev-libs/libbsd )"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/${PV}-accept-arguments.patch")

src_configure() {
	econf --enable-alsa $(use_with libbsd) || die
}
