part of 'chat_bloc.dart';

abstract class ChatEvent {}

class CreateChat extends ChatEvent {
  final Chat chat;
  final String smg;

  CreateChat({required this.chat, required this.smg});
}

class DeleteChat extends ChatEvent {
  final Chat chat;

  DeleteChat({required this.chat});
}

class UpdateChat extends ChatEvent {
  final Chat chat;

  UpdateChat({required this.chat});
}

class LoadData extends ChatEvent {}