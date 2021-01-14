WORKDIR="$HOME/work"
[! -d $WORKDIR ] && mkdir $WORKDIR

POOL_CERT="$NODE_HOME/pool.cert"
DELEG_CERT="$NODE_HOME/deleg.cert"
PARAMS="$NODE_HOME/params.json"

PAYMENT_ADDR=$(cat "$NODE_HOME/payment.addr")
BALANCE_OUT="$WORKDIR/balance.out"
FULL_UTXO_OUT="$WORKDIR/fullUtxo.out"
TX_TMP="$WORKDIR/tx.tmp"
TX_RAW="$WORKDIR/tx.raw"

echo "Find current slot"
currentSlot=$(cardano-cli query tip --mainnet | jq -r '.slotNo')
echo Current Slot: $currentSlot
echo "====================="
echo "Find balance"
cardano-cli query utxo \
    --address $PAYMENT_ADDR \
    --allegra-era \
    --mainnet > "$FULL_UTXO_OUT"

tail -n +3 "$FULL_UTXO_OUT" | sort -k3 -nr > "$BALANCE_OUT"

cat balance.out

tx_in=""
total_balance=0
while read -r utxo; do
    in_addr=$(awk '{ print $1 }' <<< "${utxo}")
    idx=$(awk '{ print $2 }' <<< "${utxo}")
    utxo_balance=$(awk '{ print $3 }' <<< "${utxo}")
    total_balance=$((${total_balance}+${utxo_balance}))
    tx_in="${tx_in} --tx-in ${in_addr}#${idx}"
done < "$BALANCE_OUT"
txcnt=$(cat "$BALANCE_OUT" | wc -l)
echo Total ADA balance: ${total_balance}
echo Number of UTXOs: ${txcnt}

echo "====================="
echo "Build raw transaction"
cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $PAYMENT_ADDR+${total_balance} \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee 0 \
    --certificate-file "$POOL_CERT" \
    --certificate-file "$DELEG_CERT" \
    --allegra-era \
    --out-file "$TX_TMP"

echo "====================="
echo "Calculate minimum fee"
fee=$(cardano-cli transaction calculate-min-fee \
    --tx-body-file "$TX_TMP" \
    --tx-in-count ${txcnt} \
    --tx-out-count 1 \
    --mainnet \
    --witness-count 3 \
    --byron-witness-count 0 \
    --protocol-params-file "$PARAMS" | awk '{ print $1 }')
echo fee: $fee

echo "====================="
echo "Calculate change output"
txOut=$((${total_balance}-${fee}))
echo txOut: ${txOut}
echo "====================="
echo "Build transaction"
cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $PAYMENT_ADDR+${txOut} \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee ${fee} \
    --certificate-file "$POOL_CERT" \
    --certificate-file "$DELEG_CERT" \
    --allegra-era \
    --out-file "$TX_RAW"

echo "====================="
echo "Delete unneeded files"
[ -f $BALANCE_OUT ] && rm $BALANCE_OUT
[ -f $FULL_UTXO_OUT ] && rm $FULL_UTXO_OUT
[ -f $TX_TMP ] && rm $TX_TMP

echo "====================="
echo "Copy '$TX_RAW' to cold environment to sign the transaction"