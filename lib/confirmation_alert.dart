import "package:flutter/material.dart";

class ConfirmationAlert {
    static Widget build(BuildContext context, Widget title, Widget description) {
        return AlertDialog(
            title: title,
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    description,
                ],
            ),
            actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    textColor: Colors.white,
                    child: const Text("No"),
                ),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    textColor: Colors.white,
                    child: const Text("Yes"),
                ),
            ],
        );
    }
}