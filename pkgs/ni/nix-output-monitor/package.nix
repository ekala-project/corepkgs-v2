{
  package,
  pkgs,
  buildPkgs,
}:
package {
  name = "nix-output-monitor";
  uses = [ "cabal" ];
  cabal.exes = [ "nom" ];
  buildDependencies = [
    buildPkgs.libarchive # for bsdtar in hermes-include phase
  ];
  # nom --version execs nix, and nom build/shell/develop wrap nix/nix-shell:
  # as a runtime dependency its bin/ lands on the launcher's PATH, which is
  # also what makes the version check pass in its empty environment
  dependencies = [ pkgs.nix ];
  # hermes-json vendors simdjson whose amalgamation drops every <iterator>
  # include as editor-only: libstdc++ provides it transitively, libc++ does
  # not, so std::inserter fails to compile. Prefer a patched unpack as a
  # local package; hackage revisions cannot change sources.
  # TODO: patch this globally instead
  phases.before."cabal.build" = {
    name = "hermes-include";
    run = ''
      let deps = ((options cabal) | get deps)
      let pkg = (ls $"($deps)/hermes-json-*.tar.gz" | get name | first | path basename | str replace ".tar.gz" "")
      mkdir patched
      ^bsdtar -xf $"($deps)/($pkg).tar.gz" -C patched
      let header = $"patched/($pkg)/simdjson/singleheader/simdjson.h"
      "#include <iterator>\n" + (open --raw $header) | save -f $header
      $"packages: patched/($pkg)\n" | save --append cabal.project.local
    '';
  };
  bin = [ "nom" ];
  # test suites need HUnit/doctest-parallel, outside the dependency-only freeze
  # TODO: add them to lockfile automatically too
  tests.run = false;
  # TODO: set version manually cause its unstable
  tests.version = false;
  links = {
    "bin/nom-build" = "nom";
    "bin/nom-shell" = "nom";
  };
  # TODO: make this automatic
  completions = {
    bash = [
      "nix-output-monitor/completions/nom.bash"
      "nix-output-monitor/completions/nom-build.bash"
      "nix-output-monitor/completions/nom-shell.bash"
    ];
    zsh = [
      "nix-output-monitor/completions/nom.zsh"
      "nix-output-monitor/completions/nom-build.zsh"
      "nix-output-monitor/completions/nom-shell.zsh"
    ];
    fish = [ "nix-output-monitor/completions/nom.fish" ];
    nu = [ ./nom-completions.nu ];
  };
}
