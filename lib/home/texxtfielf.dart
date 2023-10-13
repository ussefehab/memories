import 'package:flutter/material.dart';

class costumEmailButton extends StatefulWidget {
  final TextEditingController mycontroller;

   costumEmailButton({
    super.key,
    required this.mycontroller,
  });

  @override
  State<costumEmailButton> createState() => _costumEmailButtonState();
}

class _costumEmailButtonState extends State<costumEmailButton> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.mycontroller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:  Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.circular(15)),
          hintText: "PASSWORD",
          prefixIcon:
              Icon(Icons.password, color: Theme.of(context).primaryColor),
              suffixIcon: GestureDetector(onTap: (){setState(() {
                _obscureText =! _obscureText;

              });
              },
              
              child: Icon(_obscureText?Icons.visibility:Icons.visibility_off, ),),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  width: 2, color: Theme.of(context).primaryColor))),
      obscureText: _obscureText,
    );
  }
}
