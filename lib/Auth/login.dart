// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, unused_local_variable

import 'package:app_note/component/alert.dart';
import 'package:app_note/home/textfield.dart';
import 'package:app_note/home/texxtfielf.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

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
                      customButton(
                        hintText: "EMAIL",
                        mycontroller: email,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      costumEmailButton(
                        mycontroller: password,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email.text);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'INFO',
                                  desc:
                                      'password reset email was sent to your email address',
                                ).show();
                              } catch (e) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'error',
                                  desc: 'please enter a valid email address',
                                ).show();
                              }
                            },
                            child: Text("Forget your password !",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                          )
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                showloading(context);
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                if (credential.user!.emailVerified) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "home", (route) => false);
                                } else {
                                  Navigator.of(context).pop();
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();

                                  //'please go to email to confirm your account',

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "verification", (route) => false);
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "INVALID_LOGIN_CREDENTIALS") {
                                  Navigator.of(context).pop();
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'Wrong email or password',
                                  ).show();
                                } else {
                                  Navigator.of(context).pop();
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.rightSlide,
                                    title: 'Error',
                                    desc: 'some thing wrong please try again',
                                  ).show();
                                }
                              }
                            },
                            child: Text("LOGIN"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              fixedSize: Size(320, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          )),
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Didn't have an account",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("signup");
                              },
                              child: Text("SIGNUP",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor)),
                            )
                          ],
                        ),
                      ),
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
                                          border: Border.fromBorderSide(BorderSide(),)
                                          
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
                                          Color.fromRGBO(226, 227, 219, 0.773),
                                          border: Border.fromBorderSide(BorderSide(),)
                                      /* border:
                                        
                                          Border.all(color: Color.fromARGB(255, 187, 3, 3), width: 3),*/
                                      ),
                                  child: SvgPicture.asset(
                                      "images/google-plus.svg",
                                      color: Color.fromARGB(255, 199, 3, 3),
                                      height: 45)),
                            ),
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
