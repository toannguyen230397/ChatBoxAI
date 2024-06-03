import 'package:chat_box_ai/bloc/chat/chat_bloc.dart';
import 'package:chat_box_ai/bloc/chat_room/chat_room_bloc.dart';
import 'package:chat_box_ai/screen/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 2));
  FlutterNativeSplash.remove(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChatBloc()),
          BlocProvider(create: (context) => ChatRoomBloc()),
          ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: Colors.white38,
              cursorColor: Colors.white,
              selectionHandleColor: Colors.white,
            ),
          ),
          home: const HomeScreen(),
        )
      ),
    );
  }
}