import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_games/src/features/challenges/domain/repository/challenge_repository.dart';

import 'package:get/get.dart';

import '../../domain/entity/challenge.dart';
import '../../domain/entity/participant.dart';

class ChallengeRepositoryImpl extends GetxController
    implements ChallengeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<void> createChallenge(Challenge challenge, String groupId) async {
    //creating a challenge
    try {
      final newChallengeDocId = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('challenges')
          .doc()
          .id;

      challenge.id = newChallengeDocId;

      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('challenges')
          .doc(newChallengeDocId)
          .set(challenge.toJson());
    } on FirebaseException catch (e) {
      print("Firebase Db Exception: $e");
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> deleteChallenge(String challengeId) {
    // TODO: implement deleteChallenge
    throw UnimplementedError();
  }

  @override
  Future<void> updateChallenge(Challenge challenge) {
    // TODO: implement updateChallenge
    throw UnimplementedError();
  }

  @override
  Future<void> addParticipant(
      String groupId, String challengeId, Participant participant) async {
    try {
      final participantId = participant.id;

      // Check if the participant already exists with the same participant id
      final participantReference = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('challenges')
          .doc(challengeId)
          .collection('participants')
          .doc(participantId);

      final existingParticipant = await participantReference.get();

      if (existingParticipant.exists) {
        // Participant with the given ID already exists, handle accordingly
        print('Participant with ID $participantId already exists.');

        //show snackbar
        Get.snackbar(
          'User Already Exists ',
          'Participant with ID $participantId already exists.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      } else {
        // Participant with the given ID doesn't exist, proceed with adding
        participantReference.set(participant.toJson());
      }
    } on FirebaseException catch (e) {
      print("Firebase Db Exception: $e");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Future<List<Participant>> getAllParticipants(
      String groupId, String challengeId) async {
    final List<Participant> participants = [];

    try {
      final participantsRef = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('challenges')
          .doc(challengeId)
          .collection('participants')
          .get();

      for (var participant in participantsRef.docs) {
        participants.add(Participant.fromJson(participant.data()));
      }
      return participants;
    } on FirebaseException catch (e) {
      print("Firebase Db Exception: $e");
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  Future<void> removeParticipant(String challengeId, String participantId) {
    // TODO: implement removeParticipant
    throw UnimplementedError();
  }

  @override
  Future<void> updateParticipant(String challengeId, Participant participant) {
    // TODO: implement updateParticipant
    throw UnimplementedError();
  }

  @override
  Future<List<Challenge>> getAllGroupChallenges(String groupId) async {
    try {
      final challenges = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('challenges')
          .get();

      return challenges.docs
          .map((challenge) => Challenge.fromJson(challenge.data()))
          .toList();
    } on FirebaseException catch (e) {
      print("Firebase Db Exception: $e");
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<Challenge> getChallenge(String challengeId) {
    // TODO: implement getChallenge
    throw UnimplementedError();
  }
}
