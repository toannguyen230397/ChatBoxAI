import 'package:chat_box_ai/bloc/chat/chat_bloc.dart';
import 'package:chat_box_ai/bloc/chat_room/chat_room_bloc.dart';
import 'package:chat_box_ai/model/chat_model.dart';
import 'package:chat_box_ai/widget/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    TextEditingController inputController = TextEditingController();
    final ScrollController scrollController = ScrollController();
    void _scrollToBottom() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    return Scaffold(
        drawer: DrawerBuilder(),
        drawerScrimColor: Colors.white10,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white38,
                ),
              );
            },
          ), 
          title: Text(
            'power by Gemini AI',
            style: TextStyle(
                color: Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            BlocBuilder<ChatRoomBloc, ChatRoomState>(
              builder: (context, state) {
                if(state is ChatRoomStateInitial) {
                  context.read<ChatBloc>().add(LoadData());
                }
                if(state is ChatRoomStateUpdate && state.chatRoom.isNotEmpty || state is ChatRoomStateError) {
                  return IconButton(
                    onPressed: () {
                      context.read<ChatRoomBloc>().add(CreateChatRoom());
                    },
                    icon: Icon(Icons.add_circle_outline, color: Colors.white38,)
                  );
                } else {
                  return Container();
                }
              }
            )
          ],
        ),
        backgroundColor: Color(0xFF303030),
        body: SafeArea(child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
          builder: ((context, state) {
            if (state is ChatRoomStateError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/error_animation.json',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      state.errorMessage,
                      style: TextStyle(
                          color: Colors.white38, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }
            if (state is ChatRoomStateLoading) {
              final chatRoom = state.chatRoom[0];
              List messageList = chatRoom.message;
              messageList = messageList.reversed.toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        final item = messageList[index];
                        return ListTile(
                          title: Text(
                            item['role'] == 'user' ? 'Bạn:' : 'AI:',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(item['parts'][0]['text'], style: TextStyle(color: Colors.white38),),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'AI:',
                          style: TextStyle(color: Colors.white38),
                        ),
                        Lottie.asset('assets/animations/loading_animation.json',
                            width: 50),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white38,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: TextField(
                              readOnly: true,
                              controller: inputController,
                              style: TextStyle(color: Colors.white38),
                              cursorColor: Colors.white38,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập tin nhắn...',
                                  hintStyle: TextStyle(color: Colors.white38)),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      )),
                ],
              );
            }
            if (state is ChatRoomStateUpdate && state.chatRoom.isNotEmpty) {
              final chatRoom = state.chatRoom[0];
              if(chatRoom.message.length > 1) {
                context.read<ChatBloc>().add(CreateChat(chat: chatRoom));
              }   
              List messageList = chatRoom.message;
              messageList = messageList.reversed.toList();
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        final item = messageList[index];
                        final isLastItem = index == 0;
                        return ListTile(
                            title: Text(
                              item['role'] == 'user' ? 'Bạn:' : 'AI:',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: item['role'] == 'user'
                                ? Text(item['parts'][0]['text'], style: TextStyle(color: Colors.white38),)
                                : isLastItem
                                    ? AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                              item['parts'][0]['text'], textStyle: TextStyle(color: Colors.white38)),
                                        ],
                                        isRepeatingAnimation: false,
                                      )
                                    : Text(item['parts'][0]['text'], style: TextStyle(color: Colors.white38),),);
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white38,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: TextField(
                              controller: inputController,
                              style: TextStyle(color: Colors.white38),
                              cursorColor: Colors.white38,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập tin nhắn...',
                                  hintStyle: TextStyle(color: Colors.white38)),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  final FocusScopeNode currentScope =
                                      FocusScope.of(context);
                                  if (!currentScope.hasPrimaryFocus &&
                                      currentScope.hasFocus) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                  if (inputController.text.trim() == '') {
                                    print('empty input');
                                  } else {
                                    final currentChatRoom = state.chatRoom[0];
                                    Map<String, dynamic> inputMessage = {
                                      "role": "user",
                                      "parts": [
                                        {"text": inputController.text}
                                      ]
                                    };
                                    messageList = messageList.reversed.toList();
                                    messageList.add(inputMessage);
                                    final chat = Chat(
                                      roomID: currentChatRoom.roomID,
                                      roomTitle: currentChatRoom.roomTitle,
                                      creatTime: currentChatRoom.creatTime,
                                      message: messageList,
                                    );
                                    List<Chat> chatRoom = [chat];
                                    context.read<ChatRoomBloc>().add(
                                        SendMessage(
                                            inputMessage: inputController.text,
                                            chatRoom: chatRoom));
                                    inputController.clear();
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      )),
                ],
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Center(
                      child: Container(
                        width: screenSize.width * 0.15,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Image.asset('assets/images/icon.png'),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white38,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: TextField(
                              controller: inputController,
                              style: TextStyle(color: Colors.white38),
                              cursorColor: Colors.white38,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập tin nhắn...',
                                  hintStyle: TextStyle(color: Colors.white38)),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  final FocusScopeNode currentScope =
                                      FocusScope.of(context);
                                  if (!currentScope.hasPrimaryFocus &&
                                      currentScope.hasFocus) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                  if (inputController.text.trim() == '') {
                                    print('empty input');
                                  } else {
                                    final db = Localstore.instance;
                                    final id = db.collection('chat').doc().id;
                                    List newMessage = [
                                      {
                                        "role": "user",
                                        "parts": [
                                          {"text": inputController.text}
                                        ]
                                      }
                                    ];
                                    final chat = Chat(
                                      roomID: id,
                                      roomTitle: inputController.text,
                                      creatTime:
                                          DateTime.now().millisecondsSinceEpoch,
                                      message: newMessage,
                                    );
                                    List<Chat> chatRoom = [chat];
                                    context.read<ChatRoomBloc>().add(
                                        SendMessage(
                                            inputMessage: inputController.text,
                                            chatRoom: chatRoom));
                                    inputController.clear();
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      )),
                ],
              );
            }
          }),
        )));
  }
}
