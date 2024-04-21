import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/utils/common_utils.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:staked_steps/utils/api_utils.dart' as api_util;
import 'package:http/http.dart' as http;

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

FutureOr<List<dynamic>> fetchUserNfts(
  W3MService w3mService,
  W3MChainInfo chain,
) async {
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

Future<List<ChallengeData>> fetchPublicChallenges(
  W3MService w3mService,
  W3MChainInfo chain,
) async {
  final result = await w3mService.requestReadContract(
    deployedContract: await fetchContract(),
    functionName: 'publicChallenges',
    parameters: [],
    rpcUrl: chain.rpcUrl,
  );

  final userChallenges = await w3mService.requestReadContract(
    deployedContract: await fetchContract(),
    functionName: 'getUserChallenges',
    parameters: [EthereumAddress.fromHex(getAccountAddress(w3mService))],
    rpcUrl: chain.rpcUrl,
  );

  List<dynamic> challenges = result[0];
  final List<ChallengeData> challengesList = challenges.map((challenge) {
    return ChallengeData.fromJson(challenge);
  }).toList();

  List<dynamic> userChallengesDynamic = userChallenges[0];
  final List<String> userChallengesList =
      userChallengesDynamic.map((challenge) {
    return ChallengeData.fromJson(challenge).challengeId;
  }).toList();

  return challengesList
      .where((challenge) => !userChallengesList.contains(challenge.challengeId))
      .toList();
}

enum ChallengesFilter { ONGOING, COMPLETED }

Future<List<ChallengeData>> fetchUserChallenges(
    W3MService w3mService, W3MChainInfo chain, ChallengesFilter filter) async {
  final result = await w3mService.requestReadContract(
    deployedContract: await fetchContract(),
    functionName: 'getUserChallenges',
    parameters: [EthereumAddress.fromHex(getAccountAddress(w3mService))],
    rpcUrl: chain.rpcUrl,
  );

  List<dynamic> challenges = result[0];
  final List<ChallengeData> challengesList = challenges.map((challenge) {
    return ChallengeData.fromJson(challenge);
  }).toList();

  if (filter == ChallengesFilter.COMPLETED) {
    return challengesList
        .where((challenge) => challenge.status == 'completed')
        .toList();
  } else {
    return challengesList
        .where((challenge) => challenge.status == 'ongoing')
        .toList();
  }
}

Future<dynamic> customReadContract(W3MService w3mService, String functionName,
    List<dynamic> parameters) async {
  final contract = await fetchContract();
  try {
    final result = await w3mService.requestReadContract(
      deployedContract: contract,
      functionName: functionName,
      parameters: [...parameters],
      rpcUrl: currentChain.rpcUrl,
    );
    return result;
  } catch (e) {
    print(e);
  }
}

Future<void> customWriteContract(
  W3MService w3mService,
  String functionName,
  List<dynamic> parameters,
  EtherAmount value,
) async {
  final contract = await fetchContract();
  final transferFunc = contract.function(functionName);

  // final chainId = currentChain.chainId;
  // final chainNamespace = currentChain.namespace;
  // final jsonRpcUrl = currentChain.rpcUrl;

  if (w3mService.selectedChain!.namespace != currentChain.namespace) {
    await w3mService.selectChain(currentChain, switchChain: true);
  }

  final ethClient = Web3Client(
    W3MChainPresets.chains[w3mService.session?.chainId]!.rpcUrl,
    http.Client(),
  );

  Credentials credentials = CustomCredentialsSender(
    signEngine: w3mService.web3App!.signEngine,
    sessionTopic: w3mService.session!.topic!,
    chainId: w3mService.selectedChain!.namespace,
    credentialAddress: EthereumAddress.fromHex(w3mService.session!.address!),
  );

  final transaction = Transaction.callContract(
    contract: contract,
    function: transferFunc,
    parameters: [...parameters],
    value: value,
  );

  await w3mService.launchConnectedWallet();
  final result = ethClient.sendTransaction(
    credentials,
    transaction,
    chainId: int.parse(w3mService.selectedChain!.chainId),
  );

  w3mService.addListener(() {
    result;
  });
}

class CustomCredentialsSender extends CustomTransactionSender {
  CustomCredentialsSender({
    required this.signEngine,
    required this.sessionTopic,
    required this.chainId,
    required this.credentialAddress,
  });

  final ISignEngine signEngine;
  final String sessionTopic;
  final String chainId;
  final EthereumAddress credentialAddress;

  @override
  EthereumAddress get address => credentialAddress;

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    if (kDebugMode) {
      print(
          'CustomCredentialsSender: sendTransaction - transaction: ${transaction}');
    }

    if (!signEngine.getActiveSessions().keys.contains(sessionTopic)) {
      if (kDebugMode) {
        print(
            'sendTransaction - called with invalid sessionTopic: $sessionTopic');
      }
      return 'Internal Error - sendTransaction - called with invalid sessionTopic';
    }

    SessionRequestParams sessionRequestParams = SessionRequestParams(
      method: 'eth_sendTransaction',
      params: [
        {
          'from': transaction.from?.hex ?? credentialAddress.hex,
          'to': transaction.to?.hex,
          'data':
              (transaction.data != null) ? bytesToHex(transaction.data!) : null,
          if (transaction.value != null)
            'value':
                '0x${transaction.value?.getInWei.toRadixString(16) ?? '0'}',
          if (transaction.maxGas != null)
            'gas': '0x${transaction.maxGas?.toRadixString(16)}',
          if (transaction.gasPrice != null)
            'gasPrice': '0x${transaction.gasPrice?.getInWei.toRadixString(16)}',
          if (transaction.nonce != null) 'nonce': transaction.nonce,
        }
      ],
    );

    if (kDebugMode) {
      print(
          'CustomCredentialsSender: sendTransaction - blockchain $chainId, sessionRequestParams: ${sessionRequestParams.toJson()}');
    }

    final hash = await signEngine.request(
      topic: sessionTopic,
      chainId: chainId,
      request: sessionRequestParams,
    );
    return hash;
  }

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }

  @override
  MsgSignature signToEcSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToEcSignature
    throw UnimplementedError();
  }
}
