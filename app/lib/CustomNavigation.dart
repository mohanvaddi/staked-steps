import 'package:flutter/material.dart';
import 'package:staked_steps/CreateChallengePage.dart';
import 'package:staked_steps/screens/ChallengesScreen.dart';
import 'package:staked_steps/screens/ProfileScreen.dart';
import 'package:staked_steps/constants.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:flutter/services.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return Scaffold(
      // bottom navgation bar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: CustomColors().PRIMARY,
        backgroundColor: CustomColors().LIGHT,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.access_time_filled),
            icon: Icon(Icons.access_time_outlined),
            label: 'Challenges',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),

      // navigation body
      body: <Widget>[
        ChallengesScreen(
          w3mService: widget.w3mService,
        ),
        ProfileScreen(
          w3mService: widget.w3mService,
        ),
      ][currentPageIndex],

      // fab button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return CreateChallengePage(
                w3mService: widget.w3mService,
              );
            },
          ));
        },
        tooltip: 'Create Quest',
        enableFeedback: true,
        backgroundColor: CustomColors().PRIMARY,
        child: const Icon(Icons.add_task_outlined),
      ),
    );
  }
}
