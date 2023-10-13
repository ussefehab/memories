import 'package:app_note/Auth/login.dart';
import 'package:app_note/Auth/signup.dart';
import 'package:app_note/Auth/verification.dart';
import 'package:app_note/add/addpage.dart';
import 'package:app_note/add/editpage.dart';
import 'package:app_note/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
     
      }

    }
    );
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {


return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
              : Login(),



      theme: ThemeData(
          fontFamily: "RobotoSlab",
          primaryColor: Color.fromARGB(255, 155, 111, 45)),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "home": (context) => HomePage(),
        "adding": (context) => AddPage(),
       "verification": (context) => verify(),
       "edit":(context) => EditNotes()
      });

  }
}
