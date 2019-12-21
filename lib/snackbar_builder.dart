import "package:flutter/material.dart";

class SnackBarBuilder {
    static SnackBar build(BuildContext context, String message) {
        return SnackBar(
            content: Text(
                message,
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
        );
    }
}