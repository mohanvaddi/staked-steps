import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staked_steps/constants.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class CustomScreenLayout extends StatelessWidget {
  final BuildContext context;
  final W3MService w3mService;
  final String steps;
  final Screens screen;
  final Widget body;

  const CustomScreenLayout({
    super.key,
    required this.context,
    required this.w3mService,
    required this.steps,
    required this.screen,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          bottom: TabBar(
            labelStyle: const TextStyle(),
            tabs: screen == Screens.PROFILE
                ? <Widget>[
                    Visibility(
                      visible: screen == Screens.PROFILE,
                      child: const Tab(
                        icon: Icon(Icons.history),
                        // text: 'History',
                      ),
                    ),
                    Visibility(
                      visible: screen == Screens.PROFILE,
                      child: const Tab(
                        icon: Icon(Icons.image),
                        // text: 'Gallery',
                      ),
                    ),
                  ]
                : [
                    Visibility(
                      visible: screen == Screens.CHALLENGES,
                      child: const Tab(
                        icon: Icon(Icons.access_alarm_sharp),
                        // text: 'Ongoing',
                      ),
                    ),
                    Visibility(
                      visible: screen == Screens.CHALLENGES,
                      child: const Tab(
                        icon: Icon(Icons.public),
                        // text: 'Public',
                      ),
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
                                          fontSize: 14.0, color: Colors.black),
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
                steps,
                style: GoogleFonts.teko(
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    // color: _status == 'walking'
                    //     ? Colors.green.shade700
                    //     : Colors.red.shade700,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log Out',
              onPressed: () {
                w3mService.disconnect();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wallet Disconnected.'),
                  ),
                );
              },
            ),
          ],
        ),
        body: body,
      ),
    );
  }
}
