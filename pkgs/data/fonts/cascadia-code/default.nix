{ lib, fetchzip }:
let
  version = "2110.31";
in
fetchzip {
  name = "cascadia-code-${version}";

  url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaCode-${version}.zip";

  sha256 = "sha256-SyPQtmudfogBwASTApl1hSpOPf2PLTSOzhJAJzrQ3Mg=";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal";
    homepage = "https://github.com/microsoft/cascadia-code";
    changelog = "https://github.com/microsoft/cascadia-code/raw/v${version}/FONTLOG.txt";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
