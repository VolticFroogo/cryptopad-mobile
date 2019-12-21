import "package:flutter/material.dart";

import "page.dart";
import "confirmation_alert.dart";

class PagePage extends StatefulWidget {
    Page page;

    PagePage({ Key key, this.page });

    @override
    PagePageState createState() => PagePageState();
}

class PagePageState extends State<PagePage> {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final TextEditingController title = TextEditingController();
    final TextEditingController body = TextEditingController();

    @protected
    @mustCallSuper
    void initState() {
        title.text = widget.page.title;
        body.text = widget.page.content;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text(widget.page.title),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => pressedDelete(context),
                    ),
                    IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () => pressedSave(context),
                    ),
                ],
            ),
            body: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
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
                                child: TextField(
                                    controller: body,
                                    minLines: 5,
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                        labelText: "Body",
                                    ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.80,
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    void pressedSave(BuildContext context) {
        widget.page.title = title.text;
        widget.page.content = body.text;

        Navigator.pop(context);
    }

    void pressedDelete(BuildContext context) async {
        String name = widget.page.title;

        Widget title = Text("Delete $name");
        Widget description = Text("Are you sure you want to delete $name?");

        bool confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) => ConfirmationAlert.build(context, title, description),
        );

        if (!confirmed)
            return;

        widget.page.title = Page.Delete;

        Navigator.pop(
            context,
            widget.page,
        );
    }
}