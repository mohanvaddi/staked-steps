import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/home.dart';
import 'package:staked_steps/login.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:intl/intl.dart';

void kPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

// RIP Mumbai :[
W3MChainInfo fetchAmoyChainInfo() => W3MChainInfo(
      chainName: 'Polygon Amoy Testnet',
      chainId: '80002',
      namespace: 'eip155:80002',
      tokenName: 'MATIC',
      rpcUrl: 'https://rpc-amoy.polygon.technology/',
      blockExplorer: W3MBlockExplorer(
        name: 'Amoy',
        url: 'https://www.oklink.com/amoy',
      ),
    );

final Set<String> excludedWalletIds = {
  'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa'
};

W3MChainInfo fetchBaseSepolia() => W3MChainInfo(
      chainName: 'Base Sepolia',
      chainId: '84532',
      namespace: 'eip155:84532',
      tokenName: 'ETH',
      rpcUrl: 'https://sepolia.base.org',
      blockExplorer: W3MBlockExplorer(
        name: 'Basescan',
        url: 'https://sepolia.basescan.org',
      ),
    );

W3MService getW3mInstance() {
  String projectId = '48d96f799737c01d9bca749263a6a757';
  return W3MService(
    projectId: projectId,
    logLevel: LogLevel.error,
    metadata: const PairingMetadata(
      name: 'Staked Steps',
      description: 'A gamified fitness app',
      url: 'https://web3modal.com/',
      icons: [
        'https://docs.walletconnect.com/assets/images/web3modalLogo-2cee77e07851ba0a710b56d03d4d09dd.png'
      ],
      redirect: Redirect(
        native: 'flutterdapp://',
        universal: 'https://web3modal.com',
      ),
    ),
    excludedWalletIds: excludedWalletIds,
  );
}

Future<W3MService> initW3mInstance(BuildContext context, setState) async {
  final w3mService = getW3mInstance();
  w3mService.init();

  void onModalConnect(ModalConnect? event) async {
    if (event != null) {
      w3mService.selectChain(fetchBaseSepolia(), switchChain: true);
      changeRoute('_onModalConnet', context, w3mService, Pages.home, setState);
    }
  }

  void onModalDisconnect(ModalDisconnect? event) {
    if (event != null) {
      if (w3mService.isConnected) {
        w3mService.disconnect();
      }
    }
    changeRoute(
        '_onModalDisconnect', context, w3mService, Pages.login, setState);
  }

  void onModalError(ModalError? event) {
    if (event != null) {
      if ((event.message).contains('Coinbase Wallet Error')) {
        w3mService.disconnect();
      }
    }
    changeRoute('_onModalError', context, w3mService, Pages.login, setState);
  }

  void onSessionUpdate(SessionUpdate? event) {
    if (event != null) {
      if (!w3mService.isConnected) {
        changeRoute('disconnected on session update', context, w3mService,
            Pages.login, setState);
      }
      debugPrint('[walletEvent] _onSessionUpdate ${event.toString()}');
    }
  }

  void onSessionEvent(SessionEvent? event) {
    if (event != null) {
      debugPrint('[walletEvent] _onSessionEvent ${event.toString()}');
    }
  }

  w3mService.onModalConnect.subscribe(onModalConnect);
  w3mService.onModalDisconnect.subscribe(onModalDisconnect);
  w3mService.onModalError.subscribe(onModalError);
  w3mService.onSessionUpdateEvent.subscribe(onSessionUpdate);
  w3mService.onSessionEventEvent.subscribe(onSessionEvent);

  if (w3mService.isConnected) {
    changeRoute('_default', context, w3mService, Pages.home, setState);
  }
  setState(() {});

  w3mService.selectChain(fetchBaseSepolia(), switchChain: true);

  return w3mService;
}

double getDoubleFromBigIntETH(BigInt value) {
  return value / BigInt.from(10).pow(18);
}

String epochToReadableDateTime(int epochSeconds) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  String formattedDateTime = formatter.format(dateTime);
  return formattedDateTime;
}

String formatReadableDateTime(DateTime dateTime) {
  // List of month names
  List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // Get day with ordinal suffix
  String getOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  String month = monthNames[dateTime.month - 1];
  String ordinalDay = getOrdinal(dateTime.day);
  String year = dateTime.year.toString();

  return '${dateTime.weekday} $month $ordinalDay $year';
}

void changeRoute(String eventName, BuildContext context, W3MService w3mService,
    Enum page, setState) {
  debugPrint('[walletEvent] $eventName');
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) {
      if (page == Pages.home) {
        w3mService.selectChain(fetchBaseSepolia(), switchChain: true);
        return Home(
          title: 'Staked Steps',
          w3mService: w3mService,
        );
      } else {
        return const Login(
          title: 'Staked Steps',
        );
      }
    }),
  );
  setState(() {});
}
