{ buildPythonPackage
, fetchPypi
, numpy
, scipy
}:

buildPythonPackage rec {

  pname = "lws";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07p25nb596wsm7vyx5f14ffsh9kw6zrq8vwlza9smfj0lm5bvkhk";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];
}
