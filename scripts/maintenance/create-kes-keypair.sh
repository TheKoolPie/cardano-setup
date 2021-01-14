
slotsPerKESPeriod=$(cat $NODE_HOME/${NODE_CONFIG}-shelley-genesis.json | jq -r '.slotsPerKESPeriod')
slotNo=$(cardano-cli query tip --mainnet | jq -r '.slotNo')
kesPeriod=$((${slotNo} / ${slotsPerKESPeriod}))

echo slotsPerKESPeriod: ${slotsPerKESPeriod}
echo slotNo: ${slotNo}
echo kesPeriod: ${kesPeriod}
startKesPeriod=${kesPeriod}
echo startKesPeriod: ${startKesPeriod}


cardano-cli node key-gen-KES \
    --verification-key-file "$NODE_HOME/kes.vkey" \
    --signing-key-file "$NODE_HOME/kes.skey"

echo "Copy kes.vkey to cold environment"