# aleooracle.aleo

## Build Guide

To compile this Aleo program, run:
```bash
snarkvm build
```

To execute this Aleo program, run:
```bash
snarkvm run hello
```

## Resources
### Tools
- [DokoJS](https://github.com/venture23-aleo/doko-js): Aleo Testing Framework

### Papers
- [TWAP Oracle Attacks: Easier Done than Said?](https://eprint.iacr.org/2022/445.pdf)

### Talks
- [Vulnerability on Aleo](https://youtu.be/QRf4Hfxxht4?si=fENm-W7KtCTJaoYd&t=633)

## Blogs
- [HyperOracle](https://mirror.xyz/orablog.eth/qbefsToFgFxBZBocwlkX-HXbpeUzZiv2UB5CmxcaFTM)
- [zk Co-processor by Axiom](https://blog.axiom.xyz/what-is-a-zk-coprocessor/)
- [Chainlink Price Expensive](https://cointelegraph.com/news/band-protocol-ceo-says-that-a-single-chainlink-data-request-costs-450)

### Code
- [Aleo Credits Source Code](https://github.com/AleoHQ/snarkVM/blob/testnet3/synthesizer/program/src/resources/credits.aleo)

## TODO

Leo Programs:
- [ ] Basic Version of the Program, capable of collecting prices from 8 whitelisted address
- [ ] Deploy & Test Scripts
- [ ] Staking Mechanism for the nodes
- [ ] Fee for Node Providers when price is accepted

Offchain Node Operators:
- [ ] Sign message including block height, address, price, and pair
- [ ] Backend for user's to call when price point is needed
- [ ] Token Price List
- [ ] 