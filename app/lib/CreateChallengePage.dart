import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staked_steps/constants.dart';
import 'package:staked_steps/utils/transactions.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({super.key, required this.w3mService});

  final W3MService w3mService;

  @override
  State<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  // late FocusNode focusNode;

  @override
  void initState() {
    // focusNode = FocusNode();

    super.initState();
  }

  final challengeNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final stakeAmountController = TextEditingController();
  final goalController = TextEditingController();
  final entriesController = TextEditingController();
  final passKeyController = TextEditingController();

  final privateChallengeIdController = TextEditingController();
  final privatePasskeyController = TextEditingController();

  late int startDateInMillis;
  late int endDateInMillis;
  bool isPrivate = false;

  bool createChallenge = true;

  String? emptyTextValidation(String? value) {
    if (value == null || value.isEmpty || value.trim() == '') {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors().LIGHT,
        title: Text(
          'New Challenge',
          style: GoogleFonts.teko(
              textStyle:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        ),
      ),
      backgroundColor: CustomColors().LIGHT,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              createChallenge
                                  ? 'Create Challenge'
                                  : 'Join Challenge',
                              style: GoogleFonts.teko(
                                textStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          width: 400,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                              value: createChallenge,
                              onChanged: (value) {
                                setState(() {
                                  createChallenge = value;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                createChallenge
                    ? Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Challenge Name

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: challengeNameController,
                                validator: emptyTextValidation,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name',
                                  hintText: 'A quirky challenge name',
                                  filled: true,
                                  alignLabelWithHint: true,
                                  hintFadeDuration: Duration(
                                    seconds: 1,
                                    microseconds: 500,
                                  ),
                                  prefixIcon: Icon(Icons.abc),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: startDateController,
                                      validator: emptyTextValidation,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Start Date',
                                        filled: true,
                                        prefixIcon:
                                            Icon(Icons.date_range_rounded),
                                      ),
                                      onTap: () async {
                                        final startDate = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2025),
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                        );

                                        if (startDate != null) {
                                          startDateController.text = startDate
                                              .toString()
                                              .split(' ')[0];
                                          startDateInMillis =
                                              startDate.millisecondsSinceEpoch;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: endDateController,
                                      validator: emptyTextValidation,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'End Date',
                                        filled: true,
                                        prefixIcon:
                                            Icon(Icons.date_range_rounded),
                                      ),
                                      onTap: () async {
                                        final endDate = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2025),
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                        );

                                        if (endDate != null) {
                                          endDateController.text =
                                              endDate.toString().split(' ')[0];

                                          final endOfDay = DateTime(
                                            endDate.year,
                                            endDate.month,
                                            endDate.day + 1,
                                            0, // hour
                                            0, // minute
                                            0, // second
                                            0, // millisecond
                                          );

                                          endDateInMillis =
                                              endOfDay.millisecondsSinceEpoch;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: goalController,
                                      validator: emptyTextValidation,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Goal',
                                        filled: true,
                                        prefixIcon:
                                            Icon(Icons.golf_course_sharp),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: entriesController,
                                      validator: emptyTextValidation,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Entries Limit',
                                        filled: true,
                                        prefixIcon:
                                            Icon(Icons.person_off_sharp),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // Stake Amount
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: stakeAmountController,
                                validator: emptyTextValidation,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Stake Amount',
                                  filled: true,
                                  prefixIcon: Icon(Icons.attach_money_rounded),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      width: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          isPrivate ? 'Private' : 'Public',
                                          style: GoogleFonts.teko(
                                            textStyle: TextStyle(
                                              color: Colors.green.shade600,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      width: 400,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Switch(
                                          value: isPrivate,
                                          onChanged: (value) {
                                            setState(() {
                                              isPrivate = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            isPrivate
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: passKeyController,
                                      validator: emptyTextValidation,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Passkey',
                                        filled: true,
                                        prefixIcon: Icon(Icons.password),
                                      ),
                                    ),
                                  )
                                : Builder(
                                    builder: (context) {
                                      return Container();
                                    },
                                  ),

                            // Submit Button
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      CustomColors().PRIMARY,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        // side: BorderSide(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final challengeName =
                                          challengeNameController.text;
                                      final startDate =
                                          (startDateInMillis / 1000).round();
                                      final endDate =
                                          (endDateInMillis / 1000).round();
                                      final stakeAmount = BigInt.from(
                                          double.parse(
                                                  stakeAmountController.text) *
                                              1e18);
                                      final goal = goalController.text;
                                      final entriesLimit =
                                          entriesController.text;
                                      final passKey = passKeyController.text;
                                      final totalDays =
                                          ((endDate - startDate) / 86400)
                                              .floor();

                                      print(challengeName);
                                      print(startDate);
                                      print(endDate);
                                      print(stakeAmount);
                                      print(goal);
                                      print(entriesLimit);
                                      print(passKey);
                                      print(totalDays);

                                      final visibility = isPrivate ? '1' : '0';

                                      await customWriteContract(
                                        widget.w3mService,
                                        'createChallenge',
                                        [
                                          challengeName,
                                          BigInt.from(startDate),
                                          BigInt.from(endDate),
                                          BigInt.from(totalDays),
                                          stakeAmount,
                                          BigInt.from(num.parse(entriesLimit)),
                                          BigInt.from(num.parse(goal)),
                                          BigInt.from(num.parse(visibility)),
                                          passKey
                                        ],
                                        EtherAmount.fromBigInt(
                                          EtherUnit.wei,
                                          stakeAmount,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'redirecting to wallet, please approve the transaction.'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Create and Join',
                                    style: GoogleFonts.teko(
                                      textStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller:
                                            privateChallengeIdController,
                                        validator: emptyTextValidation,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Challenge Id',
                                          filled: true,
                                          prefixIcon: Icon(Icons.access_alarm),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: privatePasskeyController,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'PassKey',
                                          filled: true,
                                          prefixIcon: Icon(Icons.password),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        CustomColors().PRIMARY,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          // side: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final challengeId = BigInt.from(
                                            num.parse(
                                                privateChallengeIdController
                                                    .text));
                                        final passKey =
                                            privatePasskeyController.text;

                                        final challengeStakeAmount =
                                            await customReadContract(
                                                widget.w3mService,
                                                'getChallengeStakeAmount',
                                                [challengeId]);

                                        print(challengeStakeAmount[0]);
                                        print(challengeStakeAmount[0]
                                            .runtimeType);
                                        // print(challengeId);
                                        // print(passKey);

                                        try {
                                          await customWriteContract(
                                            widget.w3mService,
                                            'joinPrivateChallenge',
                                            [challengeId, passKey],
                                            EtherAmount.fromBigInt(
                                              EtherUnit.wei,
                                              challengeStakeAmount[0],
                                            ),
                                          );
                                        } catch (err) {
                                          print(err);
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'redirecting to wallet, please approve the transaction.'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Join',
                                      style: GoogleFonts.teko(
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          )),
    );
  }
}
