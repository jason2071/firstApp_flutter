import 'dart:convert';

import 'package:firstApp/models/api_response.dart';
import 'package:firstApp/models/post_model.dart';
import 'package:firstApp/models/posts_list_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  static const BASE_URL = 'https://jsonplaceholder.typicode.com';

  Future<APIResponse<List<Posts>>> getPosts() {
    return http.get(BASE_URL + '/posts?_start=0&_limit=20').then((data) {
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
}
