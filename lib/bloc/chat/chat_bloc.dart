import 'package:chat_box_ai/database/database_helper.dart';
import 'package:chat_box_ai/model/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatStateInitial(chat: [])) {
    on<CreateChat>(_CreateChat);
    on<UpdateChat>(_UpdateChat);
    on<DeleteChat>(_DeleteChat);
  }

  void _CreateChat (CreateChat event, Emitter<ChatState> emit) {
    state.chat.add(event.chat);
    emit(ChatStateUpdate(chat: state.chat));
  }

  void _UpdateChat(UpdateChat event, Emitter<ChatState> emit) async {
    for (int i = 0; i < state.chat.length; i++) {
      if (event.chat.roomID == state.chat[i].roomID) {
        state.chat[i] = event.chat;
      }
    }
    emit(ChatStateUpdate(chat: state.chat));
  }

  void _DeleteChat (DeleteChat event, Emitter<ChatState> emit) {
    ChatDatabase().removeDoc(docID: event.chat.roomID);
    state.chat.remove(event.chat);
    emit(ChatStateUpdate(chat: state.chat));
  }
}
