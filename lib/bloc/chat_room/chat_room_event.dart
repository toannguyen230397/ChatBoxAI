part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent {}

class DeleteChatRoom extends ChatRoomEvent {}

class UpdateChatRoom extends ChatRoomEvent {
  String inputMessage;
  List<Chat> chatRoom;

  UpdateChatRoom({required this.inputMessage, required this.chatRoom});
}