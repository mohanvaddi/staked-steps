// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
// import 'package:web3_poc/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Web3ModalTheme(
        isDarkMode: false,
        themeData: Web3ModalThemeData(
          lightColors: Web3ModalColors.lightMode.copyWith(
            accent100: (Colors.green[300])!,
            background125: (Colors.green[100])!,
            foreground100: Colors.black,
            background100: (Colors.black),
            inverse100: Colors.black54,
          ),
          darkColors: Web3ModalColors.darkMode.copyWith(
            accent100: (Colors.green[300])!,
            background125: (Colors.black87),
            foreground100: (Colors.green[400])!,
            background100: (Colors.green[400])!,
            inverse100: Colors.black54,
          ),
          // radiuses: Web3ModalRadiuses.square
        ),
        child: MaterialApp(
          title: 'Flutter',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Flutter'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String projectId = '48d96f799737c01d9bca749263a6a757';
  late W3MService _w3mService;

  @override
  void initState() {
    super.initState();
    _initializeService();
    initPedometer();
  }

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
  }

  void initPedometer() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  void _initializeService() async {
    // See https://docs.walletconnect.com/web3modal/flutter/custom-chains
    // W3MChainPresets.chains.putIfAbsent(_sepolia.chainId, () => _sepolia);

    _w3mService = W3MService(
      projectId: projectId,
      logLevel: LogLevel.error,
      metadata: const PairingMetadata(
        name: 'Web3 Title',
        description: 'web3 description',
        url: 'https://web3modal.com/',
        icons: [
          'https://docs.walletconnect.com/assets/images/web3modalLogo-2cee77e07851ba0a710b56d03d4d09dd.png'
        ],
        redirect: Redirect(
          native: 'web3m://',
          universal: 'https://web3modal.com',
        ),
      ),
    );

    await _w3mService.init();
    setState(() {});
  }

  // final _sepolia = W3MChainInfo(
  //   chainName: 'Sepolia Testnet',
  //   chainId: '11155111',
  //   namespace: 'eip155:11155111',
  //   tokenName: 'SEP',
  //   rpcUrl: 'https://ethereum-sepolia.publicnode.com',
  //   blockExplorer: W3MBlockExplorer(
  //     name: 'Sepolia Etherscan',
  //     url: 'https://sepolia.etherscan.io/',
  //   ),
  // );

  void sendTransaction() async {
    _w3mService.launchConnectedWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text('Web3 metamask '),
        // leading: IconButton(
        //   icon: const Icon(Icons.login),
        //   onPressed: () {},
        // ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              print('Showing a snack bar');
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            W3MConnectWalletButton(
              service: _w3mService,
              state: ConnectButtonState.none,
            ),
            OutlinedButton(
              onPressed: sendTransaction,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color?>(Colors.green[200])),
              child: const Text('Send Transaction'),
            ),
            Text('status: $_status'),
            Text('steps taken: $_steps')
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: launchMetamask,
      //   tooltip: 'Metamask',
      //   enableFeedback: true,
      //   backgroundColor: Colors.green[200],
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
