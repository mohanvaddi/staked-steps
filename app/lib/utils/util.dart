import 'package:web3modal_flutter/web3modal_flutter.dart';

final _sepolia = W3MChainInfo(
  chainName: 'Sepolia Testnet',
  chainId: '11155111',
  namespace: 'eip155:11155111',
  tokenName: 'SEP',
  rpcUrl: 'https://ethereum-sepolia.publicnode.com',
  blockExplorer: W3MBlockExplorer(
    name: 'Sepolia Etherscan',
    url: 'https://sepolia.etherscan.io/',
  ),
);
