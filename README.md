# Staked Steps

## Development Setup:

### Orbit DB Setup:
1. Start the DB with command `npm run db`
2. Copy the logged db address and store it in env secret file.

### Hardhad Setup:
1. Update `.env` file for hardhat config with ACCOUNT_ADDRESS, ACCOUNT_PRIVATE_KEY, JSON_RPC_URL, CHAIN_ID
2. Compile & deploy smart contracts using `npm run compile:deploy`
3. Update the CONTRACT_ADDRESS `.env` key after deploying the contract.

### Backend Server Setup:
1. Follow `.env.example` and place all the keys in `.env` file.
2. Start the server using `npm run dev`
