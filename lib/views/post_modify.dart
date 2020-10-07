import 'package:firstApp/models/post_model.dart';
import 'package:firstApp/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PostModify extends StatefulWidget {
  final int id;
  const PostModify({Key key, this.id}) : super(key: key);

  @override
  _PostModifyState createState() => _PostModifyState();
}

class _PostModifyState extends State<PostModify> {
  bool get isEditing => widget.id != null;

  PostService get _postService => GetIt.I<PostService>();
  bool _isLoading = false;

  String errorMessage;
  Post post;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _fetchPost();
    }
  }

  _fetchPost() async {
    setState(() {
      _isLoading = true;
    });

    await _postService.getPost(widget.id).then((response) {
      print(response.data);

      setState(() {
        _isLoading = false;
      });

      if (response.error) {
        errorMessage = response.errorMessage ?? 'An error occurred';
      }

      post = response.data;
      _titleController.text = post.title;
      _contentController.text = post.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Update' : 'Create'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                  Container(
                    height: 8,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Content'),
                  ),
                  Container(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      onPressed: () {
                        if (isEditing) {
                          print('edit');
                        } else {
                          print('create');
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
