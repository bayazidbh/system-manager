{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    sysmgr = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sysmgr }: {
    systemConfigs.default = sysmgr.lib.makeSystemConfig {
      modules = [
        ./default.nix
      ];
    };
  };
}
