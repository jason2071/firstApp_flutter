// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  Note({
    this.noteID,
    this.noteTitle,
    this.noteContent,
    this.createDateTime,
    this.latestEditDateTime,
  });

  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        noteID: json["noteID"],
        noteTitle: json["noteTitle"],
        noteContent: json["noteContent"],
        createDateTime: DateTime.parse(json["createDateTime"]),
        latestEditDateTime: json['latestEditDateTime'] != null
            ? DateTime.parse(json['latestEditDateTime'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "noteID": noteID,
        "noteTitle": noteTitle,
        "noteContent": noteContent,
        "createDateTime": createDateTime.toIso8601String(),
        "latestEditDateTime": latestEditDateTime.toIso8601String(),
      };
}
