import lighthouse from '@lighthouse-web3/sdk';
import config from '../config.js';

export const uploadImageToIpfs = async (image) => {
  const uploadResponse = await lighthouse.uploadBuffer(image, config.LIGHTHOUSE_STORAGE_API_KEY);
  return `https://gateway.lighthouse.storage/ipfs/${uploadResponse.data.Hash}`;
};
