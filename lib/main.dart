import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:itutor1/Login%20and%20create%20account/alreadylogin.dart';
import 'package:itutor1/Login%20and%20create%20account/createnewaccount.dart';
import 'package:itutor1/Login%20and%20create%20account/logintoyouraccount.dart';
import 'package:itutor1/Login%20and%20create%20account/splashstarting.dart';
import 'package:itutor1/accountandsettings/profile.dart';
import 'package:itutor1/firebase_options.dart';

import 'package:itutor1/homepages%20and%20chats/homepage.dart';
import 'package:itutor1/providers/studentProviders/studentProvider.dart';
import 'package:provider/provider.dart';

import 'Login and create account/useroradmin.dart';
import 'providers/RegisterPageProvider.dart';
import 'providers/createQuizProvider.dart';
import 'providers/loginPageProvider.dart';
import 'providers/provider.dart';
import 'providers/studentProviders/startQuizProvider.dart';
import 'providers/studentProviders/studentSnapshotProvider.dart';
import 'providers/studentProviders/timerCountDownProvider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(itutor());
}

class itutor extends StatelessWidget {
  const itutor({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RegisterPageProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => LoginPageProvider(), lazy: false),
        ChangeNotifierProvider(
            create: (_) => CreateQuizProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => StudentProvider(), lazy: false),
        ChangeNotifierProvider(
            create: (_) => ProfilePageProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => StartQuizProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => TimerProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => SnapshotProvider(), lazy: false),
      ],
      child: MaterialApp(
        title: "Flutter App",
        debugShowCheckedModeBanner: false,
        routes: {
          '/splash': (context) => splash_screen(),
          '/login': (context) => logintoacc(),
          '/intro': (context) => alreadylogin(),
          '/register': (context) => Createnewacc(),
          '/home': (context) => home(),
          '/profile': (context) => profilepage(),
          // '/bot': (context) => bot(),
        },
        initialRoute: '/',
        home: splash_screen(),
      ),
    );
  }
}
