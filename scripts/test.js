import hardhat from 'hardhat';
import config from '../src/config.js';
const { ethers } = hardhat;
const ca = ''

const getContractInstance = async (privateKey) => {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const signer = new ethers.Wallet(privateKey, provider);
  const contract = await ethers.getContractAt('BaseContract', ca, signer);
  return contract;
};

const createPublicChallenge = async (privateKey) => {
  const contract = await getContractInstance(privateKey);
  const challengePayload = {
    _challengeName: 'Challenge #1',
    _startDate: 1713456975,
    _endDate: 1716048975,
    _totalDays: 30,
    _stakedAmount: ethers.parseEther('1'),
    _participantsLimit: 25,
    _goal: 10000,
    _visibility: 0,
  };

  const transaction = await contract.createChallenge(
    challengePayload._challengeName,
    challengePayload._startDate,
    challengePayload._endDate,
    challengePayload._totalDays,
    challengePayload._stakedAmount,
    challengePayload._participantsLimit,
    challengePayload._goal,
    challengePayload._visibility,
    '',
    { value: challengePayload._stakedAmount }
  );

  await transaction.wait();
};

const createPrivateChallenge = async (privateKey) => {
  const contract = await getContractInstance(privateKey);
  const challengePayload = {
    _challengeName: 'Challenge #2',
    _startDate: 1713456975,
    _endDate: 1716048975,
    _totalDays: 30,
    _stakedAmount: ethers.parseEther('2'),
    _participantsLimit: 5,
    _goal: 10000,
    _visibility: 1,
    _passKey: "MyPassKey"
  };

  const transaction = await contract.createChallenge(
    challengePayload._challengeName,
    challengePayload._startDate,
    challengePayload._endDate,
    challengePayload._totalDays,
    challengePayload._stakedAmount,
    challengePayload._participantsLimit,
    challengePayload._goal,
    challengePayload._visibility,
    challengePayload._passKey,
    { value: challengePayload._stakedAmount }
  );

  await transaction.wait();
}

const joinPublicChallenge = async (privateKey) => {
  const contract = await getContractInstance(privateKey);
  const transaction = await contract.joinPublicChallenge(0, { value: ethers.parseEther('1') });
  await transaction.wait();
};

const joinPrivateChallenge = async (privateKey) => {
  const contract = await getContractInstance(privateKey);
  const transaction = await contract.joinPrivateChallenge(1, "MyPassKey", { value: ethers.parseEther('2') });
  await transaction.wait();
};

const getUserChallenges = async (privateKey, userKey) => {
  const contract = await getContractInstance(privateKey);
  const challenges = await contract.getUserChallenges(userKey);
  console.log(challenges);
};

const getPublicChallenges = async (privateKey) => {
  const contract = await getContractInstance(privateKey);
  const challenges = await contract.publicChallenges();
  console.log(challenges);
};

const getParticipants = async(privateKey) => {
  const contract = await getContractInstance(privateKey);
  const participants = await contract.getParticipants(1)
  console.log(participants);
}

const dailyCheckIn = async(privateKey, userAddress, challengeId, stepCount) => {
  const contract = await getContractInstance(privateKey);
  await contract.dailyCheckIn(userAddress, challengeId, stepCount)
}

const decideWinners = async (privateKey) => {
  const contract = await getContractInstance(privateKey);
  await contract.decideWinners(1);
  console.log('Winners decided successfully');
}

const getContractBalance = async (privateKey) => {
  const provider = new ethers.JsonRpcProvider(config.JSON_RPC_URL);
  const balance = await provider.getBalance(ca)
  console.log(`Contract balance: ${ethers.formatEther(balance)} ETH`);
};

try{
  const privateKey1 = ''
  const privateKey2 = ''
  const privateKey3 = ''
  // await createPublicChallenge(privateKey1);
  // await joinPublicChallenge(privateKey2);
  // await createPrivateChallenge(privateKey1);
  // await joinPrivateChallenge(privateKey2);
  // await joinPrivateChallenge(privateKey3);

  // await dailyCheckIn(privateKey1, '', 0, 10100);
  // await dailyCheckIn(privateKey1, '', 0, 100);
  // await dailyCheckIn(privateKey1, '', 1, 12345);
  // await dailyCheckIn(privateKey1, '', 1, 12000);
  // await dailyCheckIn(privateKey3, 1, 23459);
  await getPublicChallenges(privateKey1);
  await getUserChallenges(privateKey1, '');
  await getParticipants(privateKey1);
  // await getContractBalance(privateKey1)
  // await decideWinners(privateKey1)
  // await sendEth(privateKey1)
  // await getContractBalance(privateKey1)

} catch(e) {
  console.log(e);
}