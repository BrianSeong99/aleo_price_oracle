import {
  OraclePriceDataEntry,
  OraclePriceDataEntryLeo,
  OraclePrice,
  OraclePriceLeo,
  PriceEntry,
  PriceEntryLeo,
  PriceArrayStruct,
  PriceArrayStructLeo
} from "../types/oracle";
import {
  leo2js
} from "@doko-js/core";


export function getOraclePriceDataEntry(oraclePriceDataEntry: OraclePriceDataEntryLeo): OraclePriceDataEntry {
  const result: OraclePriceDataEntry = {
    null: leo2js.boolean(oraclePriceDataEntry.null),
    sig: leo2js.signature(oraclePriceDataEntry.sig),
    addr: leo2js.address(oraclePriceDataEntry.addr),
    token_price_id: leo2js.u64(oraclePriceDataEntry.token_price_id),
    price: leo2js.u64(oraclePriceDataEntry.price),
    decimal: leo2js.u8(oraclePriceDataEntry.decimal),
    height: leo2js.u32(oraclePriceDataEntry.height),
  }
  return result;
}

export function getOraclePrice(oraclePrice: OraclePriceLeo): OraclePrice {
  const result: OraclePrice = {
    token_price_id: leo2js.u64(oraclePrice.token_price_id),
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

export function getPriceArrayStruct(priceArrayStruct: PriceArrayStructLeo): PriceArrayStruct {
  const result: PriceArrayStruct = {
    p0: getPriceEntry(priceArrayStruct.p0),
    p1: getPriceEntry(priceArrayStruct.p1),
    p2: getPriceEntry(priceArrayStruct.p2),
    p3: getPriceEntry(priceArrayStruct.p3),
    p4: getPriceEntry(priceArrayStruct.p4),
    p5: getPriceEntry(priceArrayStruct.p5),
    p6: getPriceEntry(priceArrayStruct.p6),
    p7: getPriceEntry(priceArrayStruct.p7),
  }
  return result;
}