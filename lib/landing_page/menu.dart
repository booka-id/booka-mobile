import 'package:booka_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:booka_mobile/landing_page/login.dart';
import 'package:booka_mobile/landing_page/shop_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/profile/profile_page.dart';

// Todo ganti import 'package:booka_mobile/landing_page/shoplist_form.dart';
// Todo import 'package:booka-mobile/screens/book_list.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final List<ShopItem> items = [
    ShopItem("Katalog Buku", Icons.checklist, Colors.red),
    ShopItem("Review Buku", Icons.add_shopping_cart, Colors.green),
    ShopItem("Event", Icons.calendar_today, Colors.purple),
    ShopItem("Logout", Icons.logout, Colors.blue),
    ShopItem("Login", Icons.login, Colors.yellow),
  ];
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.read<UserProvider>();
    final userName = user.username;
    List<String> list = <String>['Login', 'Profile', 'Logout'];
    if (request.loggedIn) {
      list = <String>[userName, 'Profile', 'Logout'];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'booka-mobile Book Inventory ',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          //DropdownButton for profile, if user not login display login button, if user login display profile and logout button
          DropdownButton<String>(
            items: list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            //if user not login display login button, if user login display profile and logout button
            onChanged: (String? value) {
              if (value == 'Login') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              } else if (value == 'Profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text("Kamu telah menekan tombol $value!")));
              } else if (value == 'Logout') {



                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text("Kamu telah menekan tombol $value!")));
              }
            },
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'What to do?', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((ShopItem item) {
                  // Iterasi untuk setiap item
                  return ShopCard(item, item.cardColor);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );

    // This widget is the home page of your application. It is stateful, meaning
    // that it has a State object (defined below) that contains fields that affect
    // how it looks.

    // This class is the configuration for the state. It holds the values (in this
    // case the title) provided by the parent (in this case the App widget) and
    // used by the build method of the State. Fields in a Widget subclass are
    // always marked "final".
  }
}
