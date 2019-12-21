import "package:flutter/material.dart";

class Error {
    String error;

    Error({ Key key, this.error });

    static Error fromJson(Map<String, dynamic> json) =>
        Error(
            error: json["Error"],
        );
}