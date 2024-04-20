import 'package:flutter/material.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/tabs/ChallengesList.dart';
import 'package:staked_steps/utils/api_utils.dart';
import 'package:staked_steps/utils/common_utils.dart';
import 'package:staked_steps/utils/transactions.dart';
import 'package:staked_steps/widgets/CustomScreenLayout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> futureNfts;
  late List<dynamic> nftList;

  @override
  void initState() {
    futureNfts = _initNftList();
    super.initState();
  }

  Future<void> _initNftList() async {
    final nfts = await fetchUserNfts(widget.w3mService, fetchBaseSepolia());
    nftList = nfts;
  }

  Future<void> _refreshNftList() async {
    final nfts = await fetchUserNfts(widget.w3mService, fetchBaseSepolia());
    setState(() {
      nftList = nfts;
    });
  }

  void launchOpenseUrl(List<dynamic> nftList, int index) async {
    final contractInfo = await fetchContractInfo();
    final tokenUrl = '$openseaUrl/${contractInfo.address}/${nftList[index].id}';
    final Uri url = Uri.parse(tokenUrl);

    final urlLaunched = await launchUrl(url);
    if (urlLaunched) {
      throw Exception(
        'Could not launch $url',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScreenLayout(
        context: context,
        w3mService: widget.w3mService,
        screen: Screens.PROFILE,
        body: TabBarView(
          children: <Widget>[
            Center(
              child: ChallengesList(
                w3mService: widget.w3mService,
                challengesType: ChallengesType.USER_COMPLETED,
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
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              title: Text(nftList[index].name),
                                            ),
                                            body: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5.0, 40.0, 5.0, 40.0),
                                              child: Column(
                                                children: [
                                                  Image.network(
                                                    nftList[index].image,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: TextButton.icon(
                                                      icon: const Icon(
                                                        Icons.link,
                                                      ),
                                                      label:
                                                          const Text('Opensea'),
                                                      onPressed: () async {
                                                        launchOpenseUrl(
                                                          nftList,
                                                          index,
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ));
                                    },
                                    child: Image.network(
                                      nftList[index].image,
                                      // fit: BoxFit.fitWidth,
                                    ),
                                  ));
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
