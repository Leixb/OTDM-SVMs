{ lib
, stdenv
, autoPatchelfHook
}:

stdenv.mkDerivation {
  name = "gensvmdat";

  buildInputs = [ autoPatchelfHook ];

  src = ./gensvmdat;

  unpackPhase = ''
    runHook preUnpack

    cp $src gensvmdat

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp gensvmdat $out/bin

    runHook postInstall
  '';
}
