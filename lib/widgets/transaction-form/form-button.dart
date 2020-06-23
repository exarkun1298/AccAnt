import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final FocusNode focusNode;

  FormButton({this.label, this.onPressed, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: RaisedButton(
        focusColor: Colors.blueGrey[800],
        focusNode: focusNode,
        onPressed: () => onPressed(),
        splashColor: Colors.grey,
        color: Colors.black,
        child: Text(
          label,
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
