import 'package:chat_box_ai/bloc/chat/chat_bloc.dart';
import 'package:chat_box_ai/bloc/chat_room/chat_room_bloc.dart';
import 'package:chat_box_ai/model/chat_model.dart';
import 'package:chat_box_ai/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            if (state is ChatStateInitial) {
              print('state is ChatStateInitial');
            }
            if (state is ChatStateUpdate && state.chat.isNotEmpty) {
              final chatList = state.chat;
              chatList.sort((a,b) {
                var aTimeStamp = a.creatTime;
                var bTimeStamp = b.creatTime;
                return aTimeStamp.compareTo(bTimeStamp);
              });
              final reverseChatList = chatList.reversed.toList();
              final chatRoom = context.read<ChatRoomBloc>().state.chatRoom;
              return ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final item = reverseChatList[index];
                  return Center(
                    child: InkWell(
                      onTap: () {
                        List<Chat> selectedChatRoom = [];
                        selectedChatRoom.add(item);
                        context
                            .read<ChatRoomBloc>()
                            .add(UpdateChatRoom(chatRoom: selectedChatRoom));
                        context
                            .read<ChatRoomBloc>()
                            .add(UpdateChatRoomType(type: 'navigation'));
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomeScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: chatRoom.isNotEmpty
                              ? item.roomID == chatRoom[0].roomID
                                  ? Colors.white24
                                  : null
                              : null,
                          border: chatRoom.isNotEmpty
                              ? item.roomID != chatRoom[0].roomID
                                  ? Border(
                                      bottom: BorderSide(color: Colors.white38))
                                  : null
                              : null,
                        ),
                        child: Slidable(
                          endActionPane:
                              ActionPane(motion: StretchMotion(), children: [
                            SlidableAction(
                              backgroundColor: Colors.white12,
                              icon: Icons.delete,
                              foregroundColor: Colors.white,
                              onPressed: (context) {
                                context
                                    .read<ChatBloc>()
                                    .add(DeleteChat(chat: item));
                                if (chatRoom.isNotEmpty &&
                                    item.roomID == chatRoom[0].roomID) {
                                  context
                                      .read<ChatRoomBloc>()
                                      .add(CreateChatRoom());
                                }
                              },
                            )
                          ]),
                          child: Container(
                            child: ListTile(
                              title: Text('Room: ${item.roomID}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'Tin nhắn cuối: ${item.message.last['parts'].last['text']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: chatRoom.isNotEmpty
                                      ? item.roomID == chatRoom[0].roomID
                                          ? Colors.white
                                          : Colors.white38
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                  child: Text('Chưa có phòng Chat nào được tạo',
                      style: TextStyle(color: Colors.white38)));
            }
          }))
        ],
      ),
    );
  }
}
