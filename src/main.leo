// The 'aleooracle' program.
program aleooracle.aleo {
    mapping price_quote: u64 => PriceEntry;

    struct OraclePriceDataEntry {
        null: bool,
        sig: signature,
        a: address,
        price_key: u64,
        price: u64,
        decimal: u8,
        height: u32,
    }

    struct OraclePrice {
        price_key: u64,
        price: u64,
        decimal: u8,
        height: u32,
    }

    struct PriceEntry {
        price: u64,
        decimal: u8
    }

    function data_checker(oracle_price_data_entry: OraclePriceDataEntry, price_key: u64, decimal: u8, height: u32) {
        assert_eq(oracle_price_data_entry.price_key, price_key);
        assert_eq(oracle_price_data_entry.decimal, decimal);
        assert_eq(oracle_price_data_entry.height, height);
    }

    // price aggregator, won't be passed onto finalized if the pricing is not the desired price
    // during the aggregation, signature verification is also conducted.
    // `price_array` is the price data from all oracles
    // `desired_price` is the user's wanting price
    // 'price_diviation_allowance' is the user's allowance of price diviation, in decimals, usually shouldn't be more than 5%, used for comparison between aggregated price and desired price.
    transition price_aggregator(
        price_key: u64, 
        decimal: u8, 
        height: u32,
        price_array: [OraclePriceDataEntry; 8], 
        desired_price: u64, 
        price_diviation_allowance: u64
    ) {
        let sum: u64 = 0u64;
        let counter: u8 = 0u8;

        // verifying every signature 
        for i: u8 in 0u8..8u8 {
            // if there's malicious or fault data, the operation will be aborted
            data_checker(price_array[i], price_key, decimal, height);

            // Calculate the value for signature verification
            let oracle_height: u64 = price_array[i].height as u64;
            let v: u64 = price_array[i].price_key + price_array[i].price;
            v = v + oracle_height;
            let first: bool = signature::verify(price_array[i].sig, price_array[i].a, v);
            let second: bool = price_array[i].sig.verify(price_array[i].a, v);

            // only include the price when the following conditions are met
            // the first and second verification result are the same
            // the data entry is not null (might happen if an oracle node is down)
            let condition: bool = first.eq(second);
            condition = price_array[i].null.eq(false);
            if (condition.eq(true)) {
                sum += price_array[i].price;
            }
            counter = condition ? counter + 1u8 : counter;
        }

        // if the amount of valid prices are less than 4, then will not proceed
        assert(counter.gte(4u8));
        
        // calcualte the aggregated price, TODO might be potential hacking possibility here with flooring the result
        let aggregated_price: u64 = sum / counter as u64;

        // check the diviation level
        let diviation: u64 = aggregated_price.gt(desired_price) ? aggregated_price.sub(desired_price) : desired_price.sub(aggregated_price);
        assert(price_diviation_allowance.gt(diviation));

        return then finalize(OraclePrice {
            price_key: price_key,
            price: aggregated_price,
            decimal: decimal,
            height: height
        });
    }

    finalize price_aggregator(oracle_price: OraclePrice) {
        assert_eq(oracle_price.height, block.height); // might need to check should it be block.height + 1 or just block.height
        Mapping::set(price_quote, oracle_price.price_key, PriceEntry {
            price: oracle_price.price,
            decimal: oracle_price.decimal,
        });
    }
}
