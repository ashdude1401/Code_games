import 'package:code_games/src/features/challenges/presentation/state_mangment/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateChallengePage extends StatefulWidget {
  const CreateChallengePage({
    super.key,
    required this.groupId,
    required this.onChallengeCreated,
  });

  final String groupId;

  final VoidCallback onChallengeCreated;

  @override
  CreateChallengePageState createState() => CreateChallengePageState();
}

class CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();

  final ChallengeController challengeController = ChallengeController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();

  final TextEditingController _rewardValueController = TextEditingController();
  final TextEditingController _rewardTypeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _checkinTimeController = TextEditingController();
  final TextEditingController _privacyController = TextEditingController();
  final TextEditingController _participantLimitController =
      TextEditingController();
  final TextEditingController _dailyTaskController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();

    _rewardValueController.dispose();
    _rewardTypeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _checkinTimeController.dispose();
    _privacyController.dispose();
    _participantLimitController.dispose();
    _dailyTaskController.dispose();
    super.dispose();
  }

  int currentStep = 0;

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  DateTime checkInDate = DateTime.now();

  List<Step> steps() {
    return [
      Step(
        title: const Text("Basic Information"),
        // state: stepState,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Challenge Title*"),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _titleController,
              onTapOutside: (value) {
                print(value);
                // unfocus the textfield
                FocusScope.of(context).unfocus();
              },
              decoration: const InputDecoration(
                helperText: 'Keep it short and concise',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Description*",
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              )),
              maxLines: 3,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      Step(
        title: const Text("Challenge Details"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rules*"),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _rulesController,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              )),
              keyboardType: TextInputType.text,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter some text' : null,
              maxLines: 3,
            ),

            const SizedBox(height: 16.0),
            //currency unit and reward type
            const Text("Reward Type and Value in ₹"),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Reward Type',
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'points',
                        child: Text('Points'),
                      ),
                      const DropdownMenuItem(
                        value: 'coins',
                        child: Text('Coins'),
                      ),
                      const DropdownMenuItem(
                        value: 'badges',
                        child: Text('Badges'),
                      ),
                      const DropdownMenuItem(
                        value: 'samosa',
                        child: Text('Samosa'),
                      ),
                      const DropdownMenuItem(
                        value: 'chai',
                        child: Text('Chai'),
                      ),
                      const DropdownMenuItem(
                        value: 'sutta',
                        child: Text('Sutta'),
                      ),
                      //other reward types
                      DropdownMenuItem(
                        value: 'other',
                        onTap: () => TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Other Reward Type',
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter some text' : null,
                          onChanged: (value) {
                            // Do something with the value
                            _rewardTypeController.text = value;
                          },
                        ),
                        child: const Text('Other'),
                        //other reward type textfield
                        //when other is selected from dropdown then show textfield to enter other reward type
                      ),
                    ],
                    onChanged: (value) {
                      // Do something with the value
                      _rewardTypeController.text = value!;
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _rewardValueController,
                    decoration: const InputDecoration(
                      labelText: 'value',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter some text' : null,
                  ),
                ),
                const SizedBox(width: 16.0),
                //dropdown for privacy
              ],
            ),
          ],
        ),
      ),
      //Daily task
      Step(
        title: const Text("Daily task"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Daily Task"),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _dailyTaskController,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              )),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      //timeline
      Step(
        title: const Text("Timeline"),
        // state: stepState,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Start and End Date"),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
                    decoration: const InputDecoration(labelText: 'Start Date'),
                    keyboardType: TextInputType.text,
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100))
                          .then((value) => selectedEndDate = value!);

                      _startDateController.text =
                          date!.toLocal().toString().split(' ')[0];
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      } else if (DateTime.parse(value)
                          .isBefore(DateTime.now())) {
                        //check if start date is before current date
                        return 'Start date cannot be before current date';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(labelText: 'End Date'),
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        DateTime? date = DateTime(1900);
                        FocusScope.of(context).requestFocus(FocusNode());

                        date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100))
                            .then((value) => selectedEndDate = value!);

                        _endDateController.text =
                            date!.toLocal().toString().split(' ')[0];
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        } else if (DateTime.parse(value).isBefore(
                            DateTime.parse(_startDateController.text))) {
                          return 'End date cannot be before start date';
                        } else {
                          return null;
                        }
                      }),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            //chekin time and privacy
            const Text("Checkin Time "),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _checkinTimeController,
              decoration: const InputDecoration(
                labelText: 'Checkin Time',
              ),
              keyboardType: TextInputType.datetime,
              onTap: () async {
                TimeOfDay? time = TimeOfDay.now();
                FocusScope.of(context).requestFocus(FocusNode());

                time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                checkInDate = DateTime(
                  checkInDate.year,
                  checkInDate.month,
                  checkInDate.day,
                  time!.hour,
                  time.minute,
                );

                _checkinTimeController.text = time!.format(context);
              },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      Step(
        title: const Text("Additional Details"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Participant Limit(optional)"),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _participantLimitController,
              decoration: const InputDecoration(
                labelText: 'Participant Limit',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            //chekin time and privacy
            const Text("Privacy"),
            const SizedBox(height: 8.0),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Privacy',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'public',
                  child: Text('Public'),
                ),
                DropdownMenuItem(
                  value: 'private',
                  child: Text('Private'),
                ),
              ],
              onChanged: (value) {
                // Do something with the value
                _privacyController.text = value!;
              },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    ];
  }

  // StepState stepState = StepState.editing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Challenge'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepTapped: (step) {
            setState(() => currentStep = step);
          },
          onStepContinue: () {
            bool isLastStep = (currentStep == steps().length - 1);
            if (isLastStep) {
              // Validate all fields on last step
              if (_formKey.currentState!.validate()) {
                // Submit the challenge if all fields are valid
                _submitChallenge(context);
              }
              //show snackbar if any field is invalid
              else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please fill in all fields.'),
                ));
              }
            } else {
              // Proceed to next step
              setState(() {
                currentStep += 1;
              });
            }
          },
          onStepCancel: () => currentStep == 0
              ? null
              : setState(() {
                  currentStep -= 1;
                }),
          steps: steps(),
        ),
      ),
    );
  }

  Future<void> _submitChallenge(BuildContext context) async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final String startDate = _startDateController.text;
    final String endDate = _endDateController.text;
    final String rules = _rulesController.text;
    final String rewardValue = _rewardValueController.text;
    final String rewardType = _rewardTypeController.text;
    final String checkinTime = _checkinTimeController.text;
    final String privacy = _privacyController.text;
    final String participantLimit = _participantLimitController.text;
    final String dailyTask = _dailyTaskController.text;

    if (title.isEmpty ||
        description.isEmpty ||
        startDate.isEmpty ||
        endDate.isEmpty ||
        rules.isEmpty) {
      // Show an error message if any required field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    //print the challenge details
    print(title);
    print(description);
    print(startDate);
    print(endDate);
    print(rules);

    print(rewardValue);
    print(rewardType);
    print(checkinTime);
    print(privacy);
    print(participantLimit);

    final String status = DateTime.now().isBefore(DateTime.parse(startDate))
        ? 'upcoming'
        : 'active';
    // Save the challenge to Firestore
    try {
      await challengeController
          .createNewChallenge(
        title,
        description,
        rules,
        selectedStartDate,
        selectedStartDate,
        selectedStartDate,
        rewardType,
        int.parse(rewardValue),
        privacy,
        status,
        participantLimit,
        widget.groupId,
        dailyTask,
      )
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Challenge created successfully!'),
        ));
        widget.onChallengeCreated();
        Get.back();
      });
      // Show a success message

      // Navigate back to the previous screen or any other desired navigation logic
    } catch (e) {
      // Handle errors (e.g., Firestore errors)
      print('Error creating challenge: $e');

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error creating challenge. Please try again later.'),
      ));
    }
  }
}
