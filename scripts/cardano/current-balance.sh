paymentAddrFile="$NODE_HOME/payment.addr"

echo "=== Find balance ==="
cardano-cli query utxo --address $(cat "$paymentAddrFile") --allegra-era --mainnet >>fullUtxo.out
tail -n +3 fullUtxo.out | sort -k3 -nr >balance.out

total_balance=0
while read -r utxo; do
    in_addr=$(awk '{ print $1 }' <<<"${utxo}")
    idx=$(awk '{ print $2 }' <<<"${utxo}")
    utxo_balance=$(awk '{ print $3 }' <<<"${utxo}")
    total_balance=$((total_balance+utxo_balance))
    #echo TxHash: ${in_addr}#${idx}
    #echo ADA: ${utxo_balance}
done < balance.out
txcnt=$(cat balance.out | wc -l)
echo Total ADA balance: ${total_balance}
echo Number of UTXOs: ${txcnt}

rm fullUtxo.out balance.out