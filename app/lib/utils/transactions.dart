import 'dart:convert';
import 'package:http/retry.dart';
import 'package:staked_steps/utils/common_utils.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:staked_steps/utils/api_utils.dart' as api_util;

Future<DeployedContract> fetchContract() async {
  final contract = await api_util.fetchContractInfo();
  return DeployedContract(
    ContractAbi.fromJson(
      jsonEncode(contract.abi), // ABI object
      'BaseContract',
    ),
    EthereumAddress.fromHex(contract.address), // Contract address
  );
}

Map<String, dynamic> unformatTokenUri(String tokenUri) {
  String base64Data =
      tokenUri.replaceFirst('data:application/json;base64,', '');

  String jsonData = utf8.decode(base64.decode(base64Data));
  return json.decode(jsonData);
}

Future<void> getWalletBalance(W3MService w3mService, W3MChainInfo chain) async {
  // Get balance of wallet
  final result = await w3mService.requestReadContract(
    deployedContract: await fetchContract(),
    functionName: 'getMaxSupply',
    rpcUrl: chain.rpcUrl,
  );

  kPrint(result);
}

Future<void> fetchUserNfts(W3MService w3mService, W3MChainInfo chain) async {
  final String accountAddress =
      (w3mService.session?.getAccounts()?[0].split(':')[2])!;

  print('above result');
  final dynamic result = await w3mService.requestReadContract(
    deployedContract: await fetchContract(),
    functionName: 'getOwnedTokens',
    parameters: [EthereumAddress.fromHex(accountAddress)],
    rpcUrl: chain.rpcUrl,
  );

  final dynamic res = result[0].map((nft) {
    final unf = unformatTokenUri(nft);
    print(unf);
    return unf;
  }).toList();

  print(res[0].name);
}
