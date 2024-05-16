import 'package:chat_box_ai/bloc/chat_room/chat_room_bloc.dart';
import 'package:chat_box_ai/model/chat_model.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: Colors.white38,
            ),
          ),
          title: Text(
            'power by Gemini AI',
            style: TextStyle(
                color: Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF303030),
        body: SafeArea(child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
          builder: ((context, state) {
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
                            style: TextStyle(color: Colors.white38),
                          ),
                          subtitle: Text(item['parts'][0]['text']),
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
                            color: Colors.white30,
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
                                  color: Colors.white38,
                                ),
                              ))
                        ],
                      )),
                ],
              );
            }
            if (state.chatRoom.isNotEmpty) {
              final chatRoom = state.chatRoom[0];
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
                              style: TextStyle(color: Colors.white38),
                            ),
                            subtitle: item['role'] == 'user'
                                ? Text(item['parts'][0]['text'])
                                : isLastItem
                                    ? AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                              item['parts'][0]['text']),
                                        ],
                                        isRepeatingAnimation: false,
                                      )
                                    : Text(item['parts'][0]['text']));
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white30,
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
                                        UpdateChatRoom(
                                            inputMessage: inputController.text,
                                            chatRoom: chatRoom));
                                    inputController.clear();
                                    FocusScope.of(context).unfocus();
                                    print(currentChatRoom.roomID);
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white38,
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
                        width: screenSize.width * 0.2,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Image.asset('assets/images/gpt.png'),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white30,
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
                                        UpdateChatRoom(
                                            inputMessage: inputController.text,
                                            chatRoom: chatRoom));
                                    inputController.clear();
                                    FocusScope.of(context).unfocus();
                                    print(id);
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white38,
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
