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

    emit(ChatRoomStateLoading(chatRoom: state.chatRoom));

    try {
      final currentChatRoom = event.chatRoom[0];
      List<dynamic> currentMessage = currentChatRoom.message;

      // Awaiting for each value emitted by the Stream returned by sendRequest
      final messageResponse =
          await ChatAPI().sendRequest(event.inputMessage, currentMessage);
      String text = messageResponse["parts"][0]["text"];

      if (text.isEmpty) {
        emit(ChatRoomStateError(
            errorMessage: 'Đã có lỗi xảy ra, xin vui lòng thử lại sau :(',
            chatRoom: state.chatRoom));
      } else {
        List<dynamic> newMessage = currentMessage;
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
        await db.collection('chat').doc(id).set({
          'roomID': chat.roomID,
          'roomTitle': chat.roomTitle,
          'creatTime': chat.creatTime,
          'message': chat.message,
        });
        emit(ChatRoomStateUpdate(chatRoom: newChatRoom));
      }
    } catch (e) {
      emit(ChatRoomStateError(
          errorMessage: 'Đã có lỗi xảy ra, xin vui lòng thử lại sau :(',
          chatRoom: state.chatRoom));
      print('An unexpected error occurred: $e');
    }
  }

// Stream<void> _SendMessage(SendMessage event, Emitter<ChatRoomState> emit) async* {
//     state.chatRoom = event.chatRoom;
//     emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
//     try{
//       emit(ChatRoomStateLoading(chatRoom: state.chatRoom));

//       final currentChatRoom = event.chatRoom[0];
//       final String apiURL = 'https://chatboxai-backend.onrender.com/';
//       final Uri uri = Uri.parse('${apiURL}geminiAPI');

//       String msg = event.inputMessage;
//       List<dynamic> history = state.chatRoom.map((item) {item.message;}).toList();

//       final request = http.Request('POST', uri)
//         ..headers['Content-Type'] = 'application/json; charset=UTF-8'
//         ..body = jsonEncode({
//           'msg': msg,
//           'history': history,
//         });

//       final streamedResponse = await request.send();

//       if (streamedResponse.statusCode == 200) {
//         await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
//           final Map<String, dynamic> responseData = json.decode(chunk);
//           List<dynamic> newMessage = history;
//           newMessage.add(responseData);
//           final chat = Chat(
//             roomID: currentChatRoom.roomID,
//             roomTitle: currentChatRoom.roomTitle,
//             creatTime: currentChatRoom.creatTime,
//             message: newMessage,
//           );
//           List<Chat> newChatRoom = [chat];
//           final db = Localstore.instance;
//           final id = chat.roomID;
//           await db.collection('chat').doc(id).set({
//             'roomID': chat.roomID,
//             'roomTitle': chat.roomTitle,
//             'creatTime': chat.creatTime,
//             'message': chat.message,
//           });
//           emit(ChatRoomStateUpdate(chatRoom: newChatRoom));
//         }
//       } else {
//         throw Exception('Failed to post data');
//       }
//     }catch(e){
//       emit(ChatRoomStateError(errorMessage: 'Đã có lỗi xảy ra, xin vui lòng thử lại sau :(', chatRoom: state.chatRoom));
//       print('An unexpected error occurred: $e');
//     }
//   }

  void _CreateChatRoom(CreateChatRoom event, Emitter<ChatRoomState> emit) {
    state.chatRoom = [];
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  }

  void _UpdateChatRoom(UpdateChatRoom event, Emitter<ChatRoomState> emit) {
    state.chatRoom = event.chatRoom;
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  }

  void _UpdateChatRoomType(
      UpdateChatRoomType event, Emitter<ChatRoomState> emit) {
    emit(ChatRoomStateTypeUpdate(type: event.type, chatRoom: state.chatRoom));
  }

  void _DeleteChatRoom(DeleteChatRoom event, Emitter<ChatRoomState> emit) {
    state.chatRoom = [];
    emit(ChatRoomStateUpdate(chatRoom: state.chatRoom));
  }
}
