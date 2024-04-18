import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staked_steps/constants.dart';
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

  late int startDateInMillis;
  late int endDateInMillis;
  bool isPrivate = false;

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
          'Create New Challenge',
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Challenge Name

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
                              prefixIcon: Icon(Icons.date_range_rounded),
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
                                startDateController.text =
                                    startDate.toString().split(' ')[0];
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
                              prefixIcon: Icon(Icons.date_range_rounded),
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
                                endDateInMillis =
                                    endDate.millisecondsSinceEpoch;
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
                              prefixIcon: Icon(Icons.golf_course_sharp),
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
                              prefixIcon: Icon(Icons.person_off_sharp),
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
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Stake Amount',
                        filled: true,
                        prefixIcon: Icon(Icons.attach_money_rounded),
                      ),
                    ),
                  ),

                  isPrivate
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passKeyController,
                            validator: emptyTextValidation,
                            keyboardType: TextInputType.visiblePassword,
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                            CustomColors().PRIMARY,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              // side: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: call transaction to create public/private challenge
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing Data'),
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
            ),
          ),
        ),
      ),
    );
  }
}
