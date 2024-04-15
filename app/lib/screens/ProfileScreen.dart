import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/tabs/OngoingQuests.dart';
import 'package:staked_steps/utils/pedometer_utils.dart';
import 'package:staked_steps/utils/api_utils.dart' as api_util;
import 'package:staked_steps/utils/common_utils.dart';
import 'package:staked_steps/widgets/CustomScreenLayout.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _status = '?', _steps = '?';

  late Future<void> futureNfts;
  late List<Nft> nftList;

  @override
  void initState() {
    super.initState();
    initPedometer(
      (StepCount event) {
        setState(() {
          kPrint(event);
          _steps = event.steps.toString();
        });
      },
      (PedestrianStatus event) {
        setState(() {
          kPrint(event);
          _status = event.status;
        });
      },
    );

    futureNfts = _initNftList();
  }

  Future<void> _initNftList() async {
    final List<Nft> nfts = await api_util.fetchNfts();
    nftList = nfts;
  }

  Future<void> _refreshNftList() async {
    final nfts = await api_util.fetchNfts();
    setState(() {
      nftList = nfts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScreenLayout(
        context: context,
        w3mService: widget.w3mService,
        steps: _steps,
        screen: Screens.PROFILE,
        body: TabBarView(
          children: <Widget>[
            Center(
              child: OngoingQuests(
                w3mService: widget.w3mService,
              ),
            ),
            Center(
              child: FutureBuilder<void>(
                future: futureNfts,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('${snapshot.error}');

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      {
                        return const Center(
                          child: Text('Loading...'),
                        );
                      }

                    case ConnectionState.done:
                      {
                        // changing cross axis count based on total
                        var crossAxisCount = nftList.length > 4 ? 3 : 2;

                        return RefreshIndicator(
                          onRefresh: _refreshNftList,
                          child: GridView.builder(
                            itemCount: nftList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: FullScreenWidget(
                                  disposeLevel: DisposeLevel.High,
                                  backgroundIsTransparent: true,
                                  backgroundColor: Colors.green.shade50,
                                  child: Image.network(
                                    nftList[index].image,
                                    // fit: BoxFit.fitWidth,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
