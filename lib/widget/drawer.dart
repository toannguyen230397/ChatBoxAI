import 'package:chat_box_ai/bloc/chat/chat_bloc.dart';
import 'package:chat_box_ai/bloc/chat_room/chat_room_bloc.dart';
import 'package:chat_box_ai/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerBuilder extends StatelessWidget {
  const DrawerBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      width: screenSize.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child:
              BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            if (state is ChatStateInitial) {}
            if (state is ChatStateUpdate) {
              final chatList = state.chat;
              final reverseChatList = chatList.reversed.toList();
              final chatRoom = context.read<ChatRoomBloc>().state.chatRoom;
              return ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final item = reverseChatList[index];
                  return InkWell(
                    onTap: () {
                      List<Chat> selectedChatRoom = [];
                      selectedChatRoom.add(item);
                      context.read<ChatRoomBloc>().add(UpdateChatRoom(chatRoom: selectedChatRoom));
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                              color: chatRoom.isNotEmpty ? item.roomID == chatRoom[0].roomID ? Colors.white24 : null : null,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                      child: ListTile(
                        title: Text('Room: ${item.roomID}', maxLines: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text('Tin nhắn cuối: ${item.message.last['parts'].last['text']}', style: TextStyle(
                          color: chatRoom.isNotEmpty ? item.roomID == chatRoom[0].roomID ? Colors.white : null : null,
                        ),),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('Chưa có phòng Chat nào được tạo', style: TextStyle(color: Colors.white38)));
            }
          }))
        ],
      ),
    );
  }
}
