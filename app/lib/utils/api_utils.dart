import 'dart:convert';
import 'package:staked_steps/structs.dart';
import 'package:http/http.dart' as http;

const apiUrl = 'https://massive-finer-mudfish.ngrok-free.app';
// const apiUrl = 'http://localhost:4002';

// Future<List<ChallengeData>> fetchChallengeData() async {
//   final response = await http.get(Uri.parse('$apiUrl/mockChallenges'));

//   if (response.statusCode == 200) {
//     Map<String, dynamic> jsonData = json.decode(response.body);
//     List<dynamic> challenges = jsonData['challenges'];
//     List<ChallengeData> challengeDataList = challenges.map(
//       (challengeJson) {
//         return ChallengeData.fromJson(challengeJson);
//       },
//     ).toList();
//     return challengeDataList;
//   } else {
//     throw Exception('Failed to load challenges data');
//   }
// }

Future<ContractInfo> fetchContractInfo() async {
  final response = await http.get(Uri.parse('$apiUrl/contract-info'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);
    return ContractInfo(address: jsonData['address'], abi: jsonData['abi']);
  } else {
    throw Exception('Failed to load contract info');
  }
}
