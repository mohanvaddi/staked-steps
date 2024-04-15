require('@nomicfoundation/hardhat-toolbox');

const dotenv = require('dotenv');
dotenv.config();

const { NETWORK, ACCOUNT_PRIVATE_KEY, POLYGONSCAN_KEY, JSON_RPC_URL, CHAIN_ID } = process.env;

const config = {
  solidity: '0.8.20',
  defaultNetwork: 'default',
  networks: {
    default: {
      url: JSON_RPC_URL,
      chainId: parseInt(CHAIN_ID),
      accounts: [ACCOUNT_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: POLYGONSCAN_KEY,
    },
  },
};

module.exports = config;
