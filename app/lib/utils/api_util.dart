import 'dart:convert';
import 'package:staked_steps/structs.dart';
import 'package:http/http.dart' as http;

Future<List<ChallengeData>> fetchChallengeData() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:4002/mock_challenges'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);
    List<dynamic> challenges = jsonData['challenges'];
    List<ChallengeData> challengeDataList = challenges.map((challengeJson) {
      return ChallengeData.fromJson(challengeJson);
    }).toList();
    return challengeDataList;
  } else {
    throw Exception('Failed to load challenges data');
  }
}
