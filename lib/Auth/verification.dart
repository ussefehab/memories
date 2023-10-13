import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class verify extends StatefulWidget {
  @override
  _verifyState createState() => _verifyState();
}

class _verifyState extends State<verify> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isEmailVerified = true;
  Timer? timer;


 void initState(){
  super.initState();

  isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  if (!isEmailVerified) {
    timer = Timer.periodic(Duration(seconds: 5), (_) =>checkEmailVerified());
    
  }
 } 
 void disposed(){
  timer?.cancel();
  super.dispose();
 }
 
Future checkEmailVerified()async{
  await FirebaseAuth.instance.currentUser!.reload();
  setState(() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  });
  if (isEmailVerified)timer?.cancel();
  if (isEmailVerified) {
     Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }
 
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(50),
        child: Column(
          key: formState,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 55,
              color: Colors.black,
            ),
            SizedBox(height: 25),
            Text(
              " Verify your email address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 18),
            Text(
                "We have just send email verification link on your email . please check email and click on that link to verify your email address ."),
            SizedBox(height: 18),
            Text(
                "if not auto redirected after verification , click on the continue button"),
            SizedBox(height: 25),
            TextButton(
                onPressed: () { FirebaseAuth.instance.currentUser!.emailVerified?
                  Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false):                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'please go to email to confirm your account',
                              ).show();},
                child: Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.fromLTRB(50, 10, 50, 10)),
                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: Colors.black, style: BorderStyle.solid))))

          
                ),
            SizedBox(height: 25),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.currentUser!.sendEmailVerification();
              },
              child: Text("resend email-link",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  },
                  icon: Icon(Icons.arrow_back_sharp),
                  color: Colors.blue,
                ),
                Text(
                  "back to log in ",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
 
      ),
    );
  }
}
