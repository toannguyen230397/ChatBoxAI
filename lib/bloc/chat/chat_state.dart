part of 'chat_bloc.dart';

abstract class ChatState {
  List<Chat> chat;
  ChatState({required this.chat});
}

class ChatStateInitial extends ChatState {
  ChatStateInitial({required List<Chat> chat}) : super(chat: chat);
}

class ChatStateUpdate extends ChatState {
  ChatStateUpdate({required List<Chat> chat}) : super(chat: chat);
}

class ChatStateLoading extends ChatState {
  ChatStateLoading({required List<Chat> chat}) : super(chat: chat);
}