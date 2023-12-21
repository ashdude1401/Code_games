class Challenge {
  String id; //id of the challenge
  String title; // title of the challenge
  String description; //description of challenge
  String rules; //rules of the challenge
  DateTime startDate; //start date of the challenge
  DateTime endDate; //end date of the challenge
  // DateTime checkinTime; //checkin time of the challenge
  String rewardType; //type of the reward (eg. points, badges, etc.)
  String rewardValue; //value of the reward (eg. 100 points, 1 badge, etc.)
  String privacy; //privacy of the challenge (public or private)
  String status; //status of the challenge (active or inactive)
  String? participantLimit; //participant limit of the challenge(optional)
  String creatorId; //id of the creator of the challenge
  String dailyTask; //daily task of the challenge
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.rules,
    required this.startDate,
    required this.endDate,
    // required this.checkinTime,
    required this.rewardType,
    required this.rewardValue,
    required this.privacy,
    required this.status,
    this.participantLimit,
    required this.creatorId,
    required this.dailyTask,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      rules: json['rules'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      // checkinTime: DateTime.parse(json['checkinTime']),
      rewardType: json['rewardType'],
      rewardValue: json['rewardValue'],
      privacy: json['privacy'],
      status: json['status'],
      participantLimit: json['participantLimit'],
      creatorId: json['creatorId'],
      dailyTask: json['dailyTask'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'rules': rules,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        // 'checkinTime': checkinTime.toIso8601String(),
        'rewardType': rewardType,
        'rewardValue': rewardValue,
        'privacy': privacy,
        'status': status,
        'participantLimit': participantLimit,
        'creatorId': creatorId,
        'dailyTask': dailyTask,
      };
}

class Rule {
  String id;
  String name;
  String description;

  Rule({required this.id, required this.name, required this.description});

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
