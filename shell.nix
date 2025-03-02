with import <nixpkgs> {}; mkShell {
  packages = [odin];

  shellHook = ''
    echo -n "+$(odin root)" > .dumbjump
  '';
}
