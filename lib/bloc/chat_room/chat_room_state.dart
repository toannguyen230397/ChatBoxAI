part of 'chat_room_bloc.dart';

abstract class ChatRoomState {
  List<Chat> chatRoom;
  ChatRoomState({required this.chatRoom});
}

class ChatRoomStateInitial extends ChatRoomState {
  ChatRoomStateInitial({required List<Chat> chatRoom}) : super(chatRoom: chatRoom);
}

class ChatRoomStateUpdate extends ChatRoomState {
  ChatRoomStateUpdate({required List<Chat> chatRoom}) : super(chatRoom: chatRoom);
}

class ChatRoomStateLoading extends ChatRoomState {
  ChatRoomStateLoading({required List<Chat> chatRoom}) : super(chatRoom: chatRoom);
}

class ChatRoomStateDone extends ChatRoomState {
  ChatRoomStateDone({required List<Chat> chatRoom}) : super(chatRoom: chatRoom);
}

class ChatRoomStateError extends ChatRoomState {
  String errorMessage;

  ChatRoomStateError({required this.errorMessage, required List<Chat> chatRoom}) : super(chatRoom: chatRoom);
}