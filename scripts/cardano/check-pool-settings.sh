cardano-cli query ledger-state \
    --mainnet \
    --allegra-era \
    --out-file ledger-state.json
$STAKE_POOL_ID=$(cat "$NODE_HOME/stakepoolid.txt")
jq -r '.esLState._delegationState._pstate._pParams."'"$STAKE_POOL_ID"'"  // empty' ledger-state.json
rm ledger-state.json