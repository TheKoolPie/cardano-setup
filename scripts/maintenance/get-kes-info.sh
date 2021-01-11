pushd +1
slotsPerKESPeriod=$(cat $NODE_HOME/${NODE_CONFIG}-shelley-genesis.json | jq -r '.slotsPerKESPeriod')
slotNo=$(cardano-cli query tip --mainnet | jq -r '.slotNo')
kesPeriod=$((${slotNo} / ${slotsPerKESPeriod}))

echo slotsPerKESPeriod: ${slotsPerKESPeriod}
echo slotNo: ${slotNo}
echo kesPeriod: ${kesPeriod}
startKesPeriod=${kesPeriod}
echo startKesPeriod: ${startKesPeriod}