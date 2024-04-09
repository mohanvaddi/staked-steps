import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';

const { NETWORK, ACCOUNT_PRIVATE_KEY, POLYGONSCAN_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: '0.8.19',
  defaultNetwork: NETWORK,
  networks: {
    matic_mumbai: {
      url: 'https://rpc-mumbai.maticvigil.com',
      chainId: 80001,
      accounts: [ACCOUNT_PRIVATE_KEY!],
    },
    polygon: {
      url: 'https://polygon-mainnet.infura.io',
      chainId: 137,
      accounts: [ACCOUNT_PRIVATE_KEY!],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: POLYGONSCAN_KEY!,
    },
  },
};

export default config;
