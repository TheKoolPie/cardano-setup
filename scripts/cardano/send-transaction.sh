echo "Enter path to signed transaction file (tx.signed): "
read TX_FILE

cardano-cli transaction submit \
    --tx-file $TX_FILE \
    --mainnet