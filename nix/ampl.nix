{ lib
, stdenv
, autoPatchelfHook
}:

stdenv.mkDerivation {
  pname = "ampl";
  version = "2022-08-21";

  buildInputs = [ stdenv.cc.cc autoPatchelfHook ];

  src = ./ampl_linux-intel64;

  unpackPhase = ''
    runHook preUnpack

    cp $src/* .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp ampl cplex gurobi $out/bin
    cp lib* $out/lib

    runHook postInstall
  '';
}
