// The 'aleooracle' program.
program oracle.aleo {
    mapping price_quote: u64 => PriceEntry;
    const num_of_entries: u8 = 8u8;

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

    // `PriceArrayStruct`: this is the struct for store price data dynamically, can't use array since array in leo lang is static
    struct PriceArrayStruct {
        p0: PriceEntry,
        p1: PriceEntry,
        p2: PriceEntry,
        p3: PriceEntry,
        p4: PriceEntry,
        p5: PriceEntry,
        p6: PriceEntry,
        p7: PriceEntry,
    }

    function data_checker(oracle_price_data_entry: OraclePriceDataEntry, token_price_id: u64, decimal: u8, height: u32) {
        assert_eq(oracle_price_data_entry.token_price_id, token_price_id);
        assert_eq(oracle_price_data_entry.decimal, decimal);
        assert_eq(oracle_price_data_entry.height, height);
    }

    // `update_bitmap_index`: used to mimic boolean array / bitmap
    function update_bitmap_index(bitmap: u64, index: u8, value: bool) -> u64 {
        if index < 8u8 {
            if value {
                bitmap = bitmap.or(1u64 << (index as u64));
            } else {
                bitmap = bitmap.and(1u64 << (index as u64));
            }
        }
        return bitmap;
    }

    function get_bitmap_index_value(bitmap: u64, index: u8) -> bool {
        // TODO Should we check the index over range?
        return bitmap & (1u64 << (index as u64)) != 0u64;
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

        return then finalize(OraclePrice {
            token_price_id: token_price_id,
            price: aggregated_price,
            decimal: decimal,
            height: height
        });
    }

    finalize price_aggregator(oracle_price: OraclePrice) {
        assert_eq(oracle_price.height, block.height); // might need to check should it be block.height + 1 or just block.height
        Mapping::set(price_quote, oracle_price.token_price_id, PriceEntry {
            price: oracle_price.price,
            decimal: oracle_price.decimal,
        });
    }
}
