// To parse this JSON data, do
//
//     final noteForListing = noteForListingFromJson(jsonString);

import 'dart:convert';

List<NoteForListing> noteForListingFromJson(String str) =>
    List<NoteForListing>.from(
        json.decode(str).map((x) => NoteForListing.fromJson(x)));

String noteForListingToJson(List<NoteForListing> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoteForListing {
  NoteForListing({
    this.noteID,
    this.noteTitle,
    this.createDateTime,
    this.latestEditDateTime,
  });

  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  factory NoteForListing.fromJson(Map<String, dynamic> json) => NoteForListing(
        noteID: json['noteID'],
        noteTitle: json['noteTitle'],
        createDateTime: DateTime.parse(json['createDateTime']),
        latestEditDateTime: json['latestEditDateTime'] != null
            ? DateTime.parse(json['latestEditDateTime'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "noteID": noteID,
        "noteTitle": noteTitle,
        "createDateTime": createDateTime.toIso8601String(),
        "latestEditDateTime": latestEditDateTime.toIso8601String(),
      };
}
