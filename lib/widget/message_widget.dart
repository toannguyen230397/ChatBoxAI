import 'package:chat_box_ai/bloc/chat_room/chat_room_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class MessageWidget extends StatefulWidget {
  final String text;
  final String type;
  const MessageWidget({required this.text, required this.type});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  late String displayedText = '';
  int charIndex = 0;

  @override
  void initState() {
    super.initState();
    if(widget.type == 'Chatting') {
      _startTyping();
    }
  }

  void _startTyping() async {
    for (int i = 0; i <= widget.text.length; i++) {
      if(i == widget.text.length) {
        final chatRoom = context.read<ChatRoomBloc>().state.chatRoom;
        context.read<ChatRoomBloc>().add(UpdateChatRoom(chatRoom: chatRoom));
        context.read<ChatRoomBloc>().add(UpdateChatRoomType(type: 'endResponse'));
      } else {
        if(mounted) {
          await Future.delayed(Duration(milliseconds: 1));
          setState(() {
            displayedText = widget.text.substring(0, i);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: widget.type == 'Chatting' ? displayedText : widget.text,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(color: Colors.white),
        p: TextStyle(color: Colors.white38),
        strong: TextStyle(color: Colors.white),
        listBullet: TextStyle(color: Colors.white, fontSize: 20),
      ),
      builders: {'code': HighlightCodeBuilder()},
    );
  }
}

class HighlightCodeBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final text = element.textContent;
    return Builder(
      builder: (context) {
        Size screenSize = MediaQuery.of(context).size;
        return Container(
          color: Color(0xFF303030),
          width: screenSize.width,
          child: HighlightView(
                text,
                language: 'dart',
                theme: darkTheme,
                padding: EdgeInsets.all(12),
                textStyle: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 16,
                ),
              ),
        );
      }
    );
  }
}