import express from 'express';
import config from './config';
import nftRouter from './nft-router';

const app = express();
const port = config.PORT;

app.use('/nft', nftRouter);

app.listen(port, () => {
  console.log('backend is running on PORT:: ' + port);
});
