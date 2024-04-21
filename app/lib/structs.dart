import 'package:web3modal_flutter/web3modal_flutter.dart';

class ParticipantData {
  final String name;
  final int daysCompleted;

  ParticipantData({
    required this.name,
    required this.daysCompleted,
  });
}

class ChallengeData {
  final String challengeId;
  final String challengeName;
  final String startDate;
  final String endDate;
  final int totalDays;
  final String stakedAmount;
  final int participantsLimit;
  final int participantsCount;
  final int goal;
  final String creator;
  final String visibility;
  final String status;

  ChallengeData({
    required this.challengeId,
    required this.challengeName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.stakedAmount,
    required this.participantsLimit,
    required this.participantsCount,
    required this.goal,
    required this.creator,
    required this.visibility,
    required this.status,
  });

  factory ChallengeData.fromJson(List<dynamic> challenge) {
    return ChallengeData(
      challengeId: challenge[0].toString(),
      challengeName: challenge[1].toString(),
      startDate: challenge[2].toString(),
      endDate: challenge[3].toString(),
      totalDays: int.parse(challenge[4].toString()),
      stakedAmount: challenge[5].toString(),
      participantsLimit: int.parse(challenge[6].toString()),
      goal: int.parse(challenge[7].toString()),
      creator: EthereumAddress.fromHex(challenge[8].toString()).toString(),
      status: challenge[9].toString() == '0' ? 'ongoing' : 'completed',
      visibility: challenge[10].toString() == '0' ? 'public' : 'private',
      participantsCount: int.parse(challenge[11].toString()),
    );
  }
}

class Nft {
  final String id;
  final String name;
  final String description;
  final String image;

  Nft({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });
}

class ContractInfo {
  final String address;
  final List<dynamic> abi;

  ContractInfo({required this.address, required this.abi});
}
