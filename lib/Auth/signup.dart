import 'package:app_note/component/alert.dart';
import 'package:app_note/home/textfield.dart';
import 'package:app_note/home/texxtfielf.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  Future signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ignore: deprecated_member_use
            Container(
              child: SvgPicture.asset("images/logo.svg",
                  fit: BoxFit.fitWidth,
                  color: Theme.of(context).primaryColor,
                  height: 240),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                  key: formState,
                  child: Column(
                    children: [
                      //textfield of email
                      customButton(
                          hintText: "EMAIL",
                          mycontroller: email,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          )),

                      SizedBox(height: 10),

                      // textfield of password
                      costumEmailButton(
                        mycontroller: password,
                      ),
                      SizedBox(height: 10),

                      //textfield of username
                      customButton(
                        hintText: "USER-NAME ",
                        mycontroller: userName,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text("Already have an account",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("login");
                              },
                              child: Text("LOGIN",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor)),
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                showloading(context);
                                // ignore: unused_local_variable
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                Navigator.of(context)
                                    .pushReplacementNamed("verification");
                                FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .add({
                                  "userName": userName.text,
                                  "email": email.text
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  Navigator.of(context).pop();
                                  print('The password provided is too weak.');
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'The password provided is too weak.',
                                  )..show();
                                } else if (e.code == 'email-already-in-use') {
                                  Navigator.of(context).pop();
                                  print(
                                      'The account already exists for that email.');
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc:
                                        'The account already exists for that email.please login',
                                  )..show();
                                } else {
                                  Navigator.of(context).pop();
                                  print(e.code);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'some think error please try again',
                                  )..show();
                                }
                              }
                            },
                            child: Text("Signup"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              fixedSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          )),
                      SizedBox(height: 20),
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Expanded(
                              child: Divider(
                            thickness: 1,
                            color: Theme.of(context).primaryColor,
                          )),
                          SizedBox(width: 10),
                          Text(
                            "OR",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: Divider(
                            thickness: 1,
                            color: Theme.of(context).primaryColor,
                          )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                signInWithFacebook();
                              },
                              child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color.fromRGBO(227, 219, 219, 0.773),
                                      border: Border.fromBorderSide(
                                        BorderSide(),
                                      )

                                      //    color: Color.fromARGB(255, 203, 229, 233),
                                      // border:
                                      //  Border.all(color: Colors.blue, width: 3),
                                      ),
                                  child: SvgPicture.asset("images/facebook.svg",
                                      color: Colors.blue, height: 45)),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            GestureDetector(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color.fromRGBO(227, 219, 219, 0.773),
                                      border: Border.fromBorderSide(
                                        BorderSide(),
                                      )
                                      // color: Color.fromARGB(255, 248, 220, 220),
                                      /* border:
                                      
                                        Border.all(color: Color.fromARGB(255, 187, 3, 3), width: 3),*/
                                      ),
                                  child: SvgPicture.asset(
                                      "images/google-plus.svg",
                                      color: Color.fromARGB(255, 199, 3, 3),
                                      height: 45)),
                            )
                          ])
                    ],
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
