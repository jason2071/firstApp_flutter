import 'dart:convert';

import 'package:firstApp/models/api_response.dart';
import 'package:firstApp/models/post_input_model.dart';
import 'package:firstApp/models/post_model.dart';
import 'package:firstApp/models/posts_list_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  static const BASE_URL = 'https://jsonplaceholder.typicode.com';
  static const headers = {
    "Content-Type": "application/json",
  };

  Future<APIResponse<List<Posts>>> getPosts() {
    return http.get(BASE_URL + '/posts').then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        final posts = <Posts>[];

        for (var item in jsonData) {
          posts.add(Posts.fromJson(item));
        }

        return APIResponse<List<Posts>>(data: posts);
      } else {
        return APIResponse<List<Posts>>(
            error: true, errorMessage: 'An error occurred');
      }
    }).catchError((_) {
      return APIResponse<List<Posts>>(
          error: true, errorMessage: 'An error occurred');
    });
  }

  Future<APIResponse<Post>> getPost(int id) {
    return http.get(BASE_URL + '/posts/' + id.toString()).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Post>(data: Post.fromJson(jsonData));
      } else {
        return APIResponse<Post>(
            error: true, errorMessage: 'An error occurred');
      }
    }).catchError((_) {
      return APIResponse<Post>(error: true, errorMessage: 'An error occurred');
    });
  }

  Future<APIResponse<bool>> createPost(PostInput item) {
    return http
        .post(BASE_URL + '/posts',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        final jsonData = json.decode(data.body);
        print(jsonData);

        return APIResponse<bool>(data: true);
      } else {
        return APIResponse<bool>(
            error: true, errorMessage: 'An error occurred');
      }
    }).catchError((_) {
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    });
  }
}
