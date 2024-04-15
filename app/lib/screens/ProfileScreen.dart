import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/utils/pedometer_utils.dart';
import 'package:staked_steps/utils/api_utils.dart' as api_util;
import 'package:staked_steps/utils/common_utils.dart';
import 'package:staked_steps/widgets/CustomScreenLayout.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

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
            const Center(),
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
                        // if (nftList == null) {
                        //   // Return a placeholder or loading indicator until nftList is initialized
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }

                        return RefreshIndicator(
                          onRefresh: _refreshNftList,
                          child: GridView.builder(
                            itemCount: nftList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Image.network(
                                    nftList[index].image,
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
