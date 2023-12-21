import '../entity/challenge.dart';
import '../entity/participant.dart';

abstract class ChallengeRepository {
  //--------------Challenge-----------------//
  //creating a challenge
  Future<void> createChallenge(Challenge challenge, String groupId);

  //getting a challenge
  Future<Challenge> getChallenge(String challengeId);

  //getting all challenges
  Future<List<Challenge>> getAllGroupChallenges(String groupId);

  //updating a challenge
  Future<void> updateChallenge(Challenge challenge);

  //deleting a challenge
  Future<void> deleteChallenge(String challengeId);

  //----Participant----//
  //adding a participant to a challenge
  Future<void> addParticipant(
      String groupId, String challengeId, Participant participant);
  //updating a participant
  Future<void> updateParticipant(String challengeId, Participant participant);
  //removing a participant from a challenge
  Future<void> removeParticipant(String challengeId, String participantId);
  //getting a list of all participants
  Future<List<Participant>> getAllParticipants(
      String groupId, String challengeId);
}
