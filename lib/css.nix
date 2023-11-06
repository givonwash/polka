{ lib, ... }:

{
  mkGtkColors =
    let
      inherit (builtins) concatStringsSep isList toString substring;
      inherit (lib) attrsets lists;
    in
    colors: (
      concatStringsSep "\n"
        (lists.flatten
          (attrsets.mapAttrsToList
            (color: value:
              if isList value then
                lists.imap0 (i: val: "@define-color ${color}-${toString i} ${val};") value
              else
                [ "@define-color ${color} ${value};" ])
            (colors)))
    );
}
