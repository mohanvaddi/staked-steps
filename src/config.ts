import dotenv from 'dotenv';
dotenv.config();

const config = {
  NODE_ENV: process.env['NODE_ENV']!,
  PORT: process.env['PORT']! || 4002,
  ACCOUNT_ADDRESS: process.env['ACCOUNT_ADDRESS']!,
  NFT_CONTRACT_ADDRESS: process.env['NFT_CONTRACT_ADDRESS']!,
  ACCOUNT_PRIVATE_KEY: process.env['ACCOUNT_PRIVATE_KEY']!,
  JSON_RPC_URL: process.env['JSON_RPC_URL']!,
  OPENSEA_CHAIN: process.env['OPENSEA_CHAIN']!,
  OPENSEA_API_KEY: process.env['OPENSEA_API_KEY']!,
  PINATA_JWT: process.env['PINATA_JWT']!,
  PINATA_GATEWAY: process.env['PINATA_GATEWAY']!,
  JWT_SECRET: process.env['JWT_SECRET']!,
  PINATA_IPFS_URL: process.env['PINATA_IPFS_URL']!,
};

// call this function in server.ts to validate config
export function validateConfig() {
  const configKeys: string[] = [];
  for (const [key, value] of Object.entries(config)) {
    if (value === undefined) {
      configKeys.push(key);
    }
  }
  if (configKeys.length > 0) {
    console.error('[ERROR] CONFIG NOT FOUND:: ' + configKeys.join(', '));
    process.exit(1);
  }
}

export const OPENSEA_CONSTANTS = {
  ZONE: '0x0000000000000000000000000000000000000000',
  OPENSEA_ADDRESS: '0x0000a26b00c1F0DF003000390027140000fAa719',
  PROTOCOL_ADDRESS: '0x00000000000000ADc04C56Bf30aC9d3c0aAF14dC',
  NATIVE_TOKEN_ADDRESS: '0x0000000000000000000000000000000000000000',
  ZONE_HASH: '0x0000000000000000000000000000000000000000000000000000000000000000',
  CONDUIT_KEY: '0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000',
  POLYGON_WETH_ADDRESS: '0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619',
  MUMBAI_WETH_ADDRESS: '0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa',
};
export default config;
