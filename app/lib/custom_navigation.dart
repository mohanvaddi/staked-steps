import 'package:flutter/material.dart';
import 'package:staked_steps/screens/challenges_screen.dart';
import 'package:staked_steps/screens/profile_screen.dart';
import 'package:staked_steps/theme.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const CustomNavigation(),
    );
  }
}

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({super.key});

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
        indicatorColor: CustomColors().SECONDARY,
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
        const ChallengesScreen(),
        const ProfileScreen(),
      ][currentPageIndex],

      // fab button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Create new Quest'),
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
        tooltip: 'Create Challenge',
        enableFeedback: true,
        backgroundColor: Colors.green[200],
        child: const Icon(Icons.add_task_outlined),
      ),
    );
  }
}
