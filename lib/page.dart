import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";

import "minmax.dart";

@JsonSerializable()
class Page {
    static const String Delete = "DELETE";

    static final MinMax TitleLen = MinMax(4, 32);

    String title, content;

    Page({ Key key, this.title, this.content });

    static Page fromJson(Map<String, dynamic> input) =>
        Page(
            title: input["Title"],
            content: input["Content"],
        );

    Map<String, dynamic> toJson() =>
        {
            "Title": this.title,
            "Content": this.content,
        };
}