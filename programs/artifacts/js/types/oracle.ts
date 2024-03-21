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
  a: LeoAddress;
  price_key: bigint;
  price: bigint;
  decimal: number;
  height: number;
}

export const leoOraclePriceDataEntrySchema = z.object({
  null: leoBooleanSchema,
  sig: leoSignatureSchema,
  a: leoAddressSchema,
  price_key: leoU64Schema,
  price: leoU64Schema,
  decimal: leoU8Schema,
  height: leoU32Schema,
});
export type OraclePriceDataEntryLeo = z.infer < typeof leoOraclePriceDataEntrySchema > ;

export interface OraclePrice {
  price_key: bigint;
  price: bigint;
  decimal: number;
  height: number;
}

export const leoOraclePriceSchema = z.object({
  price_key: leoU64Schema,
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