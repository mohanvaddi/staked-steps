import { ethers } from 'hardhat';
import { DeployOptions } from '../types';
import config from '../src/config';

export async function deploy() {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const signer = new ethers.Wallet(config.ACCOUNT_PRIVATE_KEY, provider);
  const nftMarketPlace = await ethers.getContractFactory('BaseNFT', signer);
  const deployContract = await nftMarketPlace.deploy();
  const contractInstance = await deployContract.waitForDeployment();
  return contractInstance.target;
}
