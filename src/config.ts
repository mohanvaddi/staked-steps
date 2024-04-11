import dotenv from 'dotenv';
dotenv.config();

const config = {
  NODE_ENV: process.env['NODE_ENV']!,
  PORT: process.env['PORT']! || 4002,
  ACCOUNT_ADDRESS: process.env['ACCOUNT_ADDRESS']!,
  CONTRACT_ADDRESS: process.env['CONTRACT_ADDRESS']!,
  ACCOUNT_PRIVATE_KEY: process.env['ACCOUNT_PRIVATE_KEY']!,
  JSON_RPC_URL: process.env['JSON_RPC_URL']!,
};

export default config;
