   
   import 'package:flutter/material.dart';

showloading(context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(title: Text("please wait",),content: Container(height: 30,child: Center(child: CircularProgressIndicator()),),);
    });
   }