# Staked Steps

<p align="left">
  <img src="https://github.com/mohanvaddi/staked-steps/assets/58596948/84cce486-867b-46df-bfa8-96e537a1755e" alt="BargainSherlock Logo" width="200">
</p>


Staked Steps is a mobile application that combines fitness challenges with gamified elements and blockchain technology to motivate users and create a more engaging exercise experience. Users can create or join private or public challenges, where they compete based on daily step counts. Winners are rewarded with a share of the staked Ether and NFTs.

> This Project was made as a submission for [EthGlobal Scaling Ethereum 2024](https://ethglobal.com/events/scaling2024/)


## Key Features
- Challenge Creation: Define private or public challenges, set minimum daily step counts, duration, and staking requirements.
- Challenge Participation: Join existing challenges and stake the defined amount of Ether.
- Step Tracking: Integrated with fitness apps like apple health.
- Automatic Prize Distribution: Upon challenge completion, smart contracts automatically distribute rewards based on the pre-defined model.
- Liquid Staking: Implemented liquid staking to potentially reduce fees, cover platform costs, or offer rewards (concept under exploration).
- NFT Integration: NFTs are minted to the winners as challenge rewards.

## Tech Stack
- App development: Flutter
- Backend: Node.js 
- Smart Contracts: Solidity
- Smart Contract Interaction: Ethers.js and Web3ModalFlutter
- IPFS: lighthouse.storage
- Wallet Connection: WalletConnect
- Testnet: Base sepolia, and Ganache for local testing.


# Stretch Goals
We're thinking of developing the app even after the hackathon is ended, here are the high-level features that we've want to implement
 - Seamless integration between metamask and staked steps app.
 - Liquid staking should be done end-to-end on the contract itself
   

