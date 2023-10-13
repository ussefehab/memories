
import 'package:flutter/material.dart';
class customButton extends StatefulWidget {
  final String hintText;
  final TextEditingController mycontroller;
  final prefixIcon ;


  const customButton(  
      {super.key, required this.hintText, required this.mycontroller, this.prefixIcon,});

  @override
  State<customButton> createState() => _customButtonState();
}

class _customButtonState extends State<customButton> {
  set mycontroller(String? mycontroller) {}

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.mycontroller,
      decoration: InputDecoration(
        
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.circular(15)),
          prefixIcon:widget.prefixIcon,
          
              
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  width: 2, color: Theme.of(context).primaryColor))),

                  
    );
  }
}
