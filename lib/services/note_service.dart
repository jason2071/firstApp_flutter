import 'dart:convert';

import 'package:firstApp/models/api_response.dart';
import 'package:firstApp/models/note.dart';
import 'package:firstApp/models/note_for_listing.dart';
import 'package:http/http.dart' as http;

class NoteService {
  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {
    "apiKey": "8543c541-6273-4708-8a23-efc1a2087c1f",
  };

  Future<APIResponse<List<NoteForListing>>> getNoteListing() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];

        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }

        return APIResponse<List<NoteForListing>>(data: notes);
      } else {
        print('error: '+ data.body);
        return APIResponse<List<NoteForListing>>(
            error: true, errorMessage: 'An error occurred');
      }
    }).catchError((_) {
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occurred');
    });
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http.get(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Note>(data: Note.fromJson(jsonData));
      } else {
        return APIResponse<Note>(
            error: true, errorMessage: 'An error occurred');
      }
    }).catchError((_) {
      return APIResponse<Note>(error: true, errorMessage: 'An error occurred');
    });
  }
}
