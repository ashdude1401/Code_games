class GroupEntity {
  String groupId;
  String groupName;
  String groupDescription;
  String groupImg;
  List<String> challengesRefferenceId; // List of challenges in the group
  List<GroupMembers> groupMembers;
  List<String> channelReferenceId; // List of messages in the group
  List<String> admins;
  String createdBy;
  String uniqueJoinId;

  GroupEntity({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.groupImg,
    required this.challengesRefferenceId,
    required this.groupMembers,
    required this.admins,
    required this.createdBy,
    required this.channelReferenceId,
    required this.uniqueJoinId,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupDescription': groupDescription,
      'groupImg': groupImg,
      'challengeList': challengesRefferenceId,
      'groupMembers': groupMembers.map((x) => x.toMap()).toList(),
      'channelReferenceId': channelReferenceId,
      'admins': admins,
      'createdBy': createdBy,
      'uniqueJoinId': uniqueJoinId,
    };
  }

  factory GroupEntity.fromMap(Map<String, dynamic> map) {
    return GroupEntity(
      groupId: map['groupId'],
      groupName: map['groupName'],
      groupDescription: map['groupDescription'],
      groupImg: map['groupImg'],
      challengesRefferenceId:
          List<String>.from(map['challengeList']?.map((x) => x)),
      groupMembers: List<GroupMembers>.from(
          map['groupMembers']?.map((x) => GroupMembers.fromMap(x))),
      channelReferenceId: List<String>.from(map['channelReferenceId']),
      admins: List<String>.from(map['admins']),
      createdBy: map['createdBy'],
      uniqueJoinId: map['uniqueJoinId'],
    );
  }
}

class GroupMembers {
  String userName;
  String userImg;
  String email;
  String userScore;
  String userRank;

  GroupMembers({
    required this.userName,
    required this.userImg,
    required this.userScore,
    required this.userRank,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userImg': userImg,
      'userScore': userScore,
      'userRank': userRank,
      'email': email,
    };
  }

  factory GroupMembers.fromMap(Map<String, dynamic> map) {
    return GroupMembers(
      userName: map['userName'],
      userImg: map['userImg'],
      userScore: map['userScore'],
      userRank: map['userRank'],
      email: map['email'],
    );
  }
}

class Challenge {
  String challengeId;
  String title;
  String description;
  List<String> rules;
  DateTime startDate;
  DateTime endDate;
  String checkInTime;
  List<String> rewards;
  String currencyType;
  int participantLimit;
  String privacy;

  Challenge({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.rules,
    required this.startDate,
    required this.endDate,
    required this.checkInTime,
    required this.rewards,
    required this.currencyType,
    required this.participantLimit,
    required this.privacy,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'challengeId': challengeId,
      'title': title,
      'description': description,
      'rules': rules,
      'startDate': startDate,
      'endDate': endDate,
      'checkInTime': checkInTime,
      'rewards': rewards,
      'currencyType': currencyType,
      'participantLimit': participantLimit,
      'privacy': privacy,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      challengeId: map['challengeId'],
      title: map['title'],
      description: map['description'],
      rules: List<String>.from(map['rules']?.map((x) => x)),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      checkInTime: map['checkInTime'],
      rewards: List<String>.from(map['rewards']?.map((x) => x)),
      currencyType: map['currencyType'],
      participantLimit: map['participantLimit'],
      privacy: map['privacy'],
    );
  }
}

class Participant {
  String userId; // User ID as Document ID
  String displayName;
  String email;
  DateTime joinedDate;
  bool isActive;
  List<Map<String, dynamic>> progress; // Array or nested documents tracking daily check-ins or task submissions
  int currentStreak;
  int totalDays;
  bool isChallengeCompleted;

  Participant({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.joinedDate,
    required this.isActive,
    required this.progress,
    required this.currentStreak,
    required this.totalDays,
    required this.isChallengeCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'joinedDate': joinedDate,
      'isActive': isActive,
      'progress': progress,
      'currentStreak': currentStreak,
      'totalDays': totalDays,
      'isChallengeCompleted': isChallengeCompleted,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      userId: map['userId'],
      displayName: map['displayName'],
      email: map['email'],
      joinedDate: DateTime.parse(map['joinedDate']),
      isActive: map['isActive'],
      progress: List<Map<String, dynamic>>.from(map['progress']?.map((x) => x)),
      currentStreak: map['currentStreak'],
      totalDays: map['totalDays'],
      isChallengeCompleted: map['isChallengeCompleted'],
    );
  }
}



class Message {
  String messageId; // ID of the message (auto-generated)
  String senderId; // ID of the user sending the message
  String messageText;
  DateTime timestamp;
  String senderEmail;
  String senderName;
  String senderImg;

  Message({
    required this.messageId,
    required this.senderId,
    required this.messageText,
    required this.timestamp,
    required this.senderEmail,
    required this.senderName,
    required this.senderImg,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'messageText': messageText,
      'timestamp': timestamp.toIso8601String(),
      'senderEmail': senderEmail,
      'senderName': senderName,
      'senderImg': senderImg,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      senderId: map['senderId'],
      messageText: map['messageText'],
      timestamp: DateTime.parse(map['timestamp']),
      senderEmail: map['senderEmail'],
      senderImg: map['senderImg'],
      senderName: map['senderName'],
    );
  }
}

// class Channel {
//   String channelId;
//   String channelName;
//   String channelDescription;
//   String channelImg;
//   String messagesReferenceId;

//   Channel({
//     required this.channelId,
//     required this.channelName,
//     required this.channelDescription,
//     required this.channelImg,
//     required this.messagesReferenceId,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'channelId': channelId,
//       'channelName': channelName,
//       'channelDescription': channelDescription,
//       'channelImg': channelImg,
//       'messagesReferenceId': messagesReferenceId,
//     };
//   }

//   factory Channel.fromMap(Map<String, dynamic> map) {
//     return Channel(
//       channelId: map['channelId'],
//       channelName: map['channelName'],
//       channelDescription: map['channelDescription'],
//       channelImg: map['channelImg'],
//       messagesReferenceId: map['messagesReferenceId'],
//     );
//   }
class Channel {
  String channelId;
  String channelName;
  String channelDescription;
  String channelImg;
  String messagesReferenceId;

  Channel({
    required this.channelId,
    required this.channelName,
    required this.channelDescription,
    required this.channelImg,
    required this.messagesReferenceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'channelId': channelId,
      'channelName': channelName,
      'channelDescription': channelDescription,
      'channelImg': channelImg,
      'messagesReferenceId': messagesReferenceId,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      channelId: map['channelId'],
      channelName: map['channelName'],
      channelDescription: map['channelDescription'],
      channelImg: map['channelImg'],
      messagesReferenceId: map['messagesReferenceId'],
    );
  }
}
