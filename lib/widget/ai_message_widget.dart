import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_box_ai/bloc/chat_room/chat_room_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/dark.dart';

class MessagePart {
  String? text;
  String? code;

  MessagePart({this.text, this.code});

  @override
  String toString() {
    return 'MessagePart{text: $text, code: $code}';
  }
}

class AIMessageWidget extends StatefulWidget {
  final String message;
  final String status;
  const AIMessageWidget({required this.message, required this.status});

  @override
  State<AIMessageWidget> createState() => _AIMessageWidgetState();
}

class _AIMessageWidgetState extends State<AIMessageWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  int selectedIndex = 0;
  bool showCode = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<MessagePart> parseMessageParts(String input) {
    RegExp codeRegExp = RegExp(r'```(.*?)```', dotAll: true);

    List<MessagePart> messageParts = [];
    int lastMatchEnd = 0;

    // Tìm tất cả các đoạn code
    Iterable<RegExpMatch> matches = codeRegExp.allMatches(input);

    for (var match in matches) {
      // Lấy đoạn text trước đoạn code
      if (match.start > lastMatchEnd) {
        String textPart = input.substring(lastMatchEnd, match.start).trim();
        if (textPart.isNotEmpty) {
          messageParts.add(MessagePart(text: textPart));
        }
      }

      // Thêm phần code
      String codePart = match.group(1)?.trim() ?? "";
      if (codePart.isNotEmpty) {
        messageParts.add(MessagePart(code: codePart));
      }

      lastMatchEnd = match.end;
    }

    // Lấy đoạn text sau đoạn code cuối cùng
    if (lastMatchEnd < input.length) {
      String textPart = input.substring(lastMatchEnd).trim();
      if (textPart.isNotEmpty) {
        messageParts.add(MessagePart(text: textPart));
      }
    }

    return messageParts;
  }

  @override
  Widget build(BuildContext context) {
    List<MessagePart> messageParts = parseMessageParts(widget.message);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(messageParts.length, (index) {
        MessagePart part = messageParts[index];
        if(selectedIndex == messageParts.length) {
          final chatRoom = context.read<ChatRoomBloc>().state.chatRoom;
          context.read<ChatRoomBloc>().add(UpdateChatRoom(chatRoom: chatRoom));
          context.read<ChatRoomBloc>().add(UpdateChatRoomType(type: 'endResponse'));
        }
        if (index == selectedIndex && widget.status == 'chatting') {
          if (part.text != null && part.code != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(part.text!, textStyle: TextStyle(color: Colors.white38)),
                  ],
                  isRepeatingAnimation: false,
                  onFinished: () async {
                    if (mounted) {
                      setState(() {
                        showCode = true;
                      });
                      _controller.forward();
                      await Future.delayed(Duration(seconds: 2)); // Điều chỉnh thời gian nếu cần
                      if (mounted) {
                        setState(() {
                          selectedIndex++;
                          showCode = false;
                        });
                      }
                    }
                  },
                ),
                showCode
                    ? SlideTransition(
                        position: _offsetAnimation,
                        child: CodeFieldWidget(code: part.code!))
                    : Container()
              ],
            );
          }
          if (part.code != null && part.text == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              _controller.forward();
              await Future.delayed(Duration(seconds: 2));
              if (mounted) {
                setState(() {
                  selectedIndex++;
                });
              }
            });
            return SlideTransition(
                position: _offsetAnimation,
                child: CodeFieldWidget(code: part.code!));
          } else if (part.text != null && part.code == null) {
            return AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(part.text!, textStyle: TextStyle(color: Colors.white38)),
              ],
              isRepeatingAnimation: false,
              onFinished: () {
                if (mounted) {
                  setState(() {
                    selectedIndex++;
                    showCode = false;
                  });
                }
              },
            );
          } else {
            return SizedBox.shrink();
          }
        } else if (index < selectedIndex || widget.status == 'normad') {
          if (part.text != null && part.code != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(part.text!, style: TextStyle(color: Colors.white38),), CodeFieldWidget(code: part.code!)],
            );
          }
          if (part.code != null && part.text == null) {
            return CodeFieldWidget(code: part.code!);
          } else if (part.text != null && part.code == null) {
            return Text(part.text!, style: TextStyle(color: Colors.white38));
          } else {
            return SizedBox.shrink();
          }
        }
        return SizedBox.shrink();
      }),
    );
  }
}

class CodeFieldWidget extends StatefulWidget {
  final String code;
  const CodeFieldWidget({required this.code});

  @override
  State<CodeFieldWidget> createState() => _CodeFieldWidgetState();
}

class _CodeFieldWidgetState extends State<CodeFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF303030),
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
      child: HighlightView(
        widget.code,
        language: 'dart',
        theme: darkTheme, // chọn theme cho phù hợp
        padding: EdgeInsets.all(12),
        textStyle: TextStyle(
          fontFamily: 'Courier', // font của code
          fontSize: 16,
        ),
      ),
    );
  }
}
