import 'package:flutter/material.dart';
import 'package:staked_steps/CustomNavigation.dart';
import 'package:staked_steps/utils/common_utils.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title, required this.w3mService});

  final String title;
  final W3MService w3mService;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String projectId = '48d96f799737c01d9bca749263a6a757';

  @override
  void initState() {
    super.initState();
  }

  void onPedestrianStatusError(error) {
    kPrint('onPedestrianStatusError: $error');
  }

  void onStepCountError(error) {
    kPrint('onStepCountError: $error');
  }

  void sendTransaction() async {
    widget.w3mService.launchConnectedWallet();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: CustomNavigation(
          w3mService: widget.w3mService,
        ),
      ),
    );
  }
}
