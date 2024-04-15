import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pedometer/pedometer.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/theme.dart';
import 'package:staked_steps/utils/pedometer_utils.dart';
import 'package:staked_steps/utils/api_utils.dart' as api_util;
import 'package:staked_steps/utils/common_utils.dart';
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

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: CustomColors().LIGHT,
            title: Text(
              'Staked Steps',
              style: GoogleFonts.teko(
                textStyle: TextStyle(
                  color: Colors.green.shade700,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                  fontSize: 35.00,
                ),
              ),
            ),
            centerTitle: false,
            bottom: const TabBar(
              labelStyle: TextStyle(),
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.access_alarm_sharp),
                  // text: 'Ongoing',
                ),
                Tab(
                  icon: Icon(Icons.public),
                  // text: 'Public',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // TODO: do something here
                  kPrint('show something when clicked');
                },
                child: Text(
                  _steps,
                  style: GoogleFonts.teko(
                    textStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: _status == 'walking'
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Log Out',
                onPressed: () {
                  widget.w3mService.disconnect();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallet Disconnected.'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      color: Colors.amber[colorCodes[index]],
                      child: Center(child: Text('Entry ${entries[index]}')),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
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
                                var stakedAmount =
                                    challengesList[index].stakedAmount;
                                return ListTile(
                                  tileColor: Colors.green.shade50,
                                  title: Text(challenge.challengeName),
                                  subtitle: const Text('progress'),
                                  trailing: Text('$stakedAmount ETH'),
                                  enableFeedback: true,
                                  leading: CircularProgressIndicator(
                                    color: Colors.green.shade400,
                                    value: 0.4,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green.shade200,
                                    ),
                                  ),
                                  onTap: () {
                                    if (kDebugMode) {
                                      print('click3d');
                                    }
                                  },
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
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
      ),
    );
  }
}
