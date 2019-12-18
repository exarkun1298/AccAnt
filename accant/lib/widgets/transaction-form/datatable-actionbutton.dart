import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:vector_math/vector_math_64.dart' as vectors;

import '../../scoped-models/main-model.dart';

enum Actions { remove }

class DataTableActionButton extends StatefulWidget {
  static const Color textcolor = Colors.white70;
  static const double buttonsize = 35;

  final int index;

  DataTableActionButton({@required this.index});

  @override
  _DataTableActionButtonState createState() => _DataTableActionButtonState();
}

class _DataTableActionButtonState extends State<DataTableActionButton> {
  void _handleAction(Actions action, MainModel model) {
    switch (action) {
      case Actions.remove:
        setState(() {
          model.removeTransactionAt(widget.index);
        });

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) =>
          Material(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[900],
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          radius: 50,
          onTap: () async {
            RenderObject thisObject = context.findRenderObject();
            vectors.Vector3 translation =
                thisObject.getTransformTo(null).getTranslation();
            Rect thisRect = thisObject.paintBounds
                .shift(Offset(translation.x, translation.y));
            //print(thisRect);
            Actions action = await showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  thisRect.left + DataTableActionButton.buttonsize,
                  thisRect.top + DataTableActionButton.buttonsize,
                  thisRect.right + DataTableActionButton.buttonsize,
                  thisRect.bottom + DataTableActionButton.buttonsize),
              items: <PopupMenuEntry<Actions>>[
                const PopupMenuItem<Actions>(
                  value: Actions.remove,
                  child: Text("Entfernen"),
                )
              ],
            );

            _handleAction(action, model);
          },
          splashColor: Colors.white,
          highlightColor: Colors.grey,
          child: Container(
            height: DataTableActionButton.buttonsize,
            width: DataTableActionButton.buttonsize,
            child: Icon(
              Icons.more_vert,
              color: DataTableActionButton.textcolor,
            ),
          ),
        ),
      ),
    );
  }
}
