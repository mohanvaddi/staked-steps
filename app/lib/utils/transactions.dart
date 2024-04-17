import 'dart:convert';
import 'package:staked_steps/structs.dart';
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

String getAccountAddress(W3MService w3mService) {
  return (w3mService.session?.getAccounts()?[0].split(':')[2])!;
}

Map<String, dynamic> unformatTokenUri(String tokenUri) {
  String base64Data =
      tokenUri.replaceFirst('data:application/json;base64,', '');

  String jsonData = utf8.decode(base64.decode(base64Data));
  return json.decode(jsonData, reviver: (key, value) {
    if (value is String) {
      // ignore: unnecessary_string_interpolations
      return '$value';
    }
    return value;
  });
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

Future<List<dynamic>> fetchUserNfts(
    W3MService w3mService, W3MChainInfo chain) async {
  final String accountAddress = getAccountAddress(w3mService);

  final result = await w3mService.requestReadContract(
    deployedContract: await fetchContract(),
    functionName: 'getOwnedTokens',
    parameters: [EthereumAddress.fromHex(accountAddress)],
    rpcUrl: chain.rpcUrl,
  );

  final nftList = result[0].map((nft) {
    final tokenId = nft[0];
    final metadata = unformatTokenUri(nft[1]);

    return Nft(
      id: tokenId.toString(),
      name: metadata['name'].toString(),
      description: metadata['description'].toString(),
      image: metadata['image'].toString(),
    );
  }).toList();

  return nftList;
}
