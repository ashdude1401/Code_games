import 'package:code_games/src/config/theme/Theme/theme.dart';
import 'package:code_games/src/features/challenges/domain/entity/participant.dart';
import 'package:code_games/src/features/challenges/presentation/pages/participate_in_challenge/participate_in_challenge_page.dart';
import 'package:code_games/src/features/challenges/presentation/state_mangment/challenge_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../auth/data/repository/authentication_repository_impl.dart';
import '../../../domain/entity/challenge.dart';

class ViewChallengePage extends StatefulWidget {
  final Challenge challenge;
  final String groupId;

  const ViewChallengePage(
      {super.key, required this.challenge, required this.groupId});

  @override
  State<ViewChallengePage> createState() => _ViewChallengePageState();
}

class _ViewChallengePageState extends State<ViewChallengePage> {
  final List<Participant> participants = [];

  final controller = Get.find<ChallengeController>();
  final userController = Get.find<AuthenticationRepositoryImpl>();

  bool isParticipantEmpty = true;
  bool isUserAParticipant = false;

  @override
  void initState() {
    _intialiseParticipants();

    // TODO: implement initState
    super.initState();
  }

  Future<void> _intialiseParticipants() async {
    print("I am inside initialise participants");
    final participantsList = await controller.getAllParticipants(
        widget.groupId, widget.challenge.id);

    print("Participants List: ${participantsList.length}");
    setState(() {
      print("I am inside set state");
      participants.addAll(participantsList);
      //check if the user is a participant
      for (var participant in participants) {
        if (participant.id == userController.currentUser.value.userID) {
          isUserAParticipant = true;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Challenge Details'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Challenge Information Card
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                color: AppTheme.lightTheme.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        'Challenge Title',
                        widget.challenge.title,
                        Icons.title,
                      ),
                      _buildInfoRow(
                        'Description',
                        widget.challenge.description,
                        Icons.description,
                      ),
                      _buildInfoRow(
                        'Start Date',
                        _formatDate(widget.challenge.startDate),
                        Icons.date_range,
                      ),
                      _buildInfoRow(
                        'End Date',
                        _formatDate(widget.challenge.endDate),
                        Icons.date_range,
                      ),
                      // _buildInfoRow(
                      //   'Check-in Time',
                      //   _formatTime(widget.challenge.checkinTime),
                      //   Icons.access_time,
                      // ),
                      _buildInfoRow(
                        'Reward Type',
                        _capitalize(widget.challenge.rewardType),
                        Icons.star,
                      ),
                      _buildInfoRow(
                        'Reward Value',
                        widget.challenge.rewardValue,
                        Icons.attach_money,
                      ),
                      _buildInfoRow(
                        'Participant Limit',
                        '${widget.challenge.participantLimit}',
                        Icons.people,
                      ),
                      _buildInfoRow(
                        'Privacy',
                        _capitalize(widget.challenge.privacy),
                        Icons.lock,
                      ),
                    ],
                  ),
                ),
              ),
              //Daily Task

              //Rules of the challenge from the challenge entity
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                color: AppTheme.lightTheme.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rules',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Display the list of participants
                      ListTile(
                        title: Text(widget.challenge.rules,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            )),
                      ),

                      // ... Add more participants
                    ],
                  ),
                ),
              ),
              //Participants
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                color: AppTheme.lightTheme.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Participants',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Display the list of participants
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: participants.length,
                        itemBuilder: (context, index) {
                          final participant = participants[index].displayName;
                          return ListTile(
                            title: Text(participant,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                )),
                          );
                        },
                      ),

                      // ... Add more participants
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            // Edit Challenge Buttons
            isUserAParticipant
                ? //if the user is a participant and the challenge is active , and not checked in for the day task , show the check in button
                widget.challenge.status == 'active' &&
                        !participants
                            .firstWhere((element) =>
                                element.id ==
                                userController.currentUser.value.userID)
                            .progress
                            .last
                            .checkIn
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ParticipateInChallengePage(
                                  challenge: widget.challenge,
                                  groupId: widget.groupId,
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: const Text(
                            'Check In',
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => ParticipateInChallengePage(
                              challenge: widget.challenge,
                              groupId: widget.groupId,
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text(
                        'Participate in Challenge',
                      ),
                    ),
                  ));
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute}';
  }

  String _capitalize(String s) {
    return s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
  }
}
