// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math';
import 'package:app_note/component/alert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  CollectionReference noteref = FirebaseFirestore.instance.collection("notes");
  Reference? ref;
  File? file;
  var title, note, imageurl;
  addNotes(context) async {
    var formdata = formState.currentState;
    if (file == null) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'please chose photo',
      )..show();
    }

    if (formdata != null) {
      showloading(context);
      formdata.save();
      await ref?.putFile(file!);
      imageurl = await ref!.getDownloadURL();
      await noteref.add({
        "title": title,
        "note": note,
        "imageurl": imageurl,
        "user": FirebaseAuth.instance.currentUser!.uid
      });
      Navigator.of(context).pushNamed("home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("ADD YOUR MEMORY"),
        actions: [
          IconButton(
              onPressed: () async {
                await addNotes(context);
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(3),
          child: Column(
            children: [
              Form(
                  key: formState,
                  child: Column(
                    children: [
                      TextFormField(
                          onSaved: (val) {
                            title = val;
                          },
                          maxLength: 25,
                          maxLines: 2,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Title",
                            hintStyle: TextStyle(fontSize: 20),
                          )),
                      TextFormField(
                          onSaved: (val) {
                            note = val;
                          },
                          maxLength: null,
                          maxLines: null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Add your MEMORY",
                            hintStyle: TextStyle(fontSize: 20),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            ShowButtonSheet(context);
                          },
                          child: Text("add special photo"))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  ShowButtonSheet(context) {
    return showModalBottomSheet(
        shape: Border.all(color: Theme.of(context).primaryColor, width: 5),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 190,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "Choose special photo",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          PermissionStatus storageStatus =
                              await Permission.camera.request();
                          if (storageStatus == PermissionStatus.granted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("camera granded")));
                          }
                          if (storageStatus == PermissionStatus.denied) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("this permission is recommended")));
                          }
                          if (storageStatus ==
                              PermissionStatus.permanentlyDenied) {
                            openAppSettings();
                          }
                          var picked = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (picked != null) {
                            file = File(picked.path);
                            var rand = Random().nextInt(100000);
                            var imagename = "$rand" + basename(picked.path);
                            ref = FirebaseStorage.instance
                                .ref("images")
                                .child(imagename);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("GALLERY",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13))
                          ],
                        ),
                      ),
                      //this code if u need to add a camera button
                    /*  InkWell(
                        onTap: () async {
                          PermissionStatus cameraStatus =
                              await Permission.camera.request();
                          if (cameraStatus == PermissionStatus.granted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("camera granded")));
                          }
                          if (cameraStatus == PermissionStatus.denied) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("this permission is recommended")));
                          }
                          if (cameraStatus ==
                              PermissionStatus.permanentlyDenied) {
                            openAppSettings();
                          }
                          var picked = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (picked != null) {
                            file = File(picked.path);
                            var rand = Random().nextInt(100000);
                            var imagename = " $rand" + basename(picked.path);
                            var ref = FirebaseStorage.instance
                                .ref("images")
                                .child(imagename);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("CAMERA",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13))
                          ],
                        ),
                      )*/
                    ]),
              )
            ]),
          );
        });
  }
}
