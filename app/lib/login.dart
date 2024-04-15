import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staked_steps/Home.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/utils/common_utils.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late W3MService _w3mService;

  @override
  void initState() {
    super.initState();
    initWalletConnect();
  }

  // @override
  // void dispose() {
  //   _w3mService.onModalConnect.unsubscribe(_onModalConnect);
  //   super.dispose();
  // }

  void changeRoute(String eventName, Enum page) {
    debugPrint('[walletEvent] $eventName');
    setState(() {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        if (page == Pages.home) {
          return Home(
            title: 'Staked Steps',
            w3mService: _w3mService,
          );
        } else {
          return const Login(
            title: 'Staked Steps',
          );
        }
      }),
    );
  }

  void _onModalConnect(ModalConnect? event) {
    if (event != null) {
      changeRoute('_onModalConnet', Pages.home);
    }
  }

  void _onModalDisconnect(ModalDisconnect? event) {
    if (event != null) {
      changeRoute('_onModalDisconnect', Pages.login);
    }
  }

  void _onModalError(ModalError? event) {
    if (event != null) {
      if ((event.message).contains('Coinbase Wallet Error')) {
        _w3mService.disconnect();
      }
    }
    changeRoute('_onModalError', Pages.login);
    debugPrint('[walletEvent] _onModalError ${event?.toString()}');
    setState(() {});
  }

  void _onSessionExpired(SessionExpire? event) {
    if (event != null) {
      changeRoute('_onSessionExpired', Pages.login);
    }
  }

  void _onSessionUpdate(SessionUpdate? event) {
    if (event != null) {
      debugPrint('[walletEvent] _onSessionUpdate ${event.toString()}');
    }
  }

  void _onSessionEvent(SessionEvent? event) {
    if (event != null) {
      debugPrint('[walletEvent] _onSessionEvent ${event.toString()}');
    }
  }

  void initWalletConnect() async {
    // See https://docs.walletconnect.com/web3modal/flutter/custom-chains
    final amoyChainInfo = fetchAmoyChainInfo();
    W3MChainPresets.chains
        .putIfAbsent(amoyChainInfo.chainId, () => amoyChainInfo);

    _w3mService = getW3mInstance();

    // event listeners
    _w3mService.onModalConnect.subscribe(_onModalConnect);
    _w3mService.onModalDisconnect.subscribe(_onModalDisconnect);
    _w3mService.onModalError.subscribe(_onModalError);
    _w3mService.onSessionExpireEvent.subscribe(_onSessionExpired);
    _w3mService.onSessionUpdateEvent.subscribe(_onSessionUpdate);
    _w3mService.onSessionEventEvent.subscribe(_onSessionEvent);

    // init _w3mService
    await _w3mService.init();

    // switch to Polygon Amoy chain
    _w3mService.selectChain(fetchAmoyChainInfo(), switchChain: true);

    // if the wallet is already connected, move to home
    if (_w3mService.isConnected) {
      changeRoute('defaultChange', Pages.home);
    } else {
      setState(() {});
    }

    // TODO: remove this :)
    changeRoute('defaultChange', Pages.home);
  }

  void sendTransaction() async {
    _w3mService.launchConnectedWallet();
  }

  final image = ImageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().PRIMARY_LIGHT,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                'assets/images/appstore.png',
                width: 200,
                isAntiAlias: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
              child: Text(
                'Staked Steps',
                style: GoogleFonts.teko(
                  textStyle: TextStyle(
                    color: Colors.green.shade700,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    fontSize: 50.00,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100.0, 0, 0),
              child: W3MConnectWalletButton(
                service: _w3mService,
                state: ConnectButtonState.none,
              ),
            ),
            Visibility(
              visible: _w3mService.isConnected,
              child: W3MAccountButton(service: _w3mService),
            )
          ],
        ),
      ),
    );
  }
}
