
##Installing Package acl

tar -xvf acl-2.3.2.tar.xz
cd acl-2.3.2
        
./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-2.3.2
make
make check
make install
cd $LFS/sources
rm -rf acl-2.3.2
##Installing Package attr

tar -xvf attr-2.5.2.tar.gz
cd attr-2.5.2
        
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2
make
make check
make install
cd $LFS/sources
rm -rf attr-2.5.2
##Installing Package autoconf

tar -xvf autoconf-2.72.tar.xz
cd autoconf-2.72
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf autoconf-2.72
##Installing Package automake

tar -xvf automake-1.17.tar.xz
cd automake-1.17
        
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.17
make
make -j$(($(nproc)>4?$(nproc):4)) check
make install
cd $LFS/sources
rm -rf automake-1.17
##Installing Package bash

tar -xvf bash-5.2.37.tar.gz
cd bash-5.2.37
        
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.2.37
make
chown -R tester .
su -s /usr/bin/expect tester << "EOF"
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
make install
exec /usr/bin/bash --login
cd $LFS/sources
rm -rf bash-5.2.37
##Installing Package bc

tar -xvf bc-7.0.3.tar.xz
cd bc-7.0.3
        
CC=gcc ./configure --prefix=/usr -G -O3 -r
make
make test
make install
cd $LFS/sources
rm -rf bc-7.0.3
##Installing Package binutils

tar -xvf binutils-2.44.tar.xz
cd binutils-2.44
        
mkdir -v build
cd       build
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu
make tooldir=/usr
make -k check
grep '^FAIL:' $(find -name '*.log')
make tooldir=/usr install
rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/
cd $LFS/sources
rm -rf binutils-2.44
##Installing Package bison

tar -xvf bison-3.8.2.tar.xz
cd bison-3.8.2
        
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
make
make check
make install
cd $LFS/sources
rm -rf bison-3.8.2
##Installing Package bzip2

tar -xvf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8
        
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv /usr/lib/libbz2.a
cd $LFS/sources
rm -rf bzip2-1.0.8
##Installing Package check

tar -xvf check-0.15.2.tar.gz
cd check-0.15.2
        
./configure --prefix=/usr --disable-static
make
make check
make docdir=/usr/share/doc/check-0.15.2 install
cd $LFS/sources
rm -rf check-0.15.2
##Installing Package coreutils

tar -xvf coreutils-9.6.tar.xz
cd coreutils-9.6
        
patch -Np1 -i ../coreutils-9.6-i18n-1.patch
autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
make
make NON_ROOT_USERNAME=tester check-root
groupadd -g 102 dummy -U tester
chown -R tester .
su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" \
   < /dev/null
groupdel dummy
make install
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
cd $LFS/sources
rm -rf coreutils-9.6
##Installing Package dejagnu

tar -xvf dejagnu-1.6.3.tar.gz
cd dejagnu-1.6.3
        
mkdir -v build
cd       build
../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
make check
make install
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3
cd $LFS/sources
rm -rf dejagnu-1.6.3
##Installing Package diffutils

tar -xvf diffutils-3.11.tar.xz
cd diffutils-3.11
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf diffutils-3.11
##Installing Package e2fsprogs

tar -xvf e2fsprogs-1.47.2.tar.gz
cd e2fsprogs-1.47.2
        
mkdir -v build
cd       build
../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
make
make check
make install
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
sed 's/metadata_csum_seed,//' -i /etc/mke2fs.conf
cd $LFS/sources
rm -rf e2fsprogs-1.47.2
##Installing Package expat

tar -xvf expat-2.6.4.tar.xz
cd expat-2.6.4
        
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.6.4
make
make check
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.6.4
cd $LFS/sources
rm -rf expat-2.6.4
##Installing Package expect

tar -xvf expect5.45.4.tar.gz
cd expect5.45.4
        
python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
patch -Np1 -i ../expect-5.45.4-gcc14-1.patch
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
make
make test
make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
cd $LFS/sources
rm -rf expect5.45.4
##Installing Package file

tar -xvf file-5.46.tar.gz
cd file-5.46
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf file-5.46
##Installing Package findutils

tar -xvf findutils-4.10.0.tar.xz
cd findutils-4.10.0
        
./configure --prefix=/usr --localstatedir=/var/lib/locate
make
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
cd $LFS/sources
rm -rf findutils-4.10.0
##Installing Package flex

tar -xvf flex-2.6.4.tar.gz
cd flex-2.6.4
        
./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make
make check
make install
ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1
cd $LFS/sources
rm -rf flex-2.6.4
##Installing Package flit-core

tar -xvf flit_core-3.11.0.tar.gz
cd flit_core-3.11.0
        
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist flit_core
cd $LFS/sources
rm -rf flit_core-3.11.0
##Installing Package gawk

tar -xvf gawk-5.3.1.tar.xz
cd gawk-5.3.1
        
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
chown -R tester .
su tester -c "PATH=$PATH make check"
rm -f /usr/bin/gawk-5.3.1
make install
ln -sv gawk.1 /usr/share/man/man1/awk.1
install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.1
cd $LFS/sources
rm -rf gawk-5.3.1
##Installing Package gcc

tar -xvf gcc-14.2.0.tar.xz
cd gcc-14.2.0
        
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
mkdir -v build
cd       build
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib
make
ulimit -s -H unlimited
sed -e '/cpython/d'               -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
sed -e 's/no-pic /&-no-pie /'     -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
sed -e 's/300000/(1|300000)/'     -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
sed -e 's/{ target nonpic } //' \
    -e '/GOTPCREL/d'              -i ../gcc/testsuite/gcc.target/i386/fentryname3.c
chown -R tester .
su tester -c "PATH=$PATH make -k check"
../contrib/test_summary
grep -A7 Summ
make install
chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/14.2.0/include{,-fixed}
ln -svr /usr/bin/cpp /usr/lib
ln -sv gcc.1 /usr/share/man/man1/cc.1
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/14.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
cd $LFS/sources
rm -rf gcc-14.2.0
##Installing Package gdbm

tar -xvf gdbm-1.24.tar.gz
cd gdbm-1.24
        
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make check
make install
cd $LFS/sources
rm -rf gdbm-1.24
##Installing Package gettext

tar -xvf gettext-0.24.tar.xz
cd gettext-0.24
        
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.24
make
make check
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
cd $LFS/sources
rm -rf gettext-0.24
##Installing Package glibc

tar -xvf glibc-2.41.tar.xz
cd glibc-2.41
        
patch -Np1 -i ../glibc-2.41-fhs-1.patch
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=5.4                      \
             --enable-stack-protector=strong          \
             --disable-nscd                           \
             libc_cv_slibdir=/usr/lib
make
make check
grep "Timed out" $(find -name \*.out)
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
rm -f /usr/sbin/nscd
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/*.so.* /usr/lib
DIR=$(dirname $(gcc -print-libgcc-file-name))
[ -e $DIR/include/limits.h ] || mv $DIR/include{-fixed,}/limits.h
[ -e $DIR/include/syslimits.h ] || mv $DIR/include{-fixed,}/syslimits.h
rm -rfv $(dirname $(gcc -print-libgcc-file-name))/include-fixed/*
make install
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
localedef -i C -f UTF-8 C.UTF-8
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f ISO-8859-1 en_GB
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i is_IS -f ISO-8859-1 is_IS
localedef -i is_IS -f UTF-8 is_IS.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f ISO-8859-15 it_IT@euro
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i se_NO -f UTF-8 se_NO.UTF-8
localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
localedef -i zh_TW -f UTF-8 zh_TW.UTF-8
make localedata/install-locales
localedef -i C -f UTF-8 C.UTF-8
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
tar -xf ../../tzdata2025a.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO tz
tzselect
ln -sfv /usr/share/zoneinfo/<xxx> /etc/localtime
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d
cd $LFS/sources
rm -rf glibc-2.41
##Installing Package gmp

tar -xvf gmp-6.3.0.tar.xz
cd gmp-6.3.0
        
ABI=32 ./configure ...
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0
make
make html
make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
make install
make install-html
cd $LFS/sources
rm -rf gmp-6.3.0
##Installing Package gperf

tar -xvf gperf-3.1.tar.gz
cd gperf-3.1
        
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make -j1 check
make install
cd $LFS/sources
rm -rf gperf-3.1
##Installing Package grep

tar -xvf grep-3.11.tar.xz
cd grep-3.11
        
sed -i "s/echo/#echo/" src/egrep.sh
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf grep-3.11
##Installing Package groff

tar -xvf groff-1.23.0.tar.gz
cd groff-1.23.0
        
PAGE=<paper_size> ./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf groff-1.23.0
##Installing Package grub

tar -xvf grub-2.12.tar.xz
cd grub-2.12
        
unset {C,CPP,CXX,LD}FLAGS
echo depends bli part_gpt > grub-core/extra_deps.lst
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
make
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
cd $LFS/sources
rm -rf grub-2.12
##Installing Package gzip

tar -xvf gzip-1.13.tar.xz
cd gzip-1.13
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf gzip-1.13
##Installing Package iana-etc

tar -xvf iana-etc-20250123.tar.gz
cd iana-etc-20250123
        
cp services protocols /etc
cd $LFS/sources
rm -rf iana-etc-20250123
##Installing Package inetutils

tar -xvf inetutils-2.6.tar.xz
cd inetutils-2.6
        
sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c
./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make check
make install
mv -v /usr/{,s}bin/ifconfig
cd $LFS/sources
rm -rf inetutils-2.6
##Installing Package intltool

tar -xvf intltool-0.51.0.tar.gz
cd intltool-0.51.0
        
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make check
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
cd $LFS/sources
rm -rf intltool-0.51.0
##Installing Package iproute2

tar -xvf iproute2-6.13.0.tar.xz
cd iproute2-6.13.0
        
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin install
install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.13.0
cd $LFS/sources
rm -rf iproute2-6.13.0
##Installing Package jinja2

tar -xvf jinja2-3.1.5.tar.gz
cd jinja2-3.1.5
        
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist Jinja2
cd $LFS/sources
rm -rf jinja2-3.1.5
##Installing Package kbd

tar -xvf kbd-2.7.1.tar.xz
cd kbd-2.7.1
        
patch -Np1 -i ../kbd-2.7.1-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make check
make install
cp -R -v docs/doc -T /usr/share/doc/kbd-2.7.1
cd $LFS/sources
rm -rf kbd-2.7.1
##Installing Package kmod

tar -xvf kmod-34.tar.xz
cd kmod-34
        
mkdir -p build
cd       build

meson setup --prefix=/usr ..    \
            --sbindir=/usr/sbin \
            --buildtype=release \
            -D manpages=false
ninja
ninja install
cd $LFS/sources
rm -rf kmod-34
##Installing Package less

tar -xvf less-668.tar.gz
cd less-668
        
./configure --prefix=/usr --sysconfdir=/etc
make
make check
make install
cd $LFS/sources
rm -rf less-668
##Installing Package libcap

tar -xvf libcap-2.73.tar.xz
cd libcap-2.73
        
sed -i '/install -m.*STA/d' libcap/Makefile
make prefix=/usr lib=lib
make test
make prefix=/usr lib=lib install
cd $LFS/sources
rm -rf libcap-2.73
##Installing Package libelf

tar -xvf elfutils-0.192.tar.bz2
cd elfutils-0.192
        
./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
make
make check
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a
cd $LFS/sources
rm -rf elfutils-0.192
##Installing Package libffi

tar -xvf libffi-3.4.7.tar.gz
cd libffi-3.4.7
        
./configure --prefix=/usr          \
            --disable-static       \
            --with-gcc-arch=native
make
make check
make install
cd $LFS/sources
rm -rf libffi-3.4.7
##Installing Package libpipeline

tar -xvf libpipeline-1.5.8.tar.gz
cd libpipeline-1.5.8
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf libpipeline-1.5.8
##Installing Package libtool

tar -xvf libtool-2.5.4.tar.xz
cd libtool-2.5.4
        
./configure --prefix=/usr
make
make check
make install
rm -fv /usr/lib/libltdl.a
cd $LFS/sources
rm -rf libtool-2.5.4
##Installing Package libxcrypt

tar -xvf libxcrypt-4.4.38.tar.xz
cd libxcrypt-4.4.38
        
./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens
make
make check
make install
make distclean
./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=glibc  \
            --disable-static             \
            --disable-failure-tokens
make
cp -av --remove-destination .libs/libcrypt.so.1* /usr/lib
cd $LFS/sources
rm -rf libxcrypt-4.4.38
##Installing Package lz4

tar -xvf lz4-1.10.0.tar.gz
cd lz4-1.10.0
        
make BUILD_STATIC=no PREFIX=/usr
make -j1 check
make BUILD_STATIC=no PREFIX=/usr install
cd $LFS/sources
rm -rf lz4-1.10.0
##Installing Package m4

tar -xvf m4-1.4.19.tar.xz
cd m4-1.4.19
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf m4-1.4.19
##Installing Package make

tar -xvf automake-1.17.tar.xz
cd automake-1.17
        
./configure --prefix=/usr
make
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
cd $LFS/sources
rm -rf automake-1.17
##Installing Package man-db

tar -xvf man-db-2.13.0.tar.xz
cd man-db-2.13.0
        
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.13.0 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
make
make check
make install
cd $LFS/sources
rm -rf man-db-2.13.0
##Installing Package man-pages

tar -xvf man-pages-6.12.tar.xz
cd man-pages-6.12
        
rm -v man3/crypt*
make -R GIT=false prefix=/usr install
cd $LFS/sources
rm -rf man-pages-6.12
##Installing Package markupsafe

tar -xvf markupsafe-3.0.2.tar.gz
cd markupsafe-3.0.2
        
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist Markupsafe
cd $LFS/sources
rm -rf markupsafe-3.0.2
##Installing Package meson

tar -xvf meson-1.7.0.tar.gz
cd meson-1.7.0
        
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
cd $LFS/sources
rm -rf meson-1.7.0
##Installing Package mpc

tar -xvf mpc-1.3.1.tar.gz
cd mpc-1.3.1
        
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1
make
make html
make check
make install
make install-html
cd $LFS/sources
rm -rf mpc-1.3.1
##Installing Package mpfr

tar -xvf mpfr-4.2.1.tar.xz
cd mpfr-4.2.1
        
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.1
make
make html
make check
make install
make install-html
cd $LFS/sources
rm -rf mpfr-4.2.1
##Installing Package ncurses

tar -xvf ncurses-6.5.tar.gz
cd ncurses-6.5
        
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.6.5 /usr/lib
rm -v  dest/usr/lib/libncursesw.so.6.5
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp -av dest/* /
for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
done
ln -sfv libncursesw.so /usr/lib/libcurses.so
cp -v -R doc -T /usr/share/doc/ncurses-6.5
make distclean
./configure --prefix=/usr    \
            --with-shared    \
            --without-normal \
            --without-debug  \
            --without-cxx-binding \
            --with-abi-version=5
make sources libs
cp -av lib/lib*.so.5* /usr/lib
cd $LFS/sources
rm -rf ncurses-6.5
##Installing Package ninja

tar -xvf ninja-1.12.1.tar.gz
cd ninja-1.12.1
        
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
python3 configure.py --bootstrap --verbose
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
cd $LFS/sources
rm -rf ninja-1.12.1
##Installing Package openssl

tar -xvf openssl-3.4.1.tar.gz
cd openssl-3.4.1
        
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
HARNESS_JOBS=$(nproc) make test
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.4.1
cp -vfr doc/* /usr/share/doc/openssl-3.4.1
cd $LFS/sources
rm -rf openssl-3.4.1
##Installing Package patch

tar -xvf patch-2.7.6.tar.xz
cd patch-2.7.6
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf patch-2.7.6
##Installing Package perl

tar -xvf perl-5.40.1.tar.xz
cd perl-5.40.1
        
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des                                          \
             -D prefix=/usr                                \
             -D vendorprefix=/usr                          \
             -D privlib=/usr/lib/perl5/5.40/core_perl      \
             -D archlib=/usr/lib/perl5/5.40/core_perl      \
             -D sitelib=/usr/lib/perl5/5.40/site_perl      \
             -D sitearch=/usr/lib/perl5/5.40/site_perl     \
             -D vendorlib=/usr/lib/perl5/5.40/vendor_perl  \
             -D vendorarch=/usr/lib/perl5/5.40/vendor_perl \
             -D man1dir=/usr/share/man/man1                \
             -D man3dir=/usr/share/man/man3                \
             -D pager="/usr/bin/less -isR"                 \
             -D useshrplib                                 \
             -D usethreads
less
more
make
TEST_JOBS=$(nproc) make test_harness
make install
unset BUILD_ZLIB BUILD_BZIP2
cd $LFS/sources
rm -rf perl-5.40.1
##Installing Package pkgconf

tar -xvf pkgconf-2.3.0.tar.xz
cd pkgconf-2.3.0
        
./configure --prefix=/usr              \
            --disable-static           \
            --docdir=/usr/share/doc/pkgconf-2.3.0
make
make install
ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1
cd $LFS/sources
rm -rf pkgconf-2.3.0
##Installing Package procps-ng

tar -xvf procps-ng-4.0.5.tar.xz
cd procps-ng-4.0.5
        
./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.5 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit
make
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
cd $LFS/sources
rm -rf procps-ng-4.0.5
##Installing Package psmisc

tar -xvf psmisc-23.7.tar.xz
cd psmisc-23.7
        
./configure --prefix=/usr
make
make check
make install
cd $LFS/sources
rm -rf psmisc-23.7
##Installing Package readline

tar -xvf readline-8.2.13.tar.gz
cd readline-8.2.13
        
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.2.13
make SHLIB_LIBS="-lncursesw"
make install
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.2.13
cd $LFS/sources
rm -rf readline-8.2.13
##Installing Package sed

tar -xvf sed-4.9.tar.xz
cd sed-4.9
        
./configure --prefix=/usr
make
make html
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9
cd $LFS/sources
rm -rf sed-4.9
##Installing Package setuptools

tar -xvf setuptools-75.8.1.tar.gz
cd setuptools-75.8.1
        
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist setuptools
cd $LFS/sources
rm -rf setuptools-75.8.1
##Installing Package shadow

tar -xvf shadow-4.17.3.tar.xz
cd shadow-4.17.3
        
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                   \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
    -i etc/login.defs
touch /usr/bin/passwd
./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32
make
make exec_prefix=/usr install
make -C man install-man
pwconv
grpconv
mkdir -p /etc/default
useradd -D --gid 999
sed -i '/MAIL/s/yes/no/' /etc/default/useradd
passwd root
cd $LFS/sources
rm -rf shadow-4.17.3
##Installing Package sysklogd

tar -xvf sysklogd-2.7.0.tar.gz
cd sysklogd-2.7.0
        
./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --runstatedir=/run \
            --without-logger   \
            --disable-static   \
            --docdir=/usr/share/doc/sysklogd-2.7.0
make
make install
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# Do not open any internet ports.
secure_mode 2

# End /etc/syslog.conf
EOF
cd $LFS/sources
rm -rf sysklogd-2.7.0
##Installing Package sysvinit

tar -xvf sysvinit-3.14.tar.xz
cd sysvinit-3.14
        
patch -Np1 -i ../sysvinit-3.14-consolidated-1.patch
make
make install
cd $LFS/sources
rm -rf sysvinit-3.14
##Installing Package tar

tar -xvf acl-2.3.2.tar.xz
cd acl-2.3.2
        
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
make
make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35
cd $LFS/sources
rm -rf acl-2.3.2
##Installing Package tcl

tar -xvf tcl8.6.16-src.tar.gz
cd tcl8.6.16-src
        
SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --disable-rpath
make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.10|/usr/lib/tdbc1.1.10|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10|/usr/include|"            \
    -i pkgs/tdbc1.1.10/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.2|/usr/lib/itcl4.3.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.3.2|/usr/include|"            \
    -i pkgs/itcl4.3.2/itclConfig.sh

unset SRCDIR
make test
make install
chmod -v u+w /usr/lib/libtcl8.6.so
make install-private-headers
ln -sfv tclsh8.6 /usr/bin/tclsh
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3
cd ..
tar -xf ../tcl8.6.16-html.tar.gz --strip-components=1
mkdir -v -p /usr/share/doc/tcl-8.6.16
cp -v -r  ./html/* /usr/share/doc/tcl-8.6.16
cd $LFS/sources
rm -rf tcl8.6.16-src
##Installing Package texinfo

tar -xvf texinfo-7.2.tar.xz
cd texinfo-7.2
        
./configure --prefix=/usr
make
make check
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd
cd $LFS/sources
rm -rf texinfo-7.2
##Installing Package udev

tar -xvf udev-lfs-20230818.tar.xz
cd udev-lfs-20230818
        
sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in
sed -i '/systemd-sysctl/s/^/#/' rules.d/99-systemd.rules.in
sed -e '/NETWORK_DIRS/s/systemd/udev/' \
    -i src/libsystemd/sd-network/network-util.h
mkdir -p build
cd       build

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D mode=release           \
      -D dev-kvm-mode=0660      \
      -D link-udev-shared=false \
      -D logind=false           \
      -D vconsole=false
export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | \
                      awk '{print $3}' | tr -d ",'" | grep -v 'udevadm')
ninja udevadm systemd-hwdb                                           \
      $(ninja -n | grep -Eo '(src/(lib)?udev|rules.d|hwdb.d)/[^ ]*') \
      $(realpath libudev.so --relative-to .)                         \
      $udev_helpers
install -vm755 -d {/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
install -vm755 -d /usr/{lib,share}/pkgconfig
install -vm755 udevadm                             /usr/bin/
install -vm755 systemd-hwdb                        /usr/bin/udev-hwdb
ln      -svfn  ../bin/udevadm                      /usr/sbin/udevd
cp      -av    libudev.so{,*[0-9]}                 /usr/lib/
install -vm644 ../src/libudev/libudev.h            /usr/include/
install -vm644 src/libudev/*.pc                    /usr/lib/pkgconfig/
install -vm644 src/udev/*.pc                       /usr/share/pkgconfig/
install -vm644 ../src/udev/udev.conf               /etc/udev/
install -vm644 rules.d/* ../rules.d/README         /usr/lib/udev/rules.d/
install -vm644 $(find ../rules.d/*.rules \
                      -not -name '*power-switch*') /usr/lib/udev/rules.d/
install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README} /usr/lib/udev/hwdb.d/
install -vm755 $udev_helpers                       /usr/lib/udev
install -vm644 ../network/99-default.link          /usr/lib/udev/network
tar -xvf ../../udev-lfs-20230818.tar.xz
make -f udev-lfs-20230818/Makefile.lfs install
tar -xf ../../systemd-man-pages-257.3.tar.xz                            \
    --no-same-owner --strip-components=1                              \
    -C /usr/share/man --wildcards '*/udev*' '*/libudev*'              \
                                  '*/systemd.link.5'                  \
                                  '*/systemd-'{hwdb,udevd.service}.8

sed 's|systemd/network|udev/network|'                                 \
    /usr/share/man/man5/systemd.link.5                                \
  > /usr/share/man/man5/udev.link.5

sed 's/systemd\(\\\?-\)/udev\1/' /usr/share/man/man8/systemd-hwdb.8   \
                               > /usr/share/man/man8/udev-hwdb.8

sed 's|lib.*udevd|sbin/udevd|'                                        \
    /usr/share/man/man8/systemd-udevd.service.8                       \
  > /usr/share/man/man8/udevd.8

rm /usr/share/man/man*/systemd*
unset udev_helpers
udev-hwdb update
cd $LFS/sources
rm -rf udev-lfs-20230818
##Installing Package util-linux

tar -xvf util-linux-2.40.4.tar.xz
cd util-linux-2.40.4
        
./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            --without-systemd     \
            --without-systemdsystemunitdir        \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.40.4
make
bash tests/run.sh --srcdir=$PWD --builddir=$PWD
touch /etc/fstab
chown -R tester .
su tester -c "make -k check"
make install
cd $LFS/sources
rm -rf util-linux-2.40.4
##Installing Package vim

tar -xvf vim-9.1.1166.tar.gz
cd vim-9.1.1166
        
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
chown -R tester .
sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak
su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" \
   &> vim-test.log
make install
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim91/doc /usr/share/doc/vim-9.1.1166
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
vim -c ':options'
cd $LFS/sources
rm -rf vim-9.1.1166
##Installing Package wheel

tar -xvf wheel-0.45.1.tar.gz
cd wheel-0.45.1
        
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist wheel
cd $LFS/sources
rm -rf wheel-0.45.1
##Installing Package xz

tar -xvf acl-2.3.2.tar.xz
cd acl-2.3.2
        
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.6.4
make
make check
make install
cd $LFS/sources
rm -rf acl-2.3.2
##Installing Package zlib

tar -xvf zlib-1.3.1.tar.gz
cd zlib-1.3.1
        
./configure --prefix=/usr
make
make check
make install
rm -fv /usr/lib/libz.a
cd $LFS/sources
rm -rf zlib-1.3.1
##Installing Package zstd

tar -xvf zstd-1.5.7.tar.gz
cd zstd-1.5.7
        
make prefix=/usr
make check
make prefix=/usr install
rm -v /usr/lib/libzstd.a
cd $LFS/sources
rm -rf zstd-1.5.7