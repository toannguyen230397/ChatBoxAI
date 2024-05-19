class Chat {
  final String roomID;
  final String roomTitle;
  final int creatTime;
  final List message;

  Chat({
    required this.roomID,
    required this.roomTitle,
    required this.creatTime,
    required this.message,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      roomID: map['roomID'],
      roomTitle: map['roomTitle'],
      creatTime: map['creatTime'],
      message: List.from(map['message']),
    );
  }
}