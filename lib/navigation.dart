import 'package:flutter/material.dart';
import 'package:web3_poc/home.dart';
import 'package:web3_poc/theme.dart';

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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // appbar
      appBar: AppBar(
        backgroundColor: CustomColors().PRIMARY_LIGHT,
        title: const Text('Web3 metamask '),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),

      // bottom navgation bar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: CustomColors().SECONDARY,
        backgroundColor: CustomColors().PRIMARY_LIGHT,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.access_time_filled),
            icon: Icon(Icons.access_time_outlined),
            label: 'Challenges',
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
        const HomeScreen(),
        const Text('dsad'),
      ][currentPageIndex],

      // fab button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Create Challenge',
        enableFeedback: true,
        backgroundColor: Colors.green[200],
        child: const Icon(Icons.add_task_outlined),
      ),
    );
  }
}
