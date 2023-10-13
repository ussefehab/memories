import 'package:flutter/material.dart';

class ViewNotes extends StatefulWidget {
  final notes;
  const ViewNotes({super.key, this.notes});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("${widget.notes['title']}"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(top: 10),
            child: Text("${widget.notes['note']}", style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w300),),
            
          )
        ],
      )
    );
  }
}