import 'package:firstApp/models/api_response.dart';
import 'package:firstApp/services/note_service.dart';
import 'package:firstApp/views/note_delete.dart';
import 'package:firstApp/views/note_modify.dart';
import 'package:flutter/material.dart';
import 'package:firstApp/models/note_for_listing.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NoteService get service => GetIt.I<NoteService>();

  APIResponse<List<NoteForListing>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNoteListing();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => NoteModify())),
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }

          return ListView.separated(
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(_apiResponse.data[index].noteTitle,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime)}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NoteModify(
                              noteID: _apiResponse.data[index].noteID)));
                    },
                  ),
                );
              },
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.green),
              itemCount: _apiResponse.data.length);
        },
      ),
    );
  }
}
