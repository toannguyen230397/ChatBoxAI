import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF303030),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Text('AI:', style: TextStyle(color: Colors.white38),),
              Lottie.asset('assets/animations/loading_animation.json', width: 50),
            ],
          )
        ),
      ),
    );
  }
}
