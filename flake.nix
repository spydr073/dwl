{
  description = "Flake provides DWL package and dev environment.";

  inputs = {

    nixpkgs = {
      #url = "github:NixOS/nixpkgs/22.11";
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    utils = {
      url = "github:numtide/flake-utils";
    };

  };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.utils.lib.eachSystem [
      "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin"
    ] (system:

      let

        overlay = final: prev: {

          libglvnd = prev.libglvnd.overrideAttrs (old: {
            version = "1.6.0";
            #version = "0.5.0";
          });
                
          wlroots = prev.wlroots.overrideAttrs (old: {
            version = "0.16.2";
            #version = "0.15.1";
            #version = "0.14";
          });
          
          wayland-protocols = prev.wayland-protocols.overrideAttrs (old: {
            version = "1.31";
            #version = "1.25";
          });

          #dwl = prev.dwl.overrideAttrs (old: {
          #  #version = "0.4";
          #  #version = "0.3.1";
          #  src = builtins.fetchGit {
          #    url = "https://github.com/spydr073/dwl.git";
          #    ref = "custom";
          #  #  #url = "https://github.com/djpohly/dwl.git";
          #  #  #ref = "refs/tags/v0.4";
          #  };
          #  enable-xwayland = true;
          #  buildInputs = [ pkgs.libglvnd pkgs.xorg.xcbutilwm ] ++ old.buildInputs;
          #});

        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };

        #dwl = (
        #  import nixpkgs {
        #    inherit system;
        #    overlays = [ overlay ];
        #  }).dwl;

      in {
    
        overlays.default = overlay;
      
        #packages.default = pkgs.dwl; 
        packages.default = pkgs.stdenv.mkDerivation rec {
            pname   = "dwl";
            version = "0.3.1";
          
            src = pkgs.fetchFromGitHub {
              owner = "spydr073";
              repo  = "dwl";
              rev   = "custom-0.3.1";
              #hash  = "sha256-DxmhwBA5IgjghBG11+NLho2pTAn7oFHTg+SOZqi+NdE=";
              #owner = "djpohly";
              #repo  = pname;
              #rev   = "v${version}";
              #hash  = "sha256-VHxBjjnzJNmtJxrm3ywJzvt2bNHGk/Cx8TICw6SaoiQ=";
            };
          
            nativeBuildInputs = with pkgs; [ pkg-config ];
          
            buildInputs = with pkgs; [
              libinput
              xorg.libxcb
              libxkbcommon
              pixman
              wayland
              wayland-protocols
              wlroots
            #] ++ lib.optionals enable-xwayland [
              xorg.libX11
              xwayland
            ];
          
            NIX_CFLAGS_COMPILE = [
              # https://github.com/djpohly/dwl/issues/186
              "-Wno-error=unused-result"
            ];
          
            dontConfigure = true;
          
            installPhase = ''
              runHook preInstall
              install -d $out/bin
              install -m755 dwl $out/bin
              runHook postInstall
            '';
          
            meta = with pkgs.lib; {
              homepage = "https://github.com/djpohly/dwl/";
              description = "Dynamic window manager for Wayland";
              longDescription = ''
                dwl is a compact, hackable compositor for Wayland based on wlroots. It is
                intended to fill the same space in the Wayland world that dwm does in X11,
                primarily in terms of philosophy, and secondarily in terms of
                functionality. Like dwm, dwl is:
                - Easy to understand, hack on, and extend with patches
                - One C source file (or a very small number) configurable via config.h
                - Limited to 2000 SLOC to promote hackability
                - Tied to as few external dependencies as possible
              '';
              license = licenses.gpl3Only;
              maintainers = with maintainers; [ AndersonTorres ];
              inherit (pkgs.wayland.meta) platforms;
            };
          };  

        devShell = pkgs.mkShell {
          name = "dwl-env";
          
          packages = with pkgs; [
            bashInteractive
            gcc
            libinput
            libxkbcommon
            wlroots
            wayland-protocols
            xorg.libxcb
            pixman
            wayland
            xorg.libX11
            xwayland
          ];
        };

      });
}
