part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent {}

class CreateChatRoom extends ChatRoomEvent {}

class DeleteChatRoom extends ChatRoomEvent {}

class UpdateChatRoom extends ChatRoomEvent {
  List<Chat> chatRoom;

  UpdateChatRoom({required this.chatRoom});
}

class SendMessage extends ChatRoomEvent {
  String inputMessage;
  List<Chat> chatRoom;

  SendMessage({required this.inputMessage, required this.chatRoom});
}