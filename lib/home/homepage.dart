import 'package:app_note/component/listnotes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference noteref = FirebaseFirestore.instance.collection("notes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("MEMORIES")),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Logout',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text('Are you sure'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  GoogleSignIn googleSignIn = GoogleSignIn();
                                  googleSignIn.disconnect();
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "login", (route) => false);
                                },
                                child: Text("yes")),
                            TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text("cancel")),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.exit_to_app)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed("adding");
            }),
        body: Container(
            child: FutureBuilder(
                future: noteref
                    .where("user",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, i) {
                          return Dismissible(
                              onDismissed: (direction) async {
                                await noteref
                                    .doc(snapshot.data.docs[i].id)
                                    .delete();
                                await FirebaseStorage.instance
                                    .refFromURL(
                                        snapshot.data.docs[i]['imageurl'])
                                    .delete();
                              },
                              key: UniqueKey(),
                              child: ListNotes(
                                notes: snapshot.data.docs[i],
                                docid: snapshot.data.docs[i].id,
                              ));
                        });
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }
}
