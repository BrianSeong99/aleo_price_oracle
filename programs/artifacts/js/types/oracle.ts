import {
  z
} from "zod";
import {
  leoAddressSchema,
  leoPrivateKeySchema,
  leoViewKeySchema,
  leoTxIdSchema,
  leoScalarSchema,
  leoFieldSchema,
  leoBooleanSchema,
  leoU8Schema,
  leoU16Schema,
  leoU32Schema,
  leoU64Schema,
  leoU128Schema,
  leoGroupSchema,
  leoRecordSchema,
  leoTxSchema,
  leoSignatureSchema,
  LeoArray,
  LeoAddress
} from "@doko-js/core";

export interface OraclePriceDataEntry {
  null: boolean;
  sig: string;
  addr: LeoAddress;
  token_price_id: bigint;
  price: bigint;
  decimal: number;
  height: number;
}

export const leoOraclePriceDataEntrySchema = z.object({
  null: leoBooleanSchema,
  sig: leoSignatureSchema,
  addr: leoAddressSchema,
  token_price_id: leoU64Schema,
  price: leoU64Schema,
  decimal: leoU8Schema,
  height: leoU32Schema,
});
export type OraclePriceDataEntryLeo = z.infer < typeof leoOraclePriceDataEntrySchema > ;

export interface OraclePrice {
  token_price_id: bigint;
  price: bigint;
  decimal: number;
  height: number;
}

export const leoOraclePriceSchema = z.object({
  token_price_id: leoU64Schema,
  price: leoU64Schema,
  decimal: leoU8Schema,
  height: leoU32Schema,
});
export type OraclePriceLeo = z.infer < typeof leoOraclePriceSchema > ;

export interface PriceEntry {
  price: bigint;
  decimal: number;
}

export const leoPriceEntrySchema = z.object({
  price: leoU64Schema,
  decimal: leoU8Schema,
});
export type PriceEntryLeo = z.infer < typeof leoPriceEntrySchema > ;

export interface PriceArrayStruct {
  p0: PriceEntry;
  p1: PriceEntry;
  p2: PriceEntry;
  p3: PriceEntry;
  p4: PriceEntry;
  p5: PriceEntry;
  p6: PriceEntry;
  p7: PriceEntry;
}

export const leoPriceArrayStructSchema = z.object({
  p0: leoPriceEntrySchema,
  p1: leoPriceEntrySchema,
  p2: leoPriceEntrySchema,
  p3: leoPriceEntrySchema,
  p4: leoPriceEntrySchema,
  p5: leoPriceEntrySchema,
  p6: leoPriceEntrySchema,
  p7: leoPriceEntrySchema,
});
export type PriceArrayStructLeo = z.infer < typeof leoPriceArrayStructSchema > ;