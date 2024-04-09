import 'package:flutter/material.dart';
import 'package:web3_poc/theme.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return const Scaffold(
      body: ChallengesTabBar(),
    );
  }
}

class ChallengesTabBar extends StatelessWidget {
  const ChallengesTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors().LIGHT,
          title: const Text('StreakQuest'),
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
    );
  }
}
