import 'dart:ffi';

import 'package:chat_box_ai/api/api_helper.dart';
import 'package:chat_box_ai/model/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc() : super(ChatRoomStateInitial(chatRoom: [])) {
    on<UpdateChatRoom>(_UpdateChatRoom);
    on<DeleteChatRoom>(_DeleteChatRoom);
  }

  // void _UpdateChatRoom(
  //     UpdateChatRoom event, Emitter<ChatRoomState> emit) async {
  //   state.chatRoom = event.chatRoom;
  //   emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  // }

  // Future<void> _UpdateChatRoom(
  //     UpdateChatRoom event, Emitter<ChatRoomState> emit) async {
  //   state.chatRoom = event.chatRoom;
  //   emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
    
  // await Future.delayed(Duration(seconds: 2), () async {
  //     final currentChatRoom = event.chatRoom[0];
  //     List<dynamic> history = currentChatRoom.message;
  //     history.length > 0 ? history.removeLast() : null;
  //     final messageList = await ChatAPI()
  //         .sendRequest(event.inputMessage, history);
  //     final chat = Chat(
  //       roomID: currentChatRoom.roomID,
  //       roomTitle: currentChatRoom.roomTitle,
  //       creatTime: currentChatRoom.creatTime,
  //       message: messageList,
  //     );
  //     List<Chat> newChatRoom = [chat];
  //     emit(ChatRoomStateUpdate(chatRoom: newChatRoom));
  //   });
  // }

  Future<void> _UpdateChatRoom(
      UpdateChatRoom event, Emitter<ChatRoomState> emit) async {
    state.chatRoom = event.chatRoom;
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
    
    try{
      emit(ChatRoomStateLoading(chatRoom: state.chatRoom));
      final currentChatRoom = event.chatRoom[0];
      List<dynamic> history = currentChatRoom.message;
      final messageResponse = await ChatAPI()
          .sendRequest(event.inputMessage, history);
      List<dynamic> newMessage = history;
      newMessage.add(messageResponse);
      final chat = Chat(
        roomID: currentChatRoom.roomID,
        roomTitle: currentChatRoom.roomTitle,
        creatTime: currentChatRoom.creatTime,
        message: newMessage,
      );
      List<Chat> newChatRoom = [chat];
      emit(ChatRoomStateUpdate(chatRoom: newChatRoom));
    }catch(e){
      print(e);
    }
  }

  void _DeleteChatRoom(DeleteChatRoom event, Emitter<ChatRoomState> emit) {
    state.chatRoom = [];
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  }
}
