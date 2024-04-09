// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:web3_poc/custom_navigation.dart';
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
    initWalletConnect();
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

  void initWalletConnect() async {
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

  void sendTransaction() async {
    _w3mService.launchConnectedWallet();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       W3MConnectWalletButton(
      //         service: _w3mService,
      //         state: ConnectButtonState.none,
      //       ),
      //       OutlinedButton(
      //         onPressed: sendTransaction,
      //         style: ButtonStyle(
      //             backgroundColor:
      //                 MaterialStateProperty.all<Color?>(Colors.green[200])),
      //         child: const Text('Send Transaction'),
      //       ),
      //       Text('status: $_status'),
      //       Text('steps taken: $_steps')
      //     ],
      //   ),
      // ),
      body: CustomNavigation(),
    );
  }
}
