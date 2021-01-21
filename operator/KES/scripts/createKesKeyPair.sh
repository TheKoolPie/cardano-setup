read -p "Enter key target directory: " KEY_DIR

[ -z "${COLD_KEY_DIR}" ] && echo "No key directory provided" && exit 1
[ ! -d "${COLD_KEY_DIR}" ] && mkdir "${KEY_DIR}"

shelley_genesis="${NODE_HOME}/${NODE_CONFIG}-shelley-genesis.json"

echo "Find starting KES period"
slotNo=$(cardano-cli query tip --mainnet | jq -r '.slotNo')
slotsPerKESPeriod=$(cat "${shelley_genesis}" | jq -r '.slotsPerKESPeriod')
kesPeriod=$((${slotNo} / ${slotsPerKESPeriod}))
startKesPeriod=${kesPeriod}
echo startKesPeriod: ${startKesPeriod}

VKEY="${KEY_DIR}/kes.vkey"
SKEY="${KEY_DIR}/skey"

echo "Create new KES Key pair"
cardano-cli node key-gen-KES \
    --verification-key-file "${VKEY}" \
    --signing-key-file "${SKEY}"

echo "Created key file in: ${KEY_DIR}"
ls ${KEY_DIR}
