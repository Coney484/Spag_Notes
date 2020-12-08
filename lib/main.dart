import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spag_notes/model/user.dart';
import 'package:spag_notes/screen/home_page.dart';
import 'package:spag_notes/screen/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamProvider.value(
        initialData: CurrentUser.initial,
        value: FirebaseAuth.instance.onAuthStateChanged
            .map((user) => CurrentUser.create(user)),
        child: Consumer<CurrentUser>(
          builder: (context, user, _) => MaterialApp(
            title: 'Spag Notes',
            home: user.isInitialValue
                ? Scaffold(body: const Text('Loading....'))
                : user.data != null
                    ? HomePage()
                    : LoginScreen(),
          ),
        ),
      );
}
