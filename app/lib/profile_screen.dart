import 'package:flutter/material.dart';
import 'package:web3_poc/challenges_screen.dart';
import 'package:web3_poc/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentPageIndex = 0;
  final _steps = '1802';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors().LIGHT,
        title: const Text(
          'StreakQuest',
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
      body: Column(
        children: <Widget>[
          Card.outlined(
            color: CustomColors().PRIMARY_LIGHT,
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      _steps,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 80.0),
                    ),
                    const Text(
                      'Steps',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // OutlinedButton(
          //   onPressed: () {
          //     showAboutDialog(context: context);
          //   },
          //   style: ButtonStyle(
          //     backgroundColor:
          //         MaterialStateProperty.all<Color?>(CustomColors().PRIMARY),
          //   ),
          //   child: const Text('Send Transaction'),
          // ),
        ],
      ),
    );
  }
}
