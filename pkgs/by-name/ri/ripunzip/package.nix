{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, darwin
, pkg-config
, testers
, fetchzip
, ripunzip
}:

rustPlatform.buildRustPackage rec {
  pname = "ripunzip";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "ripunzip";
    rev = "v${version}";
    hash = "sha256-9aBAksX4h8DlHTl95xd2QvFi3ZV/6i69b68OFa4B1Ew=";
  };

  cargoHash = "sha256-QyVhEHm1W4kb5b4dngBui3lT7vKBGDS5ZObMWua96KM=";

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ Security SystemConfiguration ]);
  nativeBuildInputs = [ pkg-config ];

  setupHook = ./setup-hook.sh;

  passthru.tests = {
    fetchzipWithRipunzip = testers.invalidateFetcherByDrvHash (fetchzip.override { unzip = ripunzip; }) {
      url = "https://github.com/google/ripunzip/archive/cb9caa3ba4b0e27a85e165be64c40f1f6dfcc085.zip";
      hash = "sha256-BoErC5VL3Vpvkx6xJq6J+eUJrBnjVEdTuSo7zh98Jy4=";
    };
    version = testers.testVersion {
      package = ripunzip;
    };
  };

  meta = with lib; {
    description = "Tool to unzip files in parallel";
    mainProgram = "ripunzip";
    homepage = "https://github.com/google/ripunzip";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = [ maintainers.lesuisse ];
  };
}
