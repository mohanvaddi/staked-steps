import express from 'express';
import config from './config';
import nftRouter from './routes/nft.routes';

const app = express();
const port = config.PORT;

app.get("/", (req, res)=> {
  res.send("Not Dead!")
})

app.use('/nft', nftRouter);

app.listen(port, () => {
  console.log('backend is running on PORT:: ' + port);
});
