{ me, ... }: { config, lib, options, ... }:

{
  imports = [
    (import ./nvim { inherit me; })
    (import ./wayland { inherit me; })
    (import ./wezterm { inherit me; })
    (import ./firefox.nix { inherit me; })
    (import ./git.nix { inherit me; })
    (import ./gpg.nix { inherit me; })
    (import ./gtk.nix { inherit me; })
    (import ./shell.nix { inherit me; })
    (import ./ssh.nix { inherit me; })
    (import ./xdg.nix { inherit me; })
    (import ./zathura.nix { inherit me; })
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
          name = mkOption {
            type = types.str;
            example = "Bibata-Original-Ice";
            description = ''
              Name of cursor to use
            '';
          };
          package = mkOption {
            type = types.package;
            example = literalExpression "pkgs.bibata-cursors";
            description = ''
              Package containing cursor to use
            '';
          };
        };
        fonts = {
          emoji = {
            name = mkOption {
              type = types.str;
              example = "Twitter Color Emoji";
              description = ''
                Name of emoji font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.twitter-color-emoji";
              description = ''
                Package containing emoji font to use
              '';
            };
          };
          icons = {
            name = mkOption {
              type = types.str;
              example = "Font Awesome 6 Free Solid";
              description = ''
                Name of icon font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.font-awesome";
              description = ''
                Package containing icon font to use
              '';
            };
          };
          monospace = {
            name = mkOption {
              type = types.str;
              example = "Iosevka";
              description = ''
                Name of monospace font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.iosevka";
              description = ''
                Package containing monospace font to use
              '';
            };
          };
          sans-serif = {
            name = mkOption {
              type = types.str;
              example = "Roboto";
              description = ''
                Name of san-serif font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.roboto";
              description = ''
                Package containing sans-serif font to use
              '';
            };
          };
          serif = {
            name = mkOption {
              type = types.str;
              example = "Noto Serif";
              description = ''
                Name of san-serif font to use
              '';
            };
            package = mkOption {
              type = types.package;
              example = literalExpression "pkgs.noto-fonts";
              description = ''
                Package containing sans-serif font to use
              '';
            };
          };
        };
        icons = {
          name = mkOption {
            type = types.str;
            example = "Papirus-Dark";
            description = ''
              Name of icon theme to use
            '';
          };
          package = mkOption {
            type = types.package;
            example = literalExpression "pkgs.papirus-icon-theme";
            description = ''
              Package containing icon theme to use
            '';
          };
        };
        wallpaper = {
          mode = mkOption {
            type = types.enum [ "center" "fill" "fit" "stretch" ];
            example = "";
            description = ''
              Mode to set wallpaper with
            '';
          };
          source = mkOption {
            type = types.path;
            example = literalExpression "./wallpapers/waves.jpg";
            description = ''
              Path to wallpaper
            '';
          };
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
      home-manager.users.${me} = { ... }: {
        fonts.fontconfig.enable = true;
        home = {
          packages = [
            cfg.theme.cursor.package
            cfg.theme.fonts.emoji.package
            cfg.theme.fonts.icons.package
            cfg.theme.fonts.monospace.package
            cfg.theme.fonts.sans-serif.package
            cfg.theme.fonts.serif.package
            cfg.theme.icons.package
          ] ++ cfg.extraPkgs;
          stateVersion = "22.05";
        };
        xdg.configFile."fontconfig/conf.d/20-default-fonts.conf".text =
          let
            inherit (cfg.theme) fonts;
          in
          ''
            <?xml version='1.0'?>
            <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
            <fontconfig>
              <alias>
                <family>emoji</family>
                <prefer><family>${fonts.emoji.name}</family></prefer>
              </alias>
              <alias>
                <family>monospace</family>
                <prefer><family>${fonts.monospace.name}</family></prefer>
              </alias>
              <alias>
                <family>sans-serif</family>
                <prefer><family>${fonts.sans-serif.name}</family></prefer>
              </alias>
              <alias>
                <family>serif</family>
                <prefer><family>${fonts.serif.name}</family></prefer>
              </alias>
            </fontconfig>
          '';
      };

      users.users.${me} = cfg.userConfig;
    };
}
