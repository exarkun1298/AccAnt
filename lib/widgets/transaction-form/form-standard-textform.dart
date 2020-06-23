import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main-model.dart';

class FormStandardTextform extends StatefulWidget {
  final bool initialFocus;
  final FocusNode focusNode;
  final MainModel model;
  final IconData icon;
  final String labeltext;
  final GlobalKey<FormState> formKey;
  final Function refresh;
  final Function validator;
  TextEditingController controller;
  final Function transactionSetter;
  DateFormat dateFormat;
  bool isDateForm = false;

  FormStandardTextform({
    @required this.focusNode,
    @required this.initialFocus,
    @required this.model,
    @required this.icon,
    @required this.labeltext,
    @required this.formKey,
    @required this.refresh,
    @required this.validator,
    @required this.transactionSetter,
    this.controller,
  });

  FormStandardTextform.date({
    @required this.focusNode,
    this.initialFocus,
    @required this.model,
    @required this.icon,
    @required this.labeltext,
    @required this.formKey,
    @required this.refresh,
    @required this.validator,
    @required this.dateFormat,
    @required this.transactionSetter,
    this.isDateForm = true,
  }) {
    this.controller = TextEditingController();
  }

  @override
  _StandardTextformState createState() => _StandardTextformState();
}

class _StandardTextformState extends State<FormStandardTextform> {
  Future<String> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.dateFormat.parse(controller.text),
      firstDate: DateTime(1970, 1, 1),
      lastDate: DateTime(2200, 12, 31),
    );
    return pickedDate == null
        ? controller.text
        : widget.dateFormat.format(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    widget.isDateForm
        ? widget.controller.text = widget.model.currentDisplayedDate
        : widget.controller.text = '';
    Color formColor = Colors.white70;
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) =>
          Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TextFormField(
          onSaved: (text) {
            widget.transactionSetter(text);
          },
          onTap: () async {
            if (widget.isDateForm) {
              String picked = await _selectDate(context, widget.controller);
              print(picked);
            }
          },
          autofocus: widget.initialFocus,
          controller: widget.controller,
          validator: (String value) => widget.validator(value),
          style: TextStyle(color: formColor),
          decoration: InputDecoration(
            labelText: widget.labeltext,
            labelStyle: TextStyle(color: formColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: formColor,
                width: 0.0,
              ),
            ),
            icon: Icon(
              widget.icon,
              color: formColor,
            ),
          ),
          cursorColor: formColor,
        ),
      ),
    );
  }
}
