cd "$HOME/git"
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --recurse-submodules --tags
git checkout tags/1.24.2

cabal configure -O0 -w ghc-8.10.2

echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" > cabal.project.local
sed -i "$HOME/.cabal/config" -e "s/overwrite-policy:/overwrite-policy: always/g"
rm -rf "$HOME/git/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.10.2"

cabal build cardano-cli cardano-node

sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-cli") "/usr/local/bin/cardano-cli"
sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-node") "/usr/local/bin/cardano-node"

cardano-node version
cardano-cli version