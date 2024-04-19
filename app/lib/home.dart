import 'package:flutter/material.dart';
import 'package:staked_steps/CustomNavigation.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title, required this.w3mService});

  final String title;
  final W3MService w3mService;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
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
