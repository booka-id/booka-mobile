import 'package:booka_mobile/katalog_buku/catalogue.dart';
import 'package:booka_mobile/landing_page/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
// Todo import 'package:booka_mobile/screens/shoplist_form.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/review/feeds.dart';
import 'package:booka_mobile/event/screens/list_event.dart';

class ShopItem {
  final String name;
  final IconData icon;
  final Color cardColor;
  ShopItem(this.name, this.icon, this.cardColor) ;
}


class ShopCard extends StatelessWidget {
  final ShopItem item;
  final Color cardColor;

  const ShopCard(this.item, this.cardColor ,{super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.cardColor,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Bakal Dipindahin kebawah nantinya
          // if (item.name == "Katalog Buku") {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               MyHomePage())); //todo Ganti katalog buku
          // } else if (item.name == "Review Buku") {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               ReviewPage())); //todo Ganti review buku
          // } else if (item.name == "Event") {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => MyHomePage())); //todo Ganti event
          // }
          if (item.name == "Login") {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text("Login terlebih dahulu !")));

          }else{
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text("Kamu telah menekan tombol ${item.name}!")));
            // Navigate ke route yang sesuai (tergantung jenis tombol)
              if (item.name == "Review Buku") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ReviewPage())); //todo Ganti review buku
              }
              if (item.name == "Katalog Buku") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CataloguePage())); //todo Ganti katalog buku
              }
             else if (item.name == "Event") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const EventPage())); 
            }

            if (item.name == "Logout") {
              final response = await request.logout(
                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                  "http://127.0.0.1:8000/auth/logout/");
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
            }
            }
          },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}