# Enabled all modules, except perl, ndb, sql.
# See https://github.com/NixOS/nixpkgs/commit/8e319c5ddac707fb4cb3315f9eadea9a70fc8c84
{ stdenv, fetchurl, openssl, cyrus_sasl, db, groff, libtool }:

stdenv.mkDerivation rec {
  name = "openldap-modular-2.4.44";

  src = fetchurl {
    url = "http://www.openldap.org/software/download/OpenLDAP/openldap-release/${name}.tgz";
    sha256 = "0044p20hx07fwgw2mbwj1fkx04615hhs1qyx4mawj2bhqvrnppnp";
  };

  # TODO: separate "out" and "bin"
  outputs = [ "out" "dev" "man" "devdoc" ];

  enableParallelBuilding = true;

  buildInputs = [ openssl cyrus_sasl db groff libtool ];

  configureFlags =
    [
      "--disable-dependency-tracking"   # speeds up one-time build
      "--disable-ndb"
      "--disable-perl"
      "--disable-sql"
      "--enable-backends=mod"
      "--enable-modules"
      "--enable-overlays=mod"
    ] ++ stdenv.lib.optional (openssl == null) "--without-tls"
      ++ stdenv.lib.optional (cyrus_sasl == null) "--without-cyrus-sasl"
      ++ stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  # 1. Fixup broken libtool
  # 2. Libraries left in the build location confuse `patchelf --shrink-rpath`
  #    Delete these to let patchelf discover the right path instead.
  #    FIXME: that one can be removed when https://github.com/NixOS/patchelf/pull/98
  #    is in Nixpkgs patchelf.
  preFixup = ''
    sed -e 's,-lsasl2,-L${cyrus_sasl.out}/lib -lsasl2,' \
        -e 's,-lssl,-L${openssl.out}/lib -lssl,' \
        -i $out/lib/libldap.la -i $out/lib/libldap_r.la

    rm -rf $out/var
    rm -r libraries/*/.libs
  '';

  postInstall = ''
    chmod +x "$out"/lib/*.{so,dylib}
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.openldap.org/;
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    maintainers = with maintainers; [ lovek323 mornfall ];
    platforms   = platforms.unix;
  };
}
