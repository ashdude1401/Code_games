import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
import 'package:code_games/src/features/challenges/presentation/state_mangment/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/challenge.dart';
import '../../../domain/entity/participant.dart';

class ParticipateInChallengePage extends StatefulWidget {
  final Challenge challenge;
  final String groupId;

  const ParticipateInChallengePage(
      {Key? key, required this.challenge, required this.groupId})
      : super(key: key);

  @override
  ParticipateInChallengePageState createState() =>
      ParticipateInChallengePageState();
}

class ParticipateInChallengePageState
    extends State<ParticipateInChallengePage> {
  bool _acceptRules = false;

  final displayNameController = TextEditingController();

  final controller = Get.find<AuthenticationRepositoryImpl>();

  final challengeController = Get.find<ChallengeController>();
  // Perform the participant registration logic here
  // You can navigate to the next screen or perform any other actions
  // For example, you can create a Participant object and store it in your system

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Participate in Challenge'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Challenge Details',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildChallengeDetails(),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              _buildAcceptRulesCheckbox(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _acceptRules ? _onSubmit : null,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
                child: const Text('Accept and Participate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeDetails() {
    //for formatting date and time
    final startDate =
        DateFormat('dd MMM yyyy').format(widget.challenge.startDate);
    final endDate = DateFormat('dd MMM yyyy').format(widget.challenge.endDate);
    // final checkinTime =
    //     DateFormat('hh:mm a').format(widget.challenge.checkinTime);
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChallengeDetailItem(
                Icons.title, 'Challenge Title', widget.challenge.title),
            _buildChallengeDetailItem(
                Icons.description, 'Description', widget.challenge.description),
            _buildChallengeDetailItem(
                Icons.rule, 'Rules', widget.challenge.rules),
            _buildChallengeDetailItem(
                Icons.date_range, 'Start Date', startDate),
            _buildChallengeDetailItem(Icons.date_range, 'End Date', endDate),
            // _buildChallengeDetailItem(
            //     Icons.access_time, 'Check-in Time', checkinTime),
            _buildChallengeDetailItem(
                Icons.star, 'Reward Type', widget.challenge.rewardType),
            _buildChallengeDetailItem(Icons.attach_money, 'Reward Value',
                widget.challenge.rewardValue),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeDetailItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        '$label:',
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _buildAcceptRulesCheckbox() {
    return ListTile(
      leading: Checkbox(
        value: _acceptRules,
        onChanged: (value) {
          setState(() {
            _acceptRules = value ?? false;
          });
        },
      ),
      title: const Text(
        'I accept the rules and conditions of the challenge',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  void _onSubmit() {
    final String id =
        controller.currentUser.value.userID; //id of the participant
    String displayName =
        controller.currentUser.value.fullName; //display name of the participant
    String email =
        controller.currentUser.value.email; //email of the participant
    DateTime joinedDate = DateTime.now(); //joined date of the participant
    bool isActive = false; //is active or not
    List<ProgressEntry> progress = []; //progress of the participant
    int currentStreak = 0; //current streak of the participant
    int totalDays = 0; //total days of the participant
    bool isChallengeCompleted = false; //is challenge completed or not

    final participant = Participant(
      id: id,
      displayName: displayName,
      email: email,
      joinedDate: joinedDate,
      isActive: isActive,
      progress: progress,
      currentStreak: currentStreak,
      totalDays: totalDays,
      isChallengeCompleted: isChallengeCompleted,
    );

    challengeController.participateInChallenge(
        widget.groupId, widget.challenge.id, participant);
    // Navigate to the success screen or any other screen as needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(participant: participant),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  final Participant participant;

  const SuccessScreen({Key? key, required this.participant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80.0,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Registration Successful!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Participant ID: ${participant.id}'),
            // Add more success details as needed
          ],
        ),
      ),
    );
  }
}
