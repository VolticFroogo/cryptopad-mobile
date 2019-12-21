import "package:flutter/material.dart";

import "pad.dart";
import "snackbar_builder.dart";
import "pages_page.dart";

class PasswordPage extends StatefulWidget {
    final Pad pad;
    final bool exists;

    PasswordPage({ Key key, this.pad, this.exists });

    @override
    PasswordPageState createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final TextEditingController password = TextEditingController();

    @override
    Widget build(BuildContext context) {
        final String operation = widget.exists ? "Unlock" : "Create";
        final String id = widget.pad.id;
        final Widget title = Text("$operation $id");

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: title,
            ),
            body: Center(
                child: Column(
                    children: <Widget>[
                        Container(
                            child: TextField(
                                controller: password,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: "Password",
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
        if (!Pad.PasswordLen.check(password.text.length)) {
            final int min = Pad.PasswordLen.min;
            final int max = Pad.PasswordLen.max;

            scaffoldKey.currentState.showSnackBar(
                SnackBarBuilder.build(context, "Passwords must be between $min and $max in length.")
            );

            return;
        }

        widget.pad.password = password.text;

        if (widget.exists) {
            try {
                widget.pad.decrypt();
            } catch (e) {
                scaffoldKey.currentState.showSnackBar(
                    SnackBarBuilder.build(context, "Error decrypting: invalid password.")
                );

                return;
            }
        }

        Navigator.pop(context);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PagesPage(
                pad: widget.pad,
            ))
        );
    }
}