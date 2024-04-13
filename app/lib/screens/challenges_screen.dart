import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pedometer/pedometer.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/theme.dart';
import 'package:staked_steps/utils/pedometer.dart';
import 'package:http/http.dart' as http;

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPedometer(
      (StepCount event) {
        setState(() {
          print(event);
          _steps = event.steps.toString();
        });
      },
      (PedestrianStatus event) {
        setState(() {
          print(event);
          _status = event.status;
        });
      },
    );
  }

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

  // TODO: handle page refresh logic here
  Future<void> _handlePageRefresh() async {
    print('page refreshed');

    List<ChallengeData> updatedChallengeData = await fetchChallengeData();
    setState(() {
      challenges = updatedChallengeData;
    });
  }

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  List<ChallengeData> challenges = <ChallengeData>[
    ChallengeData(
      challengeName: 'Challenge #1',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Apple', daysCompleted: 4),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Vijay', daysCompleted: 3),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #2',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
        ParticipantData(name: 'Vijay', daysCompleted: 3),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
    ChallengeData(
      challengeName: 'Challenge #3',
      startDate: DateTime(1713004804235),
      endDate: DateTime(1713004804235),
      totalDays: 10,
      stakedAmount: 0.1.toDouble(),
      totalParticipants: 10,
      participants: [
        ParticipantData(name: 'Vijay', daysCompleted: 3),
        ParticipantData(name: 'Mohan', daysCompleted: 5),
        ParticipantData(name: 'Apple', daysCompleted: 4),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
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
                  print('show something when clicked');
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
                icon: const Icon(Icons.more_vert),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This is a snackbar')));
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
                child: RefreshIndicator(
                  onRefresh: _handlePageRefresh,
                  child: ListView.separated(
                    // padding: const EdgeInsets.all(5),
                    itemCount: challenges.length,
                    itemBuilder: (BuildContext context, int index) {
                      var challenge = challenges[index];
                      var stakedAmount = challenges[index].stakedAmount;
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
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 4,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
