import hardhat from 'hardhat';
import config from '../src/config.js';
const { ethers } = hardhat;

async function deploy() {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const signer = new ethers.Wallet(config.ACCOUNT_PRIVATE_KEY, provider);
  const contract = await ethers.getContractFactory('BaseContract', signer);
  const deployContract = await contract.deploy('Test NFT', 'TNFT');
  const contractInstance = await deployContract.waitForDeployment();
  return contractInstance.target;
}

deploy()
  .then((contractAddr) => {
    console.log('ContractAddress::', contractAddr);
  })
  .catch((error) => {
    console.error('Unable to Deploy Contract::', error);
  });
