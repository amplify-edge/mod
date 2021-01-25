import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:asuka/asuka.dart' as asuka;

Future<void> showActionDialogBox(
    {@required String title,
    @required String description,
    Function onPressedYes,
    Function onPressedNo,
    String buttonText = "Yes",
    String buttonTextCancel = "No"}) async {
  await asuka.showDialog<void>(
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        actions: <Widget>[
          FlatButton(
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(buttonTextCancel),
            onPressed: () async {
              Navigator.pop(context);
              onPressedNo();
            },
          ),
          RaisedButton(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              child: Text(buttonText),
              onPressed: () async {
                Navigator.pop(context);
                onPressedYes();
              }),
        ],
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Divider(),
                Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Text(description),
                  ],
                ),
              ]),
        ),
      );
    },
  );
}
