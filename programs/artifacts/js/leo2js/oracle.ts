import {
  OraclePriceDataEntry,
  OraclePriceDataEntryLeo,
  OraclePrice,
  OraclePriceLeo,
  PriceEntry,
  PriceEntryLeo
} from "../types/oracle";
import {
  leo2js
} from "@doko-js/core";


export function getOraclePriceDataEntry(oraclePriceDataEntry: OraclePriceDataEntryLeo): OraclePriceDataEntry {
  const result: OraclePriceDataEntry = {
    null: leo2js.boolean(oraclePriceDataEntry.null),
    sig: leo2js.signature(oraclePriceDataEntry.sig),
    a: leo2js.address(oraclePriceDataEntry.a),
    price_key: leo2js.u64(oraclePriceDataEntry.price_key),
    price: leo2js.u64(oraclePriceDataEntry.price),
    decimal: leo2js.u8(oraclePriceDataEntry.decimal),
    height: leo2js.u32(oraclePriceDataEntry.height),
  }
  return result;
}

export function getOraclePrice(oraclePrice: OraclePriceLeo): OraclePrice {
  const result: OraclePrice = {
    price_key: leo2js.u64(oraclePrice.price_key),
    price: leo2js.u64(oraclePrice.price),
    decimal: leo2js.u8(oraclePrice.decimal),
    height: leo2js.u32(oraclePrice.height),
  }
  return result;
}

export function getPriceEntry(priceEntry: PriceEntryLeo): PriceEntry {
  const result: PriceEntry = {
    price: leo2js.u64(priceEntry.price),
    decimal: leo2js.u8(priceEntry.decimal),
  }
  return result;
}