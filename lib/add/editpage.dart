// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math';
import 'package:app_note/component/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  final docid;
  final list;
  const EditNotes({super.key, this.docid, this.list,});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  CollectionReference noteref = FirebaseFirestore.instance.collection("notes");
  Reference? ref;
  File? file;
  var title, note, imageurl;
  addNotes(context) async {
    var formdata = formState.currentState;
    if (file == null) {
      if (formdata != null) {
        showloading(context);
        formdata.save();
        await noteref.doc(widget.docid).update(({
              "title": title,
              "note": note,
              "user": FirebaseAuth.instance.currentUser!.uid
            }));
        Navigator.of(context).pushNamed("home");}
      } else {
        
        if (formdata != null) {
          showloading(context);
          formdata.save();
          await ref?.putFile(file!);
          imageurl = await ref!.getDownloadURL();
          await noteref.doc(widget.docid).update(({
            "title": title,
            "note": note,
            "imageurl": imageurl,
            "user": FirebaseAuth.instance.currentUser!.uid
          }));
          Navigator.of(context).pushNamed("home");
        }
      }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Edit your memory"),
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
                        initialValue: widget.list['title'],
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
                        initialValue: widget.list['note'],
                          onSaved: (val) {
                            note = val;
                          },
                          maxLength: null,
                          maxLines: null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Add your memory",
                            hintStyle: TextStyle(fontSize: 20),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            ShowButtonSheet(context);
                          },
                          child: Text("edit photo"))
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
                "edit photo",
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

                    ]),
              )
            ]),
          );
        });
  }
}