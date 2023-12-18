import 'package:booka_mobile/landing_page/login.dart';
import 'package:booka_mobile/models/user.dart';
import 'package:booka_mobile/review/top_ranks.dart';
import 'package:flutter/material.dart';
import 'package:booka_mobile/landing_page/left_drawer.dart';
import 'package:booka_mobile/landing_page/shop_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/profile/profile_page.dart';

import '../review/feeds.dart';
import 'bottom_nav_bar.dart';

// Todo ganti import 'package:booka_mobile/landing_page/shoplist_form.dart';
// Todo import 'package:booka-mobile/screens/book_list.dart';



class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final List<ShopItem> items = [
    ShopItem("Katalog Buku", Icons.menu_book_rounded, Colors.indigo),
    ShopItem("Review Buku", Icons.rate_review_rounded, Colors.indigo),
    ShopItem("Event", Icons.calendar_today, Colors.indigo),
    // ShopItem("Logout", Icons.logout, Colors.indigo),
    // ShopItem("Login", Icons.login, Colors.indigo),
  ];
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.watch<UserProvider>();
    int _selectedIndex= 0;


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booka',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: request.loggedIn == true?
            //User Sudah Login
              Consumer<UserProvider>(
                  builder: (context, user,_){
                    return CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.profile_picture),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()));
                        },
                      ),
                    );
                  }
              )
              :
              // User Belum Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // backgroundColor: Color(0xE8FF90C2),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
              )
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: BotNavBar(0),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
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
              const Text(
                'Top Ranked Books', // Text yang menandakan toko
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TopRanksWidget(),
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

