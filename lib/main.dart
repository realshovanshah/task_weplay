import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weplay/services/image_service.dart';
import 'package:task_weplay/ui/home/home_screen.dart';
import 'package:task_weplay/ui/login/login_screen.dart';

import 'bloc/image_bloc.dart';

// Program to count the number of letter and occurance of it in the String.

//  final result = {};

//   String test = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum';

//   test.splitMapJoin(
//     RegExp("[a-zA-z]"),
//     onMatch: (match) {
//       var matchedLetter = match.group(0);
//       result.keys.contains(matchedLetter)? result[matchedLetter] += 1: result[matchedLetter] = 1;
//       return "";
//     },
//   );

//   print(result);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  final _imageService = ImageService();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weplay Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) return LoginScreen();
          return BlocProvider(
            create: (context) => ImageBloc(_imageService),
            child: HomeScreen(
              firebaseAuth: _firebaseAuth,
            ),
          );
        },
      ),
    );
  }
}
