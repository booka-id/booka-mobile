import 'package:booka_mobile/landing_page/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider() ,

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
          title: 'Flutter App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          ),
          home: MyHomePage()),
    );
  }
}
