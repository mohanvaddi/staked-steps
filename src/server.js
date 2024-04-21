import express from 'express';
import config from './config.js';
import nftRouter from './routes/nft.routes.js';
import challengeRouter from './routes/challenge.routes.js';
import baseContractJson from '../artifacts/contracts/BaseContract.sol/BaseContract.json' assert { type: 'json' };
import cron from 'node-cron';
import { decideWinnersCron } from './services/cron.service.js';
import bodyParser from 'body-parser';

cron.schedule('0 * * * *', async () => {
  await decideWinnersCron();
});

const app = express();
const port = config.PORT;

app.use(bodyParser.json()); // Parse application/json content
app.use(bodyParser.urlencoded({ extended: true })); //

app.get('/', (req, res) => {
  res.send('Not Dead!');
});

app.use('/nft', nftRouter);
app.use('/challenge', challengeRouter);

// to dynamically get recent ABI and CONTRACT_ADDRESS in the frontend
// ABI and contract address are needed to interact with smart contract functions from any web3 client.
app.get('/contract-info', (req, res) => {
  return res.json({
    address: config.CONTRACT_ADDRESS,
    abi: baseContractJson.abi,
  });
});

app.listen(port, () => {
  console.log('backend is running on PORT:: ' + port);
});
