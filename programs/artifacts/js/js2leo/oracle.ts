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
  js2leo
} from "@doko-js/core";


export function getOraclePriceDataEntryLeo(oraclePriceDataEntry: OraclePriceDataEntry): OraclePriceDataEntryLeo {
  const result: OraclePriceDataEntryLeo = {
    null: js2leo.boolean(oraclePriceDataEntry.null),
    sig: js2leo.signature(oraclePriceDataEntry.sig),
    addr: js2leo.address(oraclePriceDataEntry.addr),
    token_price_id: js2leo.u64(oraclePriceDataEntry.token_price_id),
    price: js2leo.u64(oraclePriceDataEntry.price),
    decimal: js2leo.u8(oraclePriceDataEntry.decimal),
    height: js2leo.u32(oraclePriceDataEntry.height),
  }
  return result;
}

export function getOraclePriceLeo(oraclePrice: OraclePrice): OraclePriceLeo {
  const result: OraclePriceLeo = {
    token_price_id: js2leo.u64(oraclePrice.token_price_id),
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

export function getPriceArrayStructLeo(priceArrayStruct: PriceArrayStruct): PriceArrayStructLeo {
  const result: PriceArrayStructLeo = {
    p0: getPriceEntryLeo(priceArrayStruct.p0),
    p1: getPriceEntryLeo(priceArrayStruct.p1),
    p2: getPriceEntryLeo(priceArrayStruct.p2),
    p3: getPriceEntryLeo(priceArrayStruct.p3),
    p4: getPriceEntryLeo(priceArrayStruct.p4),
    p5: getPriceEntryLeo(priceArrayStruct.p5),
    p6: getPriceEntryLeo(priceArrayStruct.p6),
    p7: getPriceEntryLeo(priceArrayStruct.p7),
  }
  return result;
}