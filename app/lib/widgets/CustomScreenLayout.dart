import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:staked_steps/constants.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class CustomScreenLayout extends StatefulWidget {
  const CustomScreenLayout({
    super.key,
    required this.context,
    required this.w3mService,
    required this.screen,
    required this.body,
  });

  final BuildContext context;
  final W3MService w3mService;
  final Screens screen;
  final Widget body;

  @override
  State<CustomScreenLayout> createState() => _CustomScreenLayoutState();
}

class _CustomScreenLayoutState extends State<CustomScreenLayout> {
  String _steps = '?';

  @override
  void initState() {
    Health().configure(useHealthConnectIfAvailable: true);
    authorize();
    fetchSteps();

    super.initState();
  }

  static final types = [
    HealthDataType.STEPS,
    // HealthDataType.HEIGHT,
  ];

  List<HealthDataAccess> get permissions =>
      types.map((e) => HealthDataAccess.READ).toList();

  /// Authorize, i.e. get permissions to access relevant health data.
  Future<void> authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have health permissions
    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }
    debugPrint('Healthkit authorized: $authorized');

    setState(() => {});
  }

  Future<int?> fetchSteps() async {
    DateTime now = DateTime.now();
    DateTime todayMidnight = DateTime(now.year, now.month, now.day);
    int? steps = await Health().getTotalStepsInInterval(todayMidnight, now);

    setState(() {
      _steps = steps != null ? steps.toString() : '0';
    });

    return steps;
  }

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
                fontWeight: FontWeight.w800,
                fontSize: 35.00,
              ),
            ),
          ),
          bottom: TabBar(
            tabs: widget.screen == Screens.PROFILE
                ? <Widget>[
                    Visibility(
                      visible: widget.screen == Screens.PROFILE,
                      child: const Tab(
                        icon: Icon(Icons.history),
                        // text: 'History',
                      ),
                    ),
                    Visibility(
                      visible: widget.screen == Screens.PROFILE,
                      child: const Tab(
                        icon: Icon(Icons.image),
                        // text: 'Gallery',
                      ),
                    ),
                  ]
                : [
                    Visibility(
                      visible: widget.screen == Screens.CHALLENGES,
                      child: const Tab(
                        icon: Icon(Icons.access_alarm_sharp),
                        // text: 'Ongoing',
                      ),
                    ),
                    Visibility(
                      visible: widget.screen == Screens.CHALLENGES,
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
                _steps,
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
              onPressed: () async {
                try {
                  await widget.w3mService.disconnect();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallet Disconnected.'),
                    ),
                  );
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error when disconnecting wallet.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: widget.body,
      ),
    );
  }
}
