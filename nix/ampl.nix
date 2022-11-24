{ lib
, stdenv
, autoPatchelfHook
}:

stdenv.mkDerivation {
  pname = "ampl";
  version = "2022-08-21";

  buildInputs = [ autoPatchelfHook ];

  src = ./ampl;

  unpackPhase = ''
    runHook preUnpack

    cp $src ampl

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ampl $out/bin

    runHook postInstall
  '';
}
