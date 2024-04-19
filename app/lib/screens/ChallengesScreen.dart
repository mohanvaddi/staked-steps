import 'package:flutter/material.dart';
import 'package:staked_steps/structs.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/tabs/ChallengesList.dart';
import 'package:staked_steps/widgets/CustomScreenLayout.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({
    super.key,
    required this.w3mService,
  });

  final W3MService w3mService;

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late ContractInfo contractInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScreenLayout(
        context: context,
        w3mService: widget.w3mService,
        screen: Screens.CHALLENGES,
        body: TabBarView(
          children: <Widget>[
            // USER ONGOING CHALLENGES
            Center(
              child: ChallengesList(
                w3mService: widget.w3mService,
                challengesType: ChallengesType.USER_ONGOING,
              ),
            ),
            // PUBLIC CHALLENGES
            Center(
              child: ChallengesList(
                w3mService: widget.w3mService,
                challengesType: ChallengesType.PUBLIC,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
