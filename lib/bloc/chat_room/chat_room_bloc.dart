import 'package:chat_box_ai/api/api_helper.dart';
import 'package:chat_box_ai/model/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';
part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc() : super(ChatRoomStateInitial(chatRoom: [])) {
    on<SendMessage>(_SendMessage);
    on<DeleteChatRoom>(_DeleteChatRoom);
    on<CreateChatRoom>(_CreateChatRoom);
    on<UpdateChatRoom>(_UpdateChatRoom);
    on<UpdateChatRoomType>(_UpdateChatRoomType);
  }

  Future<void> _SendMessage(
      SendMessage event, Emitter<ChatRoomState> emit) async {
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
      final db = Localstore.instance;
      final id = chat.roomID;
      db.collection('chat').doc(id).set({
        'roomID': chat.roomID,
        'roomTitle': chat.roomTitle,
        'creatTime': chat.creatTime,
        'message': chat.message,
      }).then((value) {
        print(value);
      });
      emit(ChatRoomStateUpdate(chatRoom: newChatRoom));
    }catch(e){
      emit(ChatRoomStateError(errorMessage: 'Đã có lỗi xảy ra, xin vui lòng thử lại sau :(', chatRoom: state.chatRoom));
      print('An unexpected error occurred: $e');
    }
  }

  void _CreateChatRoom(CreateChatRoom event, Emitter<ChatRoomState> emit) {
    state.chatRoom = [];
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  }

  void _UpdateChatRoom(UpdateChatRoom event, Emitter<ChatRoomState> emit) {
    state.chatRoom = event.chatRoom;
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  }

  void _UpdateChatRoomType(UpdateChatRoomType event, Emitter<ChatRoomState> emit) {
    emit(ChatRoomStateTypeUpdate(type: event.type, chatRoom: state.chatRoom));
  }

  void _DeleteChatRoom(DeleteChatRoom event, Emitter<ChatRoomState> emit) {
    state.chatRoom = [];
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  }
}
