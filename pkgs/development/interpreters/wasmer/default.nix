{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, llvmPackages
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = version;
    sha256 = "sha256-8aNJDu3MuXWcPp/nW1ly9+82YSfiMWc75Q4nQD6eUaA=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-l/Se0ijSX5zkAoedorsJvj5EhCuwgI4jE+S8lHZh6+4=";

  nativeBuildInputs = [ cmake pkg-config ];

  # cranelift+jit works everywhere, see:
  # https://github.com/wasmerio/wasmer/blob/master/Makefile#L22
  buildFeatures = [ "cranelift" "jit" ];
  cargoBuildFlags = [
    # must target manifest and desired output bin, otherwise output is empty
    "--manifest-path" "lib/cli/Cargo.toml"
    "--bin" "wasmer"
  ];

  # Can't use test-jit:
  # error: Package `wasmer-workspace v2.1.0 (/build/source)` does not have the feature `test-jit`
  checkFeatures = [ "test-cranelift" ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  meta = with lib; {
    description = "The Universal WebAssembly Runtime";
    longDescription = ''
      Wasmer is a standalone WebAssembly runtime for running WebAssembly outside
      of the browser, supporting WASI and Emscripten. Wasmer can be used
      standalone (via the CLI) and embedded in different languages, running in
      x86 and ARM devices.
    '';
    homepage = "https://wasmer.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne shamilton ];
  };
}
