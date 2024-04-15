import 'package:flutter/material.dart';
import 'package:staked_steps/screens/ChallengesScreen.dart';
import 'package:staked_steps/screens/ProfileScreen.dart';
import 'package:staked_steps/constants.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

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
            label: 'Quests',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
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
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Create Quest'),
                ),
                body: const Center(
                  child: Text(
                    'form to create public and private quests here',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
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
