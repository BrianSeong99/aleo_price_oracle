import 'dotenv/config';
import express from 'express';
import { Account, AleoNetworkClient } from '@aleohq/sdk';

// await initializeWasm();

const app = express();
const port = process.env.PORT || 3000; // Use a fallback if PORT is not defined in .env

const networkClient = new AleoNetworkClient("http://0.0.0.0:3030");

const account = new Account({ privateKey: process.env.PRIVATE_KEY });

app.get('/price', async (req, res) => {
  const price = 100; // place holder, a temporary price
  const token_id = "420u64"; // place holder, a temporary token_id
  const decimal = "6u8"; // place holder, a temporary decimal
  const user_address = req.query.address;
  const node_address = account.toString();
  const height = await networkClient.getLatestHeight();

  console.log(price, token_id, decimal, user_address, node_address, height);

  const signature = await signData(token_id, price, decimal, height);

  res.send({
    price,
    token_id,
    decimal,
    user_address,
    node_address,
    height,
    signature,
  });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

async function signData(token_id, price, decimal, block_height) {
  const message = `${token_id}${price}${decimal}${block_height}`;
  const signature = account.sign(message).to_string();
  return signature;
}
