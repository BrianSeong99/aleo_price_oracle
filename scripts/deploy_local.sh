# setup env variable
export QUERY_HOST=http://localhost:3030
export BROADCAST_ENDPOINT=http://localhost:3030/testnet3/transaction/broadcast

# deploy the contract
snarkos developer deploy \
--private-key $PRIVATE_KEY \
--query $QUERY_HOST \
--priority-fee 100 \
--broadcast $BROADCAST_ENDPOINT \
--path ./build/ \
"aleooracle.aleo" 