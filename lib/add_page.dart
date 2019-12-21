import "package:flutter/material.dart";

import "pad.dart";
import "page.dart";
import "snackbar_builder.dart";

class AddPage extends StatefulWidget {
    @override
    AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final TextEditingController title = TextEditingController();

    String typeText;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: const Text("New Page"),
            ),
            body: Center(
                child: Column(
                    children: <Widget>[
                        Container(
                            child: TextField(
                                controller: title,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: "Title",
                                    contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                                ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: 70.0,
                        ),
                        Container(
                            child: FlatButton(
                                child: Text("Submit"),
                                onPressed: () => submit(context),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                            ),
                        ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                ),
            ),
        );
    }

    void submit(BuildContext context) {
        if (!Page.TitleLen.check(title.text.length)) {
            final int min = Page.TitleLen.min;
            final int max = Page.TitleLen.max;

            scaffoldKey.currentState.showSnackBar(
                SnackBarBuilder.build(context, "Titles must be between $min and $max in length.")
            );

            return;
        }

        Navigator.pop(
            context,
            Page(
                title: title.text,
            ),
        );
    }
}