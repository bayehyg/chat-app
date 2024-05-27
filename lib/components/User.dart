class ChatUser {
  final String avatarName;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime lastSeen;

  ChatUser({
    required this.avatarName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.lastSeen,
  });

  // Factory method to create a User from a map (e.g., Firestore document)
  factory ChatUser.fromMap(Map<String, dynamic> data) {
    return ChatUser(
      avatarName: data['avatarName'] as String,
      email: data['email'] as String,
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['lastSeen'].seconds * 1000),
    );
  }

  // Method to convert User to a map
  Map<String, dynamic> toMap() {
    return {
      'avatarName': avatarName,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'lastSeen': lastSeen,
    };
  }

  String getFullName(){
    return "$firstName $lastName";
  }

  // Method to get a formatted last seen date
  // String getLastSeenDate() {
  //   final dateTime = DateTime.fromMillisecondsSinceEpoch(lastSeen);
  //   return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  // }
}
