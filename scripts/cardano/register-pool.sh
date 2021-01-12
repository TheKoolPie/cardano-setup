#!/bin/bash
currentSlot=$(cardano-cli query tip --mainnet | jq -r '.slotNo')
echo "Current Slot: $currentSlot"

paymentAddrFile="$NODE_HOME/payment.addr"

echo "=== Find balance ==="
cardano-cli query utxo \
    --address $(cat "$paymentAddrFile") \
    --allegra-era \
    --mainnet > fullUtxo.out
tail -n +3 fullUtxo.out | sort -k3 -nr > balance.out

tx_in=""
total_balance=0
while read -r utxo; do
    in_addr=$(awk '{ print $1 }' <<<"${utxo}")
    idx=$(awk '{ print $2 }' <<<"${utxo}")
    utxo_balance=$(awk '{ print $3 }' <<<"${utxo}")
    total_balance=$((total_balance+utxo_balance))
    tx_in="${tx_in} --tx-in ${in_addr}#${idx}"
done < balance.out
txcnt=$(cat balance.out | wc -l)
echo Total ADA balance: ${total_balance}
echo Number of UTXOs: ${txcnt}

echo "=== Find pool deposit fee ==="
poolDeposit=$(cat "$NODE_HOME/params.json" | jq -r '.poolDeposit')
echo "poolDeposit: $poolDeposit"

# Registration of a stake address certificate (keyDeposit) costs 2000000 lovelace.
# The invalid-hereafter value must be greater than the current tip. In this example, we use current slot + 10000.

echo "=== Run build-raw transaction cmd ==="
cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat "$paymentAddrFile")+$(( ${total_balance} - ${poolDeposit})) \
    --invalid-hereafter $((${currentSlot} + 10000)) \
    --fee 0 \
    --certificate-file pool.cert \
    --certificate-file deleg.cert \
    --allegra-era \
    --out-file tx.tmp

echo "===Calculate current minimum fee ==="
fee=$(cardano-cli transaction calculate-min-fee \
    --tx-body-file tx.tmp \
    --tx-in-count ${txcnt} \
    --tx-out-count 1 \
    --mainnet \
    --witness-count 3 \
    --byron-witness-count 0 \
    --protocol-params-file "$NODE_HOME/params.json" | awk '{ print $1 }')
echo "Calculated Fee: $fee"

echo "=== Calculate change output ==="
txOut=$((${total_balance} - ${poolDeposit} - ${fee}))
echo "Change Output: ${txOut} "

echo "=== Build transaction for stake address register ==="
cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat "$paymentAddrFile")+${txOut} \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee ${fee} \
    --certificate-file pool.cert \
    --certificate-file deleg.cert \
    --allegra-era \
    --out-file tx.raw
echo "=== Created transaction ==="
cat tx.raw 

rm fullUtxo.out balance.out tx.tmp