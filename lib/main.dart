import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spag_notes/model/user.dart';
import 'package:spag_notes/screen/home_page.dart';
import 'package:spag_notes/screen/login_screen.dart';
import 'package:spag_notes/screen/notes_editor.dart';
import 'package:spag_notes/screen/settings_screen.dart';
import 'package:spag_notes/screen/splash_screen.dart';
import 'package:spag_notes/styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamProvider.value(
        initialData: CurrentUser.initial,
        value: FirebaseAuth.instance.onAuthStateChanged
            .map((user) => CurrentUser.create(user)),
        child: Consumer<CurrentUser>(
          builder: (context, user, _) => MaterialApp(
            theme: Theme.of(context).copyWith(
              brightness: Brightness.light,
              primaryColor: Colors.white,
              accentColor: kAccentColorLight,
              appBarTheme: AppBarTheme.of(context).copyWith(
                elevation: 0,
                brightness: Brightness.light,
                iconTheme: IconThemeData(
                  color: kIconTintLight,
                ),
              ),
              scaffoldBackgroundColor: Colors.white,
              bottomAppBarColor: kBorderColorLight,
              primaryTextTheme: Theme.of(context).primaryTextTheme.copyWith(
                //title
                headline6: TextStyle(
                  color: kIconTintLight,
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            title: 'Spag Notes',
            home: user.isInitialValue
                ? Scaffold(body: SizedBox())
                : user.data != null
                    ? HomeScreen()
                    : LoginScreen(),
            routes:  {
              '/settings': (_) => SettingsScreen(),
            },
            onGenerateRoute: _generateRoute,
          ),
        ),
      );


      /// Handle named route
  Route _generateRoute(RouteSettings settings) {
    try {
      return _doGenerateRoute(settings);
    } catch (e, s) {
      debugPrint("failed to generate route for $settings: $e $s");
      return null;
    }
  }

   Route _doGenerateRoute(RouteSettings settings) {
    if (settings.name?.isNotEmpty != true) return null;

    final uri = Uri.parse(settings.name);
    final path = uri.path ?? '';
    // final q = uri.queryParameters ?? <String, String>{};
    switch (path) {
      case '/note': {
        final note = (settings.arguments as Map ?? {})['note'];
        return _buildRoute(settings, (_) => NoteEditor(note: note));
      }
      default:
        return null;
    }
  }

  /// Create a [Route].
  Route _buildRoute(RouteSettings settings, WidgetBuilder builder) =>
    MaterialPageRoute<void>(
      settings: settings,
      builder: builder,
    );
}
