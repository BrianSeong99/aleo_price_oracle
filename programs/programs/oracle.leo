import credits.leo;

program oracle.aleo {
    
    /* ----------------- oracle service ----------------- */

    const num_of_entries: u8 = 8u8;

    // Price Quote mapping, callable by other contracts
    mapping price_quote: u64 => PriceEntry;

    // `OraclePriceDataEntry`: this is the data passed from the oracle.
    struct OraclePriceDataEntry {
        null: bool, // for marking certain Entry is null or not
        sig: signature,
        addr: address,
        token_price_id: u64,
        price: u64,
        decimal: u8,
        height: u32,
    }

    // `OraclePrice`: this is the data passed from transition to finalize
    struct OraclePrice {
        token_price_id: u64,
        price: u64,
        decimal: u8,
        height: u32,
    }

    // `PriceEntry`: this is the data stored on the mapping at last.
    struct PriceEntry {
        price: u64,
        decimal: u8
    }

    function data_checker(oracle_price_data_entry: OraclePriceDataEntry, token_price_id: u64, decimal: u8, height: u32) {
        assert_eq(oracle_price_data_entry.token_price_id, token_price_id);
        assert_eq(oracle_price_data_entry.decimal, decimal);
        assert_eq(oracle_price_data_entry.height, height);
    }

    // `update_bitmap_index`: used to mimic boolean array / bitmap
    function update_bitmap_index(bitmap: u64, index: u8, value: bool) -> u64 {
        let bitmap_index: u64 = 1u64 << index;
        if index < 8u8 {
            if value {
                bitmap = bitmap.or(bitmap_index);
            } else {
                bitmap = bitmap.and(bitmap_index);
            }
        }
        return bitmap;
    }

    function get_bitmap_index_value(bitmap: u64, index: u8) -> bool {
        // TODO Should we check the index over range?
        let bitmap_index: u64 = 1u64 << index;
        return bitmap & bitmap_index != 0u64;
    }

    // price aggregator, won't be passed onto finalized if the pricing is not the desired price
    // during the aggregation, signature verification is also conducted.
    // `price_array` is the price data from all oracles
    // `desired_price` is the user's wanting price
    // 'price_diviation_allowance' is the user's allowance of price diviation, in decimals, usually shouldn't be more than 5%, used for comparison between aggregated price and desired price.
    transition price_aggregator(
        token_price_id: u64, 
        decimal: u8, 
        height: u32,
        price_array: [OraclePriceDataEntry; 8], 
        desired_price: u64, 
        price_diviation_allowance: u64
    ) {
        let sum: u64 = 0u64;
        let counter: u8 = 0u8;
        let valid_price_bitmap: u64 = 0u64; // because leo lang only support static array, so have to use binary value to mimic boolean array.

        // verifying every signature 
        for i: u8 in 0u8..num_of_entries {
            // if there's malicious or fault data, the operation will be aborted
            data_checker(price_array[i], token_price_id, decimal, height);

            // signature verification
            // only include the price when the first and second verification result are the same
            let oracle_height: u64 = price_array[i].height as u64;
            let v: u64 = price_array[i].token_price_id + price_array[i].price;
            v = v + oracle_height;
            let first: bool = signature::verify(price_array[i].sig, price_array[i].addr, v);
            let second: bool = price_array[i].sig.verify(price_array[i].addr, v);
            let condition: bool = first.eq(second);

            // only include the price when the data entry is not null (might happen if an oracle node is down)
            condition = price_array[i].null.eq(false);
            if (condition.eq(true)) {
                // update the sum
                sum += price_array[i].price * 10u64.pow(price_array[i].decimal);

                // update the valid_prices array
                update_bitmap_index(valid_price_bitmap, i, true);

                // update valid number counter
                counter += 1u8;
            }
        }

        // if the amount of valid prices are less than 4, then will not proceed
        assert(counter.gte(4u8));
        
        // Calcualte the average price, TODO might be potential hacking possibility here with flooring the result
        let average_price: u64 = sum / counter as u64;

        // Calculate the variance of all valid prices
        let use_average_price: bool = false;
        let variance: u64 = 0u64;
        for i: u8 in 0u8..num_of_entries {
            if (get_bitmap_index_value(valid_price_bitmap, i)) {
                if (price_array[i].price > average_price) {
                    variance += (price_array[i].price * 10u64.pow(price_array[i].decimal) - average_price * 10u64.pow(decimal)).pow(2u8);
                } else {
                    variance += (average_price * 10u64.pow(decimal) - price_array[i].price * 10u64.pow(price_array[i].decimal)).pow(2u8);
                }
            }
        }
        variance = variance / ((counter as u64) - 1u64);
        let tenth_decimal_point: u64 = 10u64.pow(decimal) * 100u64;
        if ((variance > tenth_decimal_point) && (variance - tenth_decimal_point).lt(2u64)) {
            use_average_price = true;
        } else if ((variance < tenth_decimal_point) && (tenth_decimal_point - variance).lt(2u64)) {
            use_average_price = true;
        }

        // Select average price or middle price as the aggregated_price
        let aggregated_price: u64 = average_price;
        if (!use_average_price) {
            // TODO add middle price algorithm
        }

        // check the diviation level
        let diviation: u64 = aggregated_price.gt(desired_price) ? aggregated_price.sub(desired_price) : desired_price.sub(aggregated_price);
        assert(price_diviation_allowance.gt(diviation));

        let oracle_node_addrs: [address; 8] = [
            price_array[0u8].addr,
            price_array[1u8].addr,
            price_array[2u8].addr,
            price_array[3u8].addr,
            price_array[4u8].addr,
            price_array[5u8].addr,
            price_array[6u8].addr,
            price_array[7u8].addr,
        ];

        return then finalize(OraclePrice {
            token_price_id: token_price_id,
            price: aggregated_price,
            decimal: decimal,
            height: height
        }, oracle_node_addrs);
    }

    finalize price_aggregator(oracle_price: OraclePrice, oracle_node_addrs: [address; 8]) {
        // might need to check should it be block.height + 1 or just block.height
        assert_eq(oracle_price.height, block.height);

        // check if all node_operators are still valid
        // distribute incentives to all oracle nodes
        for i: u8 in 0u8..8u8 {
            assert(Mapping::contains(oracle_nodes, oracle_node_addrs[i]));
            let oracle_node: OracleNode = Mapping::get(oracle_nodes, oracle_node_addrs[i]);
            assert_neq(oracle_node.status, 3u8);
            // TODO distribute incentives to price providers
        }


        Mapping::set(price_quote, oracle_price.token_price_id, PriceEntry {
            price: oracle_price.price,
            decimal: oracle_price.decimal,
        });
    }

    /* ----------------- oracle node manager ----------------- */
    
    // program admin
    const admin: address = aleo1qgf9yps4vns0mkqxm8vlv607k8k4vdkqjjqttf4e25lwuwnxxsyq7rmczy;

    // Oracle nodes whitelist mapping.
    mapping oracle_nodes: address => OracleNode;
    // Total value of all stakes
    mapping total_staked_value: field => u64;

    // 0u8 is unregisterred, 
    // 1u8 is registerred but not staked, 
    // 2u8 is registerred and staked, 
    // 3u8 is registerred and staked but slashed / banned
    struct OracleNode {
        addr: address,
        status: u8, 
    }

    // OracleNodeStakeNFT: proof of stake for node operators.
    record OracleNodeStakeNFT {
        owner: address,
        balance: u64,
    }

    // only callable by admin
    transition add_node_operator_to_whitelist(node_addr: address) {
        assert_eq(self.caller, admin);
        return then finalize(node_addr);
    }

    finalize add_node_operator_to_whitelist(node_addr: address) {
        let oracle_node: OracleNode = Mapping::get_or_use(oracle_nodes, node_addr, OracleNode{
            addr: node_addr,
            status: 1u8,
        });
        assert_neq(oracle_node.status, 3u8);
        Mapping::set(oracle_nodes, node_addr, oracle_node);
    }

    // only callable by admin
    transition ban_node_operator_from_whitelist(node_addr: address) {
        assert_eq(self.caller, admin);
        return then finalize(node_addr);
    }

    finalize ban_node_operator_from_whitelist(node_addr: address) {
        let oracle_node: OracleNode = Mapping::get_or_use(oracle_nodes, node_addr, OracleNode{
            addr: node_addr,
            status: 3u8,
        });
        Mapping::set(oracle_nodes, node_addr, oracle_node);
    }

    function is_node_operator_valid(node_addr: address) {
        let is_contain: bool = Mapping::contains(oracle_nodes, node_addr);
    }

}
