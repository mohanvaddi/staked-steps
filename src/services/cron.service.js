const { ethers } = hardhat;
import hardhat from 'hardhat';
import config from '../config.js';

const getContractInstance = async () => {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const signer = new ethers.Wallet(config.ACCOUNT_PRIVATE_KEY, provider);
  const contract = await ethers.getContractAt('BaseContract', config.CONTRACT_ADDRESS, signer);
  return contract;
};

export const decideWinnersCron = async () => {
  const contract = await getContractInstance();
  let challengesIds = await contract.getOngoingEndedChallengeIds();
  challengesIds = challengesIds.map(id => id.toString());
  const promises = [];
  for(let i=0; i<challengesIds.length; i++) {
    promises.push(contract.decideWinners(challengesIds[i]));
  }
  const response = await Promise.allSettled(promises);
};