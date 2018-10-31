{ stdenv, fetchFromGitHub, fetchpatch, kernel, bc }:

stdenv.mkDerivation rec {
  name = "rtl8821au-${kernel.version}-${version}";
  version = "5.2.20_25672.20171213";

  src = fetchFromGitHub {
    owner = "abperiasamy";
    repo = "rtl8812AU_8821AU_linux";
    rev = "bed205c14a363fedd8b3a497ef0141588b610d50";
    sha256 = "1hlnk6nkgamf2ad2q05vssl9n2z5kzm8ppc3wc0iwwx5m31mff8h";
  };

  nativeBuildInputs = [ bc ];
  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" "format" ];

  prePatch = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
    substituteInPlace ./Makefile --replace /sbin/depmod \#
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = with stdenv.lib; {
    description = "Driver for Realtek 802.11ac, rtl8821au, provides the 8821au mod";
    homepage = https://github.com/zebulon2/rtl8812au-driver-5.2.20;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ danielfullmer ];
  };
}
