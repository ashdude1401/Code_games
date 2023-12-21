import 'package:code_games/src/features/auth/data/repository/authentication_repository_impl.dart';
import 'package:code_games/src/features/challenges/data/repository/challenge_repository_impl.dart';
import 'package:code_games/src/features/challenges/domain/entity/participant.dart';

import 'package:get/get.dart';

import '../../domain/entity/challenge.dart';

class ChallengeController extends GetxController {
  final ChallengeRepositoryImpl _groupRepositoryImpl =
      Get.put(ChallengeRepositoryImpl());
  final userController = Get.find<AuthenticationRepositoryImpl>();

  Future<void> createNewChallenge(
    String title,
    String description,
    String rules,
    DateTime startDate, //start date of the challenge
    DateTime endDate, //end date of the challenge
    DateTime checkinTime, //checkin time of the challenge
    String rewardType, //type of the reward (eg. points, badges, etc.)
    int rewardValue, //value of the reward (eg. 100 points, 1 badge, etc.)
    String privacy, //privacy of the challenge (public or private)
    String status, //status of the challenge (active or inactive)
    String? participantLimit,
    String groupId,
    String dailyTask,
  ) async {
    final currentUser = userController.currentUser.value;
    final id = currentUser.userID;
    final newChallenge = Challenge(
      id: "",
      title: title,
      description: description,
      rules: rules,
      startDate: startDate,
      endDate: endDate,
      // checkinTime: checkinTime,
      rewardType: rewardType,
      rewardValue: rewardValue.toString(),
      privacy: privacy,
      status: status,
      participantLimit: participantLimit,
      creatorId: id,
      dailyTask: dailyTask,
    );

    try {
      await _groupRepositoryImpl.createChallenge(newChallenge, groupId);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Challenge>> getAllChallenges(String groupId) async {
    try {
      final challenges =
          await _groupRepositoryImpl.getAllGroupChallenges(groupId);
      return challenges;
    } catch (e) {
      print("EROR: Occured while fetching challenges  $e");
      return [];
    }
  }

  Future<void> participateInChallenge(
      String groupId, String challengeId, Participant participant) async {
    try {
      await _groupRepositoryImpl.addParticipant(
          groupId, challengeId, participant);
    } catch (e) {
      print("Error occured while participating in challenge $e");
    }
  }

  Future<List<Participant>> getAllParticipants(
      String groupId, String challengeId) async {
    try {
      final participants =
          await _groupRepositoryImpl.getAllParticipants(groupId, challengeId);
      return participants;
    } catch (e) {
      print("Error occured while fetching participants $e");
      return [];
    }
  }
}
