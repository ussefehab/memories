import 'package:app_note/add/editpage.dart';
import 'package:app_note/home/viewnotes.dart';
import 'package:flutter/material.dart';

class ListNotes extends StatelessWidget {
  final docid;
  final notes;
  ListNotes({this.notes, this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ViewNotes(notes: notes);
          },
        ));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${notes['imageurl']}",
                width: 100,
                height: 100,
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['title']}"),
                //subtitle: Text("${notes['note']}"),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return EditNotes(
                          docid: docid,
                          list: notes,
                        );
                      }));
                    },
                    icon: Icon(Icons.edit)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
