# setup env variable
export QUERY_HOST=http://localhost:3030
export BROADCAST_ENDPOINT=http://localhost:3030/testnet3/transaction/broadcast

# deploy the contract
snarkos developer scan \
--private-key $PRIVATE_KEY \
--endpoint $QUERY_HOST \
--start 0 \
--end 100