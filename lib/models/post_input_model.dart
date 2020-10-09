import 'package:flutter/material.dart';

class PostInput {
  String title;
  String body;

  PostInput({
    @required this.title,
    @required this.body,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
