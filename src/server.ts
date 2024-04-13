import express from 'express';
import config from './config';
import nftRouter from './nft-router';
import { Request, Response } from 'express';

const app = express();
const port = config.PORT;

app.use('/nft', nftRouter);

// to dynamically get recent ABI and CONTRACT_ADDRESS in the frontend
// ABI and contract address are needed to interact with smart contract functions from any web3 client.
app.get('/contract-info', (req: Request, res: Response) => {
  return res.json({
    address: config.CONTRACT_ADDRESS,
    abi: require('../artifacts/contracts/BaseContract.sol/BaseContract.json').abi,
  });
});

app.get('/mock_challenges', (req, res) => {
  res.json({
    challenges: [
      {
        challengeName: 'Challenge #1',
        startDate: 1713004804235,
        endDate: 1713004804235,
        totalDays: 10,
        stakedAmount: 0.1,
        totalParticipants: 10,
        participants: [
          {
            name: 'Apple',
            daysCompleted: 4,
          },
          {
            name: 'Mohan',
            daysCompleted: 5,
          },
          {
            name: 'Vijay',
            daysCompleted: 3,
          },
        ],
      },

      {
        challengeName: 'Challenge #1',
        startDate: 1713004804235,
        endDate: 1713004804235,
        totalDays: 10,
        stakedAmount: 0.1,
        totalParticipants: 10,
        participants: [
          {
            name: 'Apple',
            daysCompleted: 4,
          },
          {
            name: 'Mohan',
            daysCompleted: 5,
          },
          {
            name: 'Vijay',
            daysCompleted: 3,
          },
        ],
      },

      {
        challengeName: 'Challenge #1',
        startDate: 1713004804235,
        endDate: 1713004804235,
        totalDays: 10,
        stakedAmount: 0.1,
        totalParticipants: 10,
        participants: [
          {
            name: 'Apple',
            daysCompleted: 4,
          },
          {
            name: 'Mohan',
            daysCompleted: 5,
          },
          {
            name: 'Vijay',
            daysCompleted: 3,
          },
        ],
      },
    ],
  });
});

app.listen(port, () => {
  console.log('backend is running on PORT:: ' + port);
});
