import "package:flutter/material.dart";

import "home_page.dart";

void main() {
    runApp(MaterialApp(
        title: "Cryptopad",
        home: HomePage(),
        theme: ThemeData(
            brightness: Brightness.dark,
        ),
    ));
}