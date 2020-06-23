import 'package:flutter/material.dart';

class FormReverseEntryCheckbox extends StatefulWidget {
  final Function callback;
  final FocusNode focusNode;

  FormReverseEntryCheckbox({this.callback, this.focusNode});

  @override
  _ReverseEntryCheckboxState createState() => _ReverseEntryCheckboxState();
}

class _ReverseEntryCheckboxState extends State<FormReverseEntryCheckbox> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 45),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white70),
            child: Checkbox(
              focusColor: Colors.blueGrey[800],
              checkColor: Colors.black,
              activeColor: Colors.grey[400],
              value: state,
              onChanged: (e) {
                setState(() {
                  state = !state;
                });
              },
            ),
          ),
          Text('Automatische Gegenbuchung in gleicher Höhe',
              style: TextStyle(color: Colors.white70))
        ],
      ),
    );
  }
}
