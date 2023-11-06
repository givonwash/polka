{ polkaUtils, ... }:

let
  inherit (builtins) isInt toString substring;
  inherit (polkaUtils.int) parseInt;
in
{
  fromHexIntoRGBA = hex: alpha:
    let
      red = toString (parseInt (substring 1 2 hex) 16);
      green = toString (parseInt (substring 3 2 hex) 16);
      blue = toString (parseInt (substring 5 2 hex) 16);
      alpha' =
        if isInt alpha then
          toString alpha
        else
          alpha;
    in
    "rgba(${red}, ${blue}, ${green}, ${alpha'})";
}
