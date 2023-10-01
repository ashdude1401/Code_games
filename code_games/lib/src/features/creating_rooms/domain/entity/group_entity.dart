class GroupEntity {
  String groupId;
  String groupName;
  String groupDescription;
  String groupImg;
  List<Challenge> challengeList;
  List<GroupMembers> groupMembers;
  List<String> admins;
  String createdBy;

  GroupEntity(
      {required this.groupId,
      required this.groupName,
      required this.groupDescription,
      required this.groupImg,
      required this.challengeList,
      required this.groupMembers,
      required this.admins,
      required this.createdBy});

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupDescription': groupDescription,
      'groupImg': groupImg,
      'challengeList': challengeList.map((x) => x.toMap()).toList(),
      'groupMembers': groupMembers.map((x) => x.toMap()).toList(),
      'admins': admins,
      'createdBy': createdBy,
    };
  }

  factory GroupEntity.fromMap(Map<String, dynamic> map) {
    return GroupEntity(
      groupId: map['groupId'],
      groupName: map['groupName'],
      groupDescription: map['groupDescription'],
      groupImg: map['groupImg'],
      challengeList: List<Challenge>.from(
          map['challengeList']?.map((x) => Challenge.fromMap(x))),
      groupMembers: List<GroupMembers>.from(
          map['groupMembers']?.map((x) => GroupMembers.fromMap(x))),
      admins: List<String>.from(map['admins']),
      createdBy: map['createdBy'],
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
  String challengeName;
  String challengeDescription;
  String challengeAmount;
  String challengeParameters;

  Challenge({
    required this.challengeName,
    required this.challengeDescription,
    required this.challengeAmount,
    required this.challengeParameters,
  });

  Map<String, dynamic> toMap() {
    return {
      'challengeName': challengeName,
      'challengeDescription': challengeDescription,
      'challengeAmount': challengeAmount,
      'challengeParameters': challengeParameters,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      challengeName: map['challengeName'],
      challengeDescription: map['challengeDescription'],
      challengeAmount: map['challengeAmount'],
      challengeParameters: map['challengeParameters'],
    );
  }
}
