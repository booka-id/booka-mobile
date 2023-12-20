import 'package:booka_mobile/katalog_buku/catalogue.dart';
import 'package:booka_mobile/review/screens/feeds.dart';
import 'package:flutter/material.dart';
// Todo import 'package:booka-mobile/landing_page/book_list.dart';
import 'package:booka_mobile/landing_page/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
//Todo import 'package:booka_mobile/landing_page/shoplist_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              children: [
                Text(
                  'Booka',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Get into your own world with our features!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_rounded),
            title: const Text('Katalog Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              if (request.loggedIn == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const CataloguePage() //Todo ganti review buku,
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Login terlebih dahulu."),
                ));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.rate_review_rounded),
            title: const Text('Review Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              if (request.loggedIn == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ReviewPage() //Todo ganti review buku,
                        ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Login terlebih dahulu."),
                ));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Event'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              if (request.loggedIn == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ReviewPage() //Todo ganti review buku,
                    ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Login terlebih dahulu."),
                ));
              }
            },
          ),
          if (request.loggedIn)
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              // Bagian redirection ke ShopFormPage
              onTap: () async {
                final response = await request.logout(
                    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                    "https://deploytest-production-cf18.up.railway.app/logout_mobile/");
                if (!context.mounted) return;
                String message = response["message"];
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                  ));
                }
              },
            ),
        ],
      ),
    );
  }
}
