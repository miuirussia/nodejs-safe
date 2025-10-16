{
  description = "nodejs-safe";

  inputs = {
    nixpkgs.url = "github:miuirussia/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
