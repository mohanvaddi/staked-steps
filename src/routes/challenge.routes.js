import { Router } from 'express';
import config from '../config.js';

const router = Router();

const { ethers } = hardhat;
import hardhat from 'hardhat';

const getContractInstance = async () => {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const signer = new ethers.Wallet(config.ACCOUNT_PRIVATE_KEY, provider);
  const contract = await ethers.getContractAt('BaseContract', config.CONTRACT_ADDRESS, signer);
  return contract;
};

router.post('/dailyCheckIn', async (req, res) => {
  const { userAddress, challengeId, stepCount } = req.body;
  const contract = await getContractInstance();
  await contract.dailyCheckIn(userAddress, challengeId, stepCount);
  return res.status(200).send("Success");
});

export default router;