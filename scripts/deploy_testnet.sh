# setup env variable
export QUERY_HOST=https://api.explorer.aleo.org/v1 #http://localhost:3030
export BROADCAST_ENDPOINT=https://api.explorer.aleo.org/v1/testnet3/transaction/broadcast #http://localhost:3030/testnet3/transaction/broadcast

# deploy the contract
snarkos developer deploy \
--private-key $PRIVATE_KEY \
--query $QUERY_HOST \
--priority-fee 100 \
--broadcast $BROADCAST_ENDPOINT \
--path ./build/ \
"aleooracle.aleo" 