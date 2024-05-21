{ config, lib, pkgs, ... }:

{
  imports = [
    ./nvim
    ./wayland
    ./wezterm
    ./firefox.nix
    ./foliate.nix
    ./git.nix
    ./gpg.nix
    ./shell.nix
    ./ssh.nix
    ./xdg.nix
    ./zathura.nix
  ];

  options._.givon =
    let
      inherit (builtins) length listToAttrs;
      inherit (lib) lists literalExpression mkEnableOption mkOption types;

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
          enable = mkEnableOption "cursor";
          name = mkOption rec {
            type = types.str;
            example = default;
            default = "Bibata-Original-Ice";
            description = ''
              Name of cursor to use
            '';
          };
          size = mkOption rec {
            type = types.ints.positive;
            example = default;
            default = 24;
            description = ''
              Size of cursor
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
          defaultScalingFactor = mkOption rec {
            type = types.float;
            example = 1.0;
            default = example;
            description = ''
              Default "text scaling factor" to use
            '';
          };
          defaultSize = mkOption rec {
            type = types.ints.positive;
            example = 13;
            default = example;
            description = ''
              Default size of font
            '';
          };
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
              type = with types; nullOr package;
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
              default = "Iosevka";
              description = ''
                Name of monospace font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.iosevka";
              default = pkgs.iosevka-bin;
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
                variant = "Aile";
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
                variant = "Etoile";
              };
              description = ''
                Package containing sans-serif font to use
              '';
            };
          };
        };
        gtkTheme = {
          enable = mkEnableOption "gtkTheme";
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
          enable = mkEnableOption "icons";
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
        default = [ ];
        description = ''
          Extra packages to include for user
        '';
      };
      stateVersion = mkOption rec {
        type = types.str;
        example = default;
        default = "23.11";
        description = ''
          home-manager `stateVersion` for user
        '';
      };
      userConfig = mkOption {
        type = with types; attrsOf anything;
        example = {
          extraGroups = [ "wheel" ];
          uid = 1234;
        };
        default = { };
        description = ''
          Submodule to pass to user
        '';
      };
    };

  config =
    let
      inherit (config._.givon.userConfig) name;
      cfg = config._.givon;
      inherit (cfg) theme;
    in
    {
      home-manager.users.${name} = {
        fonts.fontconfig.enable = true;
        gtk = lib.mkIf theme.gtkTheme.enable {
          enable = true;
          cursorTheme = lib.mkIf theme.cursor.enable {
            name = theme.cursor.name;
            package = theme.cursor.package;
            size = theme.cursor.size;
          };
          font = {
            name = theme.fonts.sans-serif.name;
            package = theme.fonts.sans-serif.package;
            size = theme.fonts.defaultSize;
          };
          iconTheme = lib.mkIf theme.icons.enable {
            name = theme.icons.name;
            package = theme.icons.package;
          };
          theme = {
            name = theme.gtkTheme.name;
            package = theme.gtkTheme.package;
          };
        };
        home = {
          packages = [
            theme.fonts.icons.package
            theme.fonts.monospace.package
            theme.fonts.sans-serif.package
            theme.fonts.serif.package
          ]
          ++ lib.optional (theme.fonts.emoji.package != null) theme.fonts.emoji.package
          ++ lib.optional theme.cursor.enable theme.cursor.package
          ++ lib.optional theme.gtkTheme.enable theme.gtkTheme.package
          ++ lib.optional theme.icons.enable theme.icons.package
          ++ config._.givon.extraPkgs;
          pointerCursor = lib.mkIf (theme.cursor.enable) {
            inherit (theme.cursor) name package size;
          };
          stateVersion = cfg.stateVersion;
        };
        xdg.configFile."fontconfig/fonts.conf".text =
          let
            inherit (theme) fonts;
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
    };
}
