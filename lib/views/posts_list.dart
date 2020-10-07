import 'package:firstApp/models/api_response.dart';
import 'package:firstApp/models/posts_list_model.dart';
import 'package:firstApp/services/post_service.dart';
import 'package:firstApp/views/post_delete.dart';
import 'package:firstApp/views/post_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  PostService get _postService => GetIt.I<PostService>();
  APIResponse<List<Posts>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await _postService.getPosts();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/post-modify');
            }),
        body: Builder(builder: (_) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }

          return ListView.separated(
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => PostDelete());
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(right: 16),
                    child: Align(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  child: ListTile(
                    title: Text(_apiResponse.data[index].id.toString() +
                        '. ' +
                        _apiResponse.data[index].title),
                    subtitle: Text(
                      _apiResponse.data[index].body,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              PostModify(id: _apiResponse.data[index].id)));
                    },
                  ),
                );
              },
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.orange),
              itemCount: _apiResponse.data.length);
        }));
  }
}
