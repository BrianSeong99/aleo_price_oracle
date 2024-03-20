# setup env variable
export QUERY_HOST=https://api.explorer.aleo.org/v1/testnet3 #http://localhost:3030
export BROADCAST_ENDPOINT=https://api.explorer.aleo.org/v1/testnet3/transaction/broadcast #http://localhost:3030/testnet3/transaction/broadcast

# deploy the contract
snarkos developer scan \
--private-key $PRIVATE_KEY \
--endpoint $QUERY_HOST \
--start 0 \
--end 100