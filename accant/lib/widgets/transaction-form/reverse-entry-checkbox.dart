import 'package:flutter/material.dart';

class ReverseEntryCheckbox extends StatefulWidget {
  Function callback;

  ReverseEntryCheckbox({this.callback});

  @override
  _ReverseEntryCheckboxState createState() => _ReverseEntryCheckboxState();
}

class _ReverseEntryCheckboxState extends State<ReverseEntryCheckbox> {
  bool cb_state = false;

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
              checkColor: Colors.black,
              activeColor: Colors.grey[400],
              value: cb_state,
              onChanged: (e) {
                setState(() {
                  cb_state = !cb_state;
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
