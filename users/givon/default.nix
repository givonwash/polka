{ me, utils, ... }: { config, lib, pkgs, ... }:

{
  imports = [
    (import ./nvim { inherit me utils; })
    (import ./wayland { inherit me utils; })
    (import ./wezterm { inherit me utils; })
    (import ./firefox.nix { inherit me utils; })
    (import ./foliate.nix { inherit me utils; })
    (import ./git.nix { inherit me utils; })
    (import ./gpg.nix { inherit me utils; })
    (import ./gtk.nix { inherit me utils; })
    (import ./shell.nix { inherit me utils; })
    (import ./ssh.nix { inherit me utils; })
    (import ./xdg.nix { inherit me utils; })
    (import ./zathura.nix { inherit me utils; })
  ];

  options._.${me} =
    let
      inherit (builtins) length listToAttrs;
      inherit (lib) lists literalExpression mkOption types;

      color_re = "#[0-9a-fA-F]{6}";

      mkSingleColorOption = color: mkOption {
        type = types.strMatching color_re;
        example = "#FFFFFF";
        description = ''
          Color to use for ${color}. Value given should match the regex '${color_re}'
        '';
      };

      mkMultipleColorOption = color: len: mkOption {
        type = with types; addCheck (listOf (strMatching color_re)) (list: length list == len);
        example = [ "#FFFFFF" "#000000" ];
        description = ''
          Colors to use for ${color}. Each entry in the list should match the regex '${color_re}'
          and should be of length ${len}
        '';
      };
    in
    {
      theme = {
        colors = listToAttrs (
          (map (color: { name = color; value = mkSingleColorOption color; }) [
            "blue"
            "flamingo"
            "green"
            "lavender"
            "maroon"
            "mauve"
            "peach"
            "pink"
            "rosewater"
            "red"
            "sky"
            "teal"
            "white"
            "yellow"
          ])
          ++
          (lists.zipListsWith (color: len: { name = color; value = mkMultipleColorOption color len; })
            [ "blacks" "grays" ]
            [ 5 3 ]
          )
        );
        cursor = {
          name = mkOption rec {
            type = types.str;
            example = default;
            default = "Bibata-Original-Ice";
            description = ''
              Name of cursor to use
            '';
          };
          package = mkOption {
            type = types.package;
            example = literalExpression "pkgs.bibata-cursors";
            default = pkgs.bibata-cursors;
            description = ''
              Package containing cursor to use
            '';
          };
        };
        fonts = {
          emoji = {
            name = mkOption rec {
              type = types.str;
              example = default;
              default = "Twitter Color Emoji";
              description = ''
                Name of emoji font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.twitter-color-emoji";
              default = pkgs.twitter-color-emoji;
              description = ''
                Package containing emoji font to use
              '';
            };
          };
          icons = {
            name = mkOption rec {
              type = types.str;
              example = default;
              default = "Font Awesome 6 Free Solid";
              description = ''
                Name of icon font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.font-awesome";
              default = pkgs.font-awesome;
              description = ''
                Package containing icon font to use
              '';
            };
          };
          monospace = {
            name = mkOption rec {
              type = types.str;
              example = default;
              default = "Iosevka Nerd Font";
              description = ''
                Name of monospace font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.iosevka";
              default = pkgs.nerdfonts.override {
                fonts = [ "Iosevka" ];
              };
              description = ''
                Package containing monospace font to use
              '';
            };
          };
          sans-serif = {
            name = mkOption rec {
              type = types.str;
              example = default;
              default = "Iosevka Aile";
              description = ''
                Name of san-serif font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.roboto";
              default = pkgs.iosevka-bin.override {
                variant = "sgr-iosevka-aile";
              };
              description = ''
                Package containing sans-serif font to use
              '';
            };
          };
          serif = {
            name = mkOption rec {
              type = types.str;
              example = default;
              default = "Iosevka Etoile";
              description = ''
                Name of san-serif font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.noto-fonts";
              default = pkgs.iosevka-bin.override {
                variant = "sgr-iosevka-etoile";
              };
              description = ''
                Package containing sans-serif font to use
              '';
            };
          };
        };
        gtkTheme = {
          name = mkOption rec {
            type = types.str;
            example = default;
            default = "Catppuccin-Mocha-Compact-Lavender-Dark";
            description = ''
              Name of GTK theme to use
            '';
          };
          package = mkOption {
            type = types.package;
            example = literalExpression "pkgs.catppuccin-gtk";
            default = pkgs.catppuccin-gtk.override {
              accents = [ "lavender" ];
              size = "compact";
              variant = "mocha";
            };
            description = ''
              Package containing GTK theme to use
            '';
          };
        };
        icons = {
          name = mkOption rec {
            type = types.str;
            example = default;
            default = "Papirus-Dark";
            description = ''
              Name of icon theme to use
            '';
          };
          package = mkOption {
            type = types.package;
            example = literalExpression "pkgs.papirus-icon-theme";
            default = pkgs.papirus-icon-theme;
            description = ''
              Package containing icon theme to use
            '';
          };
        };
        wallpaper = mkOption {
          type = types.path;
          example = literalExpression "./wallpapers/waves.jpg";
          default = ./wallpapers/hearts.png;
          description = ''
            Path to wallpaper
          '';
        };
      };
      extraPkgs = mkOption {
        type = with types; listOf package;
        example = [
          (literalExpression "pkgs.inkscape")
        ];
        description = ''
          Extra packages to include for ${me}
        '';
      };
      userConfig = mkOption {
        type = with types; attrsOf anything;
        example = {
          extraGroups = [ "wheel" ];
          uid = 1234;
        };
        description = ''
          Submodule to pass to config.users.users.${me}
        '';
      };
    };

  config =
    let
      cfg = config._.${me};
    in
    {
      home-manager.users.${me} = {
        fonts.fontconfig.enable = true;
        home = {
          packages = [
            cfg.theme.cursor.package
            cfg.theme.fonts.emoji.package
            cfg.theme.fonts.icons.package
            cfg.theme.fonts.monospace.package
            cfg.theme.fonts.sans-serif.package
            cfg.theme.fonts.serif.package
            cfg.theme.gtkTheme.package
            cfg.theme.icons.package
          ] ++ cfg.extraPkgs;
          stateVersion = "22.05";
        };
        xdg.configFile."fontconfig/fonts.conf".text =
          let
            inherit (cfg.theme) fonts;
          in
          ''
            <?xml version='1.0'?>
            <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
            <fontconfig>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>ui-emoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.emoji.name}</string></edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>emoji</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.emoji.name}</string></edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>ui-monospace</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.monospace.name}</string></edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>monospace</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.monospace.name}</string></edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>ui-sans-serif</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.sans-serif.name}</string></edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>sans-serif</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.sans-serif.name}</string></edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>ui-serif</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.serif.name}</string></edit>
              </match>
              <match target="pattern">
                <test qual="any" name="family" compare="eq"><string>serif</string></test>
                <edit name="family" mode="assign" binding="same"><string>${fonts.serif.name}</string></edit>
              </match>
            </fontconfig>
          '';
      };

      users.users.${me} = cfg.userConfig;
    };
}
