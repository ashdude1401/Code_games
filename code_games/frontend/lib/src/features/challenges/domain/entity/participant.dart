class Participant {
  String id; //id of the participant
  String displayName; //display name of the participant
  String email; //email of the participant
  DateTime joinedDate; //joined date of the participant
  bool isActive; //is active or not
  List<ProgressEntry> progress; //progress of the participant
  int currentStreak; //current streak of the participant
  int totalDays; //total days of the participant
  bool isChallengeCompleted; //is challenge completed or not
  DateTime? lastCheckInDate; //last check in date of the participant
  
  Participant({
    required this.id,
    required this.displayName,
    required this.email,
    required this.joinedDate,
    required this.isActive,
    required this.progress,
    required this.currentStreak,
    required this.totalDays,
    required this.isChallengeCompleted,
    this.lastCheckInDate,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      displayName: json['displayName'],
      email: json['email'],
      joinedDate: DateTime.parse(json['joinedDate']),
      isActive: json['isActive'],
      progress: List<ProgressEntry>.from(
          json['progress'].map((x) => ProgressEntry.fromJson(x))),
      currentStreak: json['currentStreak'],
      totalDays: json['totalDays'],
      isChallengeCompleted: json['isChallengeCompleted'],
      lastCheckInDate: json['lastCheckInDate'] != null
          ? DateTime.parse(json['lastCheckInDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'email': email,
        'joinedDate': joinedDate.toIso8601String(),
        'isActive': isActive,
        'progress': List<dynamic>.from(progress.map((x) => x.toJson())),
        'currentStreak': currentStreak,
        'totalDays': totalDays,
        'isChallengeCompleted': isChallengeCompleted,
        'lastCheckInDate':
            lastCheckInDate != null ? lastCheckInDate!.toIso8601String() : null,
      };
}

class ProgressEntry {
  DateTime date;
  bool checkIn;
  String taskCompleted;
  String difficulty;
  int rating;
  String notes;

  ProgressEntry({
    required this.date,
    required this.checkIn,
    required this.taskCompleted,
    required this.difficulty,
    required this.rating,
    required this.notes,
  });

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      date: DateTime.parse(json['date']),
      checkIn: json['checkIn'] ?? false,
      taskCompleted: json['taskCompleted'] ?? '',
      difficulty: json['difficulty'] ?? '',
      rating: json['rating'] ?? 0,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'checkIn': checkIn,
        'taskCompleted': taskCompleted,
        'difficulty': difficulty,
        'rating': rating,
        'notes': notes,
      };
}



// Participant Document (User ID as Document ID):
// displayName: Display name of the participant.
// email: Email address of the participant.
// joinedDate: Date when the participant joined the challenge.
// isActive: Boolean indicating whether the participant is active in the challenge.
// progress: Array or nested documents tracking daily check-ins or task submissions.
// currentStreak: Number of consecutive days the participant has checked in.
// totalDays: Total number of days the participant has been part of the challenge.
// isChallengeCompleted: Boolean indicating whether the participant has completed the challenge.