import 'dart:convert';
import 'package:staked_steps/structs.dart';
import 'package:http/http.dart' as http;

const apiUrl = 'https://massive-finer-mudfish.ngrok-free.app';

Future<List<ChallengeData>> fetchChallengeData() async {
  final response = await http.get(Uri.parse('$apiUrl/mockChallenges'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);
    List<dynamic> challenges = jsonData['challenges'];
    List<ChallengeData> challengeDataList = challenges.map(
      (challengeJson) {
        return ChallengeData.fromJson(challengeJson);
      },
    ).toList();
    return challengeDataList;
  } else {
    throw Exception('Failed to load challenges data');
  }
}

Future<List<Nft>> fetchNfts() async {
  final response = await http.get(Uri.parse('$apiUrl/mockNfts'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    List<Nft> nftList = jsonData.map(
      (nftJson) {
        return Nft.fromJson(nftJson);
      },
    ).toList();
    return nftList;
  } else {
    throw Exception('Failed to load nft list');
  }
}

Future<ContractInfo> fetchContractInfo() async {
  final response = await http.get(Uri.parse('$apiUrl/contract-info'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);
    return ContractInfo(address: jsonData['address'], abi: jsonData['abi']);
  } else {
    throw Exception('Failed to load contract info');
  }
}
