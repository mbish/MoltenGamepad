{
  description = "Flake for moltengamepad";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
      ];
    };
    moltengamepad = pkgs.stdenv.mkDerivation {
      name = "moltengamepad";
      src = ./.;

      hardeningDisable = ["format"];

      buildInputs = [pkgs.udev pkgs.go-md2man];

      buildPhase = ''
        (cd source/core/eventlists && ./generate_key_codes ${pkgs.linuxHeaders}/include/linux/input-event-codes.h);
        make
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp moltengamepad $out/bin
      '';

      meta = with pkgs.lib; {
        homepage = "https://github.com/jgeumlek/MoltenGamepad";
        description = "Flexible Linux input device translator, geared for gamepads";
        license = licenses.mit;
        maintainers = [maintainers.ebzzry];
        platforms = platforms.linux;
      };
    };
  in {
    packages.x86_64-linux.default = moltengamepad;
  };
}
