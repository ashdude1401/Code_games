class GroupModal {
  String groupId;
  String groupName;
  String groupDescription;
  double challengeAmount;
  String challengeParameters;

  GroupModal({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.challengeAmount,
    required this.challengeParameters,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupDescription': groupDescription,
      'challengeAmount': challengeAmount,
      'challengeParameters': challengeParameters,
    };
  }
}
