import 'package:flutter/material.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/utils/api_utils.dart' as api_util;
import 'package:staked_steps/utils/common_utils.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class OngoingQuests extends StatefulWidget {
  const OngoingQuests({super.key, required this.w3mService});

  final W3MService w3mService;
  @override
  State<OngoingQuests> createState() => _OngoingQuestsState();
}

class _OngoingQuestsState extends State<OngoingQuests> {
  late Future<void> futureChallenges;
  late List<ChallengeData> challengesList;

  Future<void> _initChallenges() async {
    final List<ChallengeData> challenges = await api_util.fetchChallengeData();
    challengesList = challenges;
  }

  Future<void> _refreshChallenges() async {
    final challenges = await api_util.fetchChallengeData();
    setState(() {
      challengesList = challenges;
    });
  }

  @override
  void initState() {
    super.initState();

    kPrint('updating data');
    futureChallenges = _initChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: futureChallenges,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('${snapshot.error}');

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            {
              return const CircularProgressIndicator();
            }
          case ConnectionState.done:
            {
              return RefreshIndicator(
                onRefresh: _refreshChallenges,
                child: ListView.separated(
                  // padding: const EdgeInsets.all(5),
                  itemCount: challengesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var challenge = challengesList[index];
                    return ListTile(
                      tileColor: Colors.green.shade50,
                      title: Text(challenge.challengeName),
                      subtitle: const Text('progress'),
                      trailing:
                          Text('${challengesList[index].stakedAmount} ETH'),
                      enableFeedback: true,
                      leading: CircularProgressIndicator(
                        color: Colors.green.shade400,
                        value: 0.4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green.shade200,
                        ),
                      ),
                      onTap: () {
                        kPrint('clicked');
                      },
                    );
                  },
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return const Divider(
                      height: 4,
                    );
                  },
                ),
              );
            }
        }
      },
    );
  }
}
