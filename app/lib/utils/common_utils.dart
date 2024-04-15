import 'package:flutter/foundation.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

void kPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

// RIP Mumbai :[
W3MChainInfo fetchAmoyChainInfo() => W3MChainInfo(
      chainName: 'Polygon Amoy Testnet',
      chainId: '80002',
      namespace: 'eip155:80002',
      tokenName: 'MATIC',
      rpcUrl: 'https://rpc-amoy.polygon.technology/',
      blockExplorer: W3MBlockExplorer(
        name: 'Amoy',
        url: 'https://www.oklink.com/amoy',
      ),
    );

final Set<String> excludedWalletIds = {
  'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa'
};

W3MService getW3mInstance() {
  String projectId = '48d96f799737c01d9bca749263a6a757';
  return W3MService(
    projectId: projectId,
    logLevel: LogLevel.error,
    metadata: const PairingMetadata(
      name: 'Staked Steps',
      description: 'A gamified fitness app',
      url: 'https://web3modal.com/',
      icons: [
        'https://docs.walletconnect.com/assets/images/web3modalLogo-2cee77e07851ba0a710b56d03d4d09dd.png'
      ],
      redirect: Redirect(
        native: 'flutterdapp://',
        universal: 'https://web3modal.com',
      ),
    ),
    excludedWalletIds: excludedWalletIds,
  );
}

Future<void> initW3mInstance() async {
  await getW3mInstance().init();
}
