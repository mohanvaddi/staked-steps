import express from 'express';
import config from './config';

const app = express();
const port = config.PORT;

app.listen(port, () => {
  console.log('backend is running on PORT:: ' + port);
});
