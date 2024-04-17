import { Router } from 'express';
import hardhat from 'hardhat';
import multer from 'multer';
import config from '../config.js';
import { uploadImageToIpfs } from '../services/storage.service.js';
import { createNftImage } from '../utils/nft.utils.js';
const { ethers } = hardhat;

const router = Router();

export const formatTokenUri = (data) => {
  return 'data:application/json;base64,' + btoa(JSON.stringify(data));
};

export const unformatTokenUri = (tokenUri) => {
  const base64Data = tokenUri.replace('data:application/json;base64,', '');
  const jsonData = atob(base64Data);
  return JSON.parse(jsonData);
};

const getContractInstance = async () => {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const signer = new ethers.Wallet(config.ACCOUNT_PRIVATE_KEY, provider);
  const contract = await ethers.getContractAt('BaseContract', config.CONTRACT_ADDRESS, signer);
  return contract;
};

router.get('/:tokenId', async (req, res, next) => {
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

router.get('/get/:address', async (req, res, next) => {
  const address = req.params['address'];
  const contract = await getContractInstance();
  const tokenUri = await contract.getOwnedTokens(address);
  console.log(tokenUri);

  const unf = tokenUri.map((token) => {
    return unformatTokenUri(token);
  });

  return res.status(200).send({
    message: 'Token data retreived successfully',
    data: {
      ...unf,
    },
  });
});

router.post('/mintNft', multer().single('image'), async (req, res, next) => {
  if (!req.file) {
    return res.send('Image file is missing!');
  }
  const image = req.file;
  const { text1, text2 } = req.body;
  
  const nftImage = await createNftImage(Buffer.from(image.buffer), text1, text2);
  const imageIpfsUrl = await uploadImageToIpfs(nftImage);

  const tokenMetadata = {
    name: 'Challenge #workout 2',
    description: "It's a bird, It's a plane, It's superman",
    image: imageIpfsUrl,
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
      tokenId: tokenId,
      txnHash: resp.hash,
    },
  });
});

export default router;
