cardano-cli query ledger-state \
    --mainnet \
    --allegra-era \
    --out-file ledger.json

sigmaValue=$(python3 getSigma.py --pool-id $(cat "${NODE_HOME}/stakepoolid.txt") | tail -n 1 | awk '{ print $2 }')
echo Sigma: ${sigmaValue}

python3 leaderLogs.py --pool-id $(cat "${NODE_HOME}/stakepoolid.txt") \
    --sigma "${sigmaValue}" \
    --vrf-skey "${NODE_HOME}/vrf.skey" \
    --tz "Europe/Berlin"