import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spag_notes/model/filter.dart';
import 'package:spag_notes/model/note.dart';
import 'package:url_launcher/url_launcher.dart';


import '../styles.dart';
import '../utils.dart';
import 'drawer_filter.dart';

/// Navigation drawer for the app.
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<NoteFilter>(
    builder: (context, filter, _) => Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _drawerHeader(context),
          if (isNotIOS) const SizedBox(height: 25),
          DrawerFilterItem(
            icon: Icons.note_outlined,
            title: 'Notes',
            isChecked: filter.noteState == NoteState.unspecified,
            onTap: () {
              filter.noteState = NoteState.unspecified;
              Navigator.pop(context);
            },
          ),
      //  DrawerFilterItem(
      //    icon: Icons.notifications,
      //    title: 'Reminders',
      //  ),
          const Divider(),
          DrawerFilterItem(
            icon: Icons.architecture_outlined,
            title: 'Archive',
            isChecked: filter.noteState == NoteState.archived,
            onTap: () {
              filter.noteState = NoteState.archived;
              Navigator.pop(context);
            },
          ),
          DrawerFilterItem(
            icon: Icons.delete_outline,
            title: 'Trash',
            isChecked: filter.noteState == NoteState.deleted,
            onTap: () {
              filter.noteState = NoteState.deleted;
              Navigator.pop(context);
            },
          ),
          const Divider(),
          DrawerFilterItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.popAndPushNamed(context, '/settings');
            },
          ),
          DrawerFilterItem(
            icon: Icons.help_outline,
            title: 'About',
            onTap: () => launch('https://github.com/Coney484/Spag_Notes'),
          ),
        ],
      ),
    ),
  );

  Widget _drawerHeader(BuildContext context) => SafeArea(
    child: Container(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            color: kHintTextColorLight,
            fontSize: 26,
            fontWeight: FontWeights.light,
            letterSpacing: -2.5,
          ),
          children: [
            const TextSpan(
              text: 'Spag',
              style: TextStyle(
                color: kAccentColorLight,
                fontWeight: FontWeights.medium,
                fontStyle: FontStyle.italic,
              ),
            ),
            const TextSpan(text: ' Notes'),
          ],
        ),
      ),
    ),
  );
}
