import "package:flutter/material.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "dart:io";

import "model.dart";
import "pad.dart";
import "snackbar_builder.dart";
import "error.dart";
import "password_page.dart";
import "confirmation_alert.dart";

class HomePage extends StatelessWidget {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final TextEditingController id = TextEditingController();

    Pad pad;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: const Text("Cryptopad"),
            ),
            body: Center(
                child: Column(
                    children: <Widget>[
                        Container(
                            child: TextField(
                                controller: id,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: "Name",
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

    static const String url = Model.BaseUrl + "pad/";
    static const Map<String, String> headers = {"Content-type": "application/json"};

    void submit(BuildContext context) async {
        if (!Pad.IDLen.check(id.text.length)) {
            final int min = Pad.IDLen.min;
            final int max = Pad.IDLen.max;

            scaffoldKey.currentState.showSnackBar(
                SnackBarBuilder.build(context, "Names must be between $min and $max in length.")
            );

            return;
        }

        var response = await http.get(
            url + id.text,
            headers: headers,
        );

        bool exists = false;

        switch (response.statusCode) {
            case HttpStatus.ok:
                exists = true;

                var body = json.decode(response.body);
                pad = Pad.fromJson(body);
                break;

            case HttpStatus.notFound:
                pad = Pad(id: id.text);
                pad.randomiseProof();
                break;

            default:
                int status = response.statusCode;

                var body = json.decode(response.body);
                String error = Error.fromJson(body).error;

                scaffoldKey.currentState.showSnackBar(
                    SnackBarBuilder.build(context, "Error $status: $error")
                );

                return;
        }

        Widget title, description;

        if (exists) {
            title = const Text("Unlock Pad");
            description = const Text("A pad already exists with the name you have provided, would you like to read / edit it?");
        } else {
            title = const Text("Create New Pad");
            description = const Text("No pad exists with the name you have provided, would you like to create a new pad?");
        }

        bool confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) => ConfirmationAlert.build(context, title, description),
        );

        if (!confirmed)
            return;

        Navigator.pop(context);

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PasswordPage(
                pad: pad,
                exists: exists,
            ))
        );
    }
}