# copyright 2020 superwhiskers <whiskerdev@protonmail.com>
# distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 java-pkg-2 java-vm-2 pax-utils eapi7-ver

DESCRIPTION="An optimized JVM for OpenJDK 8"
HOMEPAGE="http://www.eclipse.org/openj9"
SRC_URI="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08_openj9-0.18.1/OpenJDK8U-jdk_x64_linux_openj9_8u242b08_openj9-0.18.1.tar.gz"
EGIT_REPO_URI="https://github.com/ibmruntimes/openj9-openjdk-jdk8.git"

LICENSE="GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

BOOTSTRAP_JDK_PATH="${WORKDIR}/jdk8u242-b08"
S="${WORKDIR}/openj9-openjdk-jdk8"

FREEMARKER_PATH=""

# todo:
# - webstart + nsplugin
IUSE="gentoo-vm cuda alsa cups jitserver headless-awt debug doc examples source openssl large-heap +pch selinux"

COMMON_DEPEND="
	sys-process/numactl
	dev-libs/libdwarf
	dev-libs/elfutils
	media-libs/freetype:2=
	media-libs/giflib:0/7
	sys-libs/zlib
	cuda? ( dev-util/nvidia-cuda-sdk )
	"

RDEPEND="
	${COMMON_DEPEND}
	>=sys-apps/baselayout-java-0.1.0-r1
	!headless-awt? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXt
		x11-libs/libXtst
	)
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	selinux? ( sec-policy/selinux-java )
	"

DEPEND="
	${COMMON_DEPEND}
	dev-vcs/git
	dev-lang/nasm
	app-arch/zip
	media-libs/alsa-lib
	net-print/cups
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXtst
	"

# this is unneeded without webstart or nsplugin
# PDEPEND=""

pkg_setup() {
	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_prepare() {
	default

	sh get_source.sh || die
	chmod +x configure || die

	wget https://sourceforge.net/projects/freemarker/files/freemarker/2.3.8/freemarker-2.3.8.tar.gz/download -O freemarker.tar.gz || die
	tar -vxzf freemarker.tar.gz freemarker-2.3.8/lib/freemarker.jar --strip=2 || die
	rm freemarker.tar.gz || die
	FREEMARKER_PATH=$(realpath freemarker.jar)
}

src_configure() {

	local configuration=(
		--disable-ccache
		--with-freemarker-jar="${FREEMARKER_PATH}"
		--with-boot-jdk="${BOOTSTRAP_JDK_PATH}"
		--with-extra-cflags="${CFLAGS}"
		--with-extra-cxxflags="${CXXFLAGS}"
		--with-extra-ldflags="${LDFLAGS}"
		--with-extra-asflags="${ASFLAGS}"
		--with-giflib=system
		--with-zlib=system
		--without-jtreg
		--with-update-version="$(ver_cut 2)"
		--with-build-number="b$(ver_cut 4)"
		--with-milestone="fcs"
		--with-vendor-name="Gentoo (::nya)"
		--with-vendor-url="https://github.com/superwhiskers/nya"
		--with-vendor-bug-url="https://github.com/superwhiskers/nya/issues"
		--with-vendor-vm-bug-url="https://github.com/eclipse/openj9/issues"
		--with-native-debug-symbols=$(usex debug internal none)
		$(usex headless-awt --disable-headful '')
		$(usex openssl --with-openssl=system '')
		$(usex large-heap --with-noncompressedrefs '')
		$(use_enable cuda)
		$(use_enable jitserver)
		$(use_enable debug)
	)

	if use pch && ! host-is-pax; then
		configuration+=( --enable-precompiled-headers )
	else
		configuration+=( --disable-precompiled-headers )
	fi

	(
		unset _JAVA_OPTIONS JAVA JAVA_TOOL_OPTIONS JAVAC XARGS
		CFLAGS= CXXFLAGS= LDFLAGS= ASFLAGS= \
			CONFIG_SITE=/dev/null \
			econf "${configuration[@]}"
	)
}

# this part here is basically copied from dev-java/openjdk/openjdk-8.242.ebuild

src_compile() {
	local makeargs=(
		LOG=debug
		$(usex doc docs '')
	)
	emake "${makeargs[@]}"
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}-live"
	local ddest="${ED%/}/${dest#/}"

	cd "${S}"/build/*-release/images/j2sdk-image || die

	if ! use alsa; then
		rm -v jre/lib/$(get_system_arch)/libjsoundalsa.* || die
	fi

	# stupid build system does not remove that
	if use headless-awt ; then
		rm -fvr jre/lib/$(get_system_arch)/lib*{[jx]awt,splashscreen}* \
		{,jre/}bin/policytool bin/appletviewer || die
	fi

	if ! use examples ; then
		rm -vr demo/ || die
	fi

	if ! use source ; then
		rm -v src.zip || die
	fi

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	dosym ../../../../../../etc/ssl/certs/java/cacerts "${dest}"/jre/lib/security/cacerts

	java-vm_install-env "${FILESDIR}"/${PN}-live.env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter

	if use doc ; then
		docinto html
		dodoc -r "${S}"/build/*-release/docs/*
	fi
}

pkg_postinst() {
	java-vm-2_pkg_postinst
}
