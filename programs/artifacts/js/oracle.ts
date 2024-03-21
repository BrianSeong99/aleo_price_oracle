import {
  PriceEntry
} from "./types/oracle";
import {
  getPriceEntryLeo
} from "./js2leo/oracle";
import {
  getPriceEntry
} from "./leo2js/oracle";
import {
  zkRun,
  ContractConfig,
  zkGetMapping,
  LeoAddress,
  LeoRecord,
  js2leo,
  leo2js
} from "@doko-js/core";
import {
  BaseContract
} from "../../contract/base-contract";
import {
  TransactionModel
} from "@aleohq/sdk";

export class OracleContract extends BaseContract {

  constructor(config: ContractConfig = {}) {
    super(config);
    this.config = {
      ...this.config,
      appName: 'oracle',
      contractPath: 'artifacts/leo/oracle',
      fee: '0.01'
    };
  }
  async price_aggregator(r0: bigint, r1: number, r2: number, r3: Array < undefined > , r4: bigint, r5: bigint): Promise < [TransactionModel] > {
    const r0Leo = js2leo.u64(r0);
    const r1Leo = js2leo.u8(r1);
    const r2Leo = js2leo.u32(r2);
    const r3Leo = js2leo.arr2string(js2leo.array(r3, js2leo.OraclePriceDataEntry));
    const r4Leo = js2leo.u64(r4);
    const r5Leo = js2leo.u64(r5);

    const params = [r0Leo, r1Leo, r2Leo, r3Leo, r4Leo, r5Leo]
    const result = await zkRun({
      config: this.config,
      transition: 'price_aggregator',
      params,
    });
    return [result.transaction];
  }

  async price_quote(key: bigint, defaultValue ? : PriceEntry): Promise < PriceEntry > {
    const keyLeo = js2leo.u64(key);

    const params = [keyLeo]
    const result = await zkGetMapping({
      config: this.config,
      transition: 'price_quote',
      params,
    });

    if (result != null)
      return getPriceEntry(result);
    else {
      if (defaultValue != undefined) return defaultValue;
      throw new Error(`price_quote returned invalid value[input: ${key}, output: ${result}`);
    }
  }


}