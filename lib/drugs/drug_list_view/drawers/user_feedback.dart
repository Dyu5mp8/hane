

class UserFeedback{

 String masterUID;
  String feedback;
  String timestamp;
  String userId;

  UserFeedback({
    required this.masterUID,
    required this.feedback,
    required this.timestamp,
    required this.userId,
  });

 

factory UserFeedback.fromFirestore(Map<String, dynamic> map) {
    return UserFeedback(
      masterUID: map['id'] as String,
      feedback: map['feedback'] as String,
      timestamp: map['date'] as String,
      userId: map['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['master'] = this.masterUID;
    data['feedback'] = this.feedback;
    data['timestamp'] = this.timestamp;
    data['userId'] = this.userId;
    return data;
  }
}