import "package:flutter/material.dart";
import "dart:convert";

import "pad.dart";
import "page.dart";
import "add_page.dart";
import "page_page.dart";
import "snackbar_builder.dart";
import "error.dart";

class PagesPage extends StatefulWidget {
    Pad pad;

    PagesPage({ Key key, this.pad });

    @override
    PagesPageState createState() => PagesPageState();
}

class PagesPageState extends State<PagesPage> {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) {
        final String id = widget.pad.id;
        final Widget title = Text("$id's Pages");

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: title,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => pressedAdd(context),
                    ),
                    IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () => pressedSave(context),
                    ),
                ],
            ),
            body: Column(
                children: widget.pad.content.map((page) =>
                    ListTile(
                        title: Text(page.title),
                        onTap: () => pressedPage(context, page),
                    ),
                ).toList(),
            ),
        );
    }

    void pressedAdd(BuildContext context) async {
        Page page = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
        );

        if (page == null)
            return;

        widget.pad.content.add(page);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PagePage(page: page)),
        );
    }

    void pressedSave(BuildContext context) async {
        var response = await widget.pad.save();

        switch (response.statusCode) {
            case 200:
            case 201:
                String id = widget.pad.id;

                scaffoldKey.currentState.showSnackBar(
                    SnackBarBuilder.build(context, "Successfully saved $id.")
                );
                break;

            default:
                int status = response.statusCode;
                debugPrint("$status");
                var body = json.decode(response.body);
                String error = Error.fromJson(body).error;

                scaffoldKey.currentState.showSnackBar(
                    SnackBarBuilder.build(context, "Error $status: $error.")
                );
                break;
        }
    }

    void pressedPage(BuildContext context, Page page) async {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PagePage(page: page)),
        );

        if (page.title == Page.Delete) {
            widget.pad.content.remove(page);
        }
    }
}