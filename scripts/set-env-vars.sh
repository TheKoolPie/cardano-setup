echo PATH="$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" >> "$HOME/.bashrc"
echo export NODE_HOME="$HOME/cardano-my-node" >> "$HOME/.bashrc"
echo export NODE_CONFIG=mainnet>> "$HOME/.bashrc"
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> "$HOME/.bashrc"
source "$HOME/.bashrc"