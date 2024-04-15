class ParticipantData {
  final String name;
  final int daysCompleted;

  ParticipantData({
    required this.name,
    required this.daysCompleted,
  });
}

class ChallengeData {
  final String challengeName;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final double stakedAmount;
  final int totalParticipants;
  final List<ParticipantData> participants;

  ChallengeData({
    required this.challengeName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.stakedAmount,
    required this.participants,
    required this.totalParticipants,
  });

  factory ChallengeData.fromJson(Map<String, dynamic> json) {
    return ChallengeData(
      challengeName: json['challengeName'],
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
      totalDays: json['totalDays'],
      stakedAmount: json['stakedAmount'],
      totalParticipants: json['totalParticipants'],
      participants:
          (json['participants'] as List<dynamic>).map((participantJson) {
        return ParticipantData(
          name: participantJson['name'],
          daysCompleted: participantJson['daysCompleted'],
        );
      }).toList(),
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

  factory Nft.fromJson(dynamic json) {
    return Nft(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image']);
  }
}

class ContractInfo {
  final String address;
  final List<dynamic> abi;

  ContractInfo({required this.address, required this.abi});
}
