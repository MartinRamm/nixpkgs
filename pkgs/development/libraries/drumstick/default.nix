{ lib, stdenv, fetchurl
, cmake, docbook_xml_dtd_45, docbook_xsl, doxygen, graphviz-nox, pkg-config, qttools, wrapQtAppsHook
, alsa-lib, fluidsynth, qtbase, qtsvg, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "drumstick";
  version = "2.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-Yb5SrXJ5ZK0IJ8XbnxAGLlfqKGOrfv2VET9Ba8dKItU=";
  };

  patches = [
    ./drumstick-plugins.patch
  ];

  postPatch = ''
    substituteInPlace library/rt/backendmanager.cpp --subst-var out

    # https://sourceforge.net/p/drumstick/bugs/39/
    substituteInPlace drumstick-alsa.pc.in drumstick-file.pc.in drumstick-rt.pc.in drumstick-widgets.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [
    cmake docbook_xml_dtd_45 docbook_xml_dtd_45 docbook_xsl doxygen graphviz-nox pkg-config qttools wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib fluidsynth libpulseaudio qtbase qtsvg
  ];

  cmakeFlags = [
    "-DUSE_DBUS=ON"
  ];

  meta = with lib; {
    maintainers = [];
    description = "MIDI libraries for Qt5/C++";
    homepage = "https://drumstick.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
