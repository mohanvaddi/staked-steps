import { NextFunction, Router, Request, Response } from 'express';
import { ethers } from 'hardhat';
import config from './config';
import { BaseContract } from '../typechain-types';

const router = Router();

export const formatTokenUri = <T>(data: T) => {
  return 'data:application/json;base64,' + btoa(JSON.stringify(data));
};

export const unformatTokenUri = (tokenUri: string) => {
  const base64Data = tokenUri.replace('data:application/json;base64,', '');
  const jsonData = atob(base64Data);
  return JSON.parse(jsonData);
};

const getContractInstance = async (): Promise<BaseContract> => {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const signer = new ethers.Wallet(config.ACCOUNT_PRIVATE_KEY, provider);
  const contract: any = await ethers.getContractAt('BaseNFT', config.CONTRACT_ADDRESS, signer);
  return contract;
};

router.get('/:tokenId', async (req: Request, res: Response, next: NextFunction) => {
  const tokenId = req.params['tokenId'];
  const contract = await getContractInstance();
  const tokenUri = await contract.getTokenMetadata(tokenId);
  return res.status(200).send({
    message: 'Token data retreived successfully',
    data: {
      ...unformatTokenUri(tokenUri),
    },
  });
});

router.post('/mintNft', async (req: Request, res: Response, next: NextFunction) => {
  // TODO: create token metadata based on user's challenge and image ipfs url
  const tokenMetadata = {
    name: 'Fresh Lily - Fresh Market',
    description:
      'Treat yourself or make a perfect gift with Weekly Fresh Lily. Simply visit our store at your preferred time and collect your Lily (Max 4 weeks).',
    image:
      'https://storage.googleapis.com/inm-atg-retailer-nft-uat-media/offerTemplates/22/addfac5296387e119310c6797a1bc66c-6c69dda1917945a6a9602a31d555166c_3P_en_US_450_450.png',
  };
  const tokenUri = formatTokenUri(tokenMetadata);
  const contract = await getContractInstance();
  const resp = await contract.mintToken(tokenUri);

  const receipt = await resp.wait();
  const filter = contract.filters.Transfer(undefined, undefined);
  const events = await contract.queryFilter(filter, receipt?.blockNumber);

  if (events.length <= 0) throw new Error('Unable to find mint event');
  const tokenId = parseInt(events[0].args[2].toString());
  return res.status(200).send({
    message: 'NFT mint successful',
    data: {
      txnHash: resp.hash,
      tokenId: tokenId,
    },
  });
});

export default router;
