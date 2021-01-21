read -p "Enter cold keys directory: " COLD_KEY_DIR

[ -z "${COLD_KEY_DIR}" ] && echo "No cold key directory provided" && exit 1
[ ! -d "${COLD_KEY_DIR}" ] && echo "Provided cold key directory does not exist" && exit 1

read -p "Enter start kes period: " START_KES
[ -z "$START_KES" ] && echo "No start kes period provided" && exit 1

NODE_CERT="${HOME}/node.cert"

echo "Change rights on cold key dir"
chmod u+rwx "${COLD_KEY_DIR}"
echo "Issue operational certificate"
cardano-cli node issue-op-cert \
    --kes-verification-key-file kes.vkey \
    --cold-signing-kes-file "${COLD_KEY_DIR}/node.skey" \
    --operational-certificate-issue-counter "${COLD_KEY_DIR}/node.counter" \
    --kes-period "${START_KES}" \
    --out-file "${NODE_CERT}"

echo "Created certificate file at: ${NODE_CERT}"
echo "Change rights on cold key dir"
chmod a-rwx "${COLD_KEY_DIR}"


