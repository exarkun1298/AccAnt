import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  String label;
  Function onPressed;

  FormButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: RaisedButton(
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
