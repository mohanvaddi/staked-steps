import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pedometer/pedometer.dart';
import 'package:web3_poc/theme.dart';
import 'package:web3_poc/utils/pedometer.dart';

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
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
                  text: 'Ongoing',
                ),
                Tab(
                  icon: Icon(Icons.public),
                  text: 'Public',
                ),
                Tab(
                  icon: Icon(Icons.beach_access_sharp),
                  text: 'Private',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 250,
                          color: CustomColors().LIGHT,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  // padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                  child: Center(
                                    child: RichText(
                                      text: const TextSpan(
                                        text:
                                            'This number represents the total steps taken, this is calculated based on the pedometer available.\nIf the text is in green, it means you are currently moving, if It\'s red, it means you\'re idle.',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  child: const Text('Understood'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
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
          body: const TabBarView(
            children: <Widget>[
              Center(
                child: Text("ongoing challenges here"),
              ),
              Center(
                child: Text("public challenges here"),
              ),
              Center(
                child: Text("private challenges here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
