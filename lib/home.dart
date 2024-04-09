import 'package:flutter/material.dart';
import 'package:web3_poc/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  final _steps = '1802';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card.filled(
              color: Colors.green[100],
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    _steps,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 100.0),
                  ),
                ),
              )),
          OutlinedButton(
            onPressed: () {
              showAboutDialog(context: context);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color?>(CustomColors().PRIMARY),
            ),
            child: const Text('Send Transaction'),
          ),
        ],
      ),
    );
  }
}
