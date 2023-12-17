import 'package:flutter/material.dart';
// Todo import 'package:booka-mobile/landing_page/book_list.dart';
import 'package:booka_mobile/landing_page/menu.dart';
import 'package:booka_mobile/event/screens/list_event.dart';
//Todo import 'package:booka_mobile/landing_page/shoplist_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "Daftarkan Buku yang Anda Ingin Baca!",
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
            leading: const Icon(Icons.checklist),
            title: const Text('Katalog Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage() //Todo ganti katalog buku,
                      ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Review Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage() //Todo ganti review buku,
                      ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Event'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EventPage() //Todo ganti event buku,
                      ));
            },
          ),
        ],
      ),
    );
  }
}
