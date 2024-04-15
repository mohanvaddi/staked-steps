import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/utils/pedometer_utils.dart';
import 'package:staked_steps/utils/common_utils.dart';
import 'package:staked_steps/widgets/CustomScreenLayout.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _status = '?', _steps = '?';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScreenLayout(
          context: context,
          w3mService: widget.w3mService,
          steps: _steps,
          screen: Screens.PROFILE,
          body: const TabBarView(
            children: <Widget>[
              Center(),
              Center(),
            ],
          )),
    );
  }
}
