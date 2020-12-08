import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spag_notes/model/note.dart';
import 'package:spag_notes/model/user.dart';
import 'package:spag_notes/widget/notes_grid.dart';
import 'package:spag_notes/widget/notes_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _gridView = true;

  @override
  Widget build(BuildContext context) => StreamProvider.value(
        value: _createNoteStream(context),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              _appBar(context),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 24,
                ),
              ),
              _buildNotesView(context),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 80.0,
                ),
              ),
            ],
          ),
          floatingActionButton: _fab(context),
          bottomNavigationBar: _bottomActions(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          extendBody: true,
        ),
      );


  Widget _appBar(BuildContext context) => SliverAppBar(
    floating: true,
    snap: true,
    title: _topActions(context),
    automaticallyImplyLeading: false,
    centerTitle: true,
    titleSpacing: 0,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  Widget _topActions(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 20.0),
                Icon(Icons.menu),
                Expanded(
                  child: Text('Search your notes', softWrap: false),
                ),
                InkWell(
                  child: Icon(_gridView ? Icons.view_list : Icons.view_module),
                  onTap: () => setState(() {
                    _gridView = !_gridView;
                  }),
                ),
                SizedBox(
                  width: 18,
                ),
                _buildAvatar(context),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _bottomActions() => BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: kBottomNavigationBarHeight,
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Row(),
        ),
      );

  Widget _fab(BuildContext context) => FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      );

  Widget _buildAvatar(BuildContext context) {
    final url = Provider.of<CurrentUser>(context)?.data?.photoUrl;
    return CircleAvatar(
      backgroundImage: url != null ? NetworkImage(url) : null,
      child: url == null ? Icon(Icons.face) : null,
      radius: 17,
    );
  }

  Widget _buildNotesView(BuildContext context) => Consumer<List<Note>>(
        builder: (context, notes, _) {
          if (notes?.isNotEmpty != true) {
            return _buildBlankView();
          }

          final widget = _gridView ? NotesGrid.create : NotesList.create;
          return widget(notes: notes, onTap: (_) {});
        },
      );

  Widget _buildBlankView() => SliverFillRemaining(
        hasScrollBody: false,
        child: Text(
          'Notes you add appear here',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      );

  Stream<List<Note>> _createNoteStream(BuildContext context) {
    final uid = Provider.of<CurrentUser>(context)?.data?.uid;
    return Firestore.instance
        .collection('notes-$uid')
        .where('state', isEqualTo: 0)
        .snapshots()
        .handleError((e) => debugPrint('query notes failed: $e'))
        .map((snapshot) => Note.fromQuery(snapshot));
  }
}
