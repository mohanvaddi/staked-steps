import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/tabs/OngoingQuests.dart';
import 'package:staked_steps/utils/pedometer_utils.dart';
import 'package:staked_steps/utils/api_utils.dart' as api_util;
import 'package:staked_steps/utils/common_utils.dart';
import 'package:staked_steps/widgets/CustomScreenLayout.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  String _status = '?', _steps = '?';
  late Future<void> futureChallenges;
  late List<ChallengeData> challengesList;
  late ContractInfo contractInfo;

  @override
  void initState() {
    super.initState();
    initPedometer(
      (StepCount event) {
        setState(() {
          kPrint(event);
          _steps = event.steps.toString();
        });
      },
      (PedestrianStatus event) {
        setState(() {
          kPrint(event);
          _status = event.status;
        });
      },
    );

    futureChallenges = _initChallenges();
  }

  // Future<void> _initABI() async {
  //   final ContractInfo _contractInfo = await api_util.fetchContractInfo();
  // }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScreenLayout(
        context: context,
        w3mService: widget.w3mService,
        steps: _steps,
        screen: Screens.CHALLENGES,
        body: TabBarView(
          children: <Widget>[
            Center(
              child: OngoingQuests(
                w3mService: widget.w3mService,
              ),
            ),
            Center(
              child: FutureBuilder<void>(
                future: futureChallenges,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('${snapshot.error}');

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      {
                        return const Center(
                          child: Text('Loading...'),
                        );
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
                                trailing: Text(
                                    '${challengesList[index].stakedAmount} ETH'),
                                enableFeedback: true,
                                leading: CircularProgressIndicator(
                                  color: Colors.green.shade400,
                                  value: 0.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green.shade200,
                                  ),
                                ),
                                onTap: () async {
                                  kPrint('click3d');
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
