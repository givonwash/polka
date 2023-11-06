{ lib, ... }:

rec {
  pow = base: exp:
    let
      inherit (lib.lists) foldl replicate;
    in
    if exp == 0 then
      1
    else
      foldl (l: r: l * r) 1 (replicate exp base);
  parseInt = s: base:
    let
      inherit (builtins) substring;
      inherit (lib.lists) findFirst foldl imap0 reverseList;
      inherit (lib.strings) stringToCharacters;
      digits = stringToCharacters (substring 0 base "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ");
      digits' = imap0 (i: d: { pos = i; digit = d; }) digits;
      collected = stringToCharacters s;
      translated = map
        (d: (findFirst (d': d'.digit == d) null digits').pos)
        collected;
      result = foldl (l: r: l + r) 0 (imap0 (i: t: t * (pow base i)) (reverseList translated));
    in
    if result > 0 then
      result
    else
      null;
}
