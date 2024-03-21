import {
  OraclePriceDataEntry,
  OraclePriceDataEntryLeo,
  OraclePrice,
  OraclePriceLeo,
  PriceEntry,
  PriceEntryLeo
} from "../types/oracle";
import {
  js2leo
} from "@doko-js/core";


export function getOraclePriceDataEntryLeo(oraclePriceDataEntry: OraclePriceDataEntry): OraclePriceDataEntryLeo {
  const result: OraclePriceDataEntryLeo = {
    null: js2leo.boolean(oraclePriceDataEntry.null),
    sig: js2leo.signature(oraclePriceDataEntry.sig),
    a: js2leo.address(oraclePriceDataEntry.a),
    price_key: js2leo.u64(oraclePriceDataEntry.price_key),
    price: js2leo.u64(oraclePriceDataEntry.price),
    decimal: js2leo.u8(oraclePriceDataEntry.decimal),
    height: js2leo.u32(oraclePriceDataEntry.height),
  }
  return result;
}

export function getOraclePriceLeo(oraclePrice: OraclePrice): OraclePriceLeo {
  const result: OraclePriceLeo = {
    price_key: js2leo.u64(oraclePrice.price_key),
    price: js2leo.u64(oraclePrice.price),
    decimal: js2leo.u8(oraclePrice.decimal),
    height: js2leo.u32(oraclePrice.height),
  }
  return result;
}

export function getPriceEntryLeo(priceEntry: PriceEntry): PriceEntryLeo {
  const result: PriceEntryLeo = {
    price: js2leo.u64(priceEntry.price),
    decimal: js2leo.u8(priceEntry.decimal),
  }
  return result;
}