part of 'chat_bloc.dart';

abstract class ChatEvent {}

class CreateChat extends ChatEvent {
  final Chat chat;

  CreateChat({required this.chat});
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