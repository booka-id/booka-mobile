import 'package:booka_mobile/katalog_buku/catalogue.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../event/screens/list_event.dart';
import '../profile/profile_page.dart';
import '../review/screens/feeds.dart';
import 'login.dart';
import 'menu.dart';

class BotNavBar extends StatefulWidget {
  final int initState;
  const BotNavBar(this.initState, {Key? key}) : super(key: key);

  @override
  _BotNavBarState createState() => _BotNavBarState(initState);
}

class _BotNavBarState extends State<BotNavBar> {
  int _selectedIndex = 0;
  int initPage;
  _BotNavBarState(this.initPage);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return BottomNavigationBar(
      currentIndex: initPage,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.indigo.withOpacity(0.6),
      onTap: (int index) {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          );
        } else if (request.loggedIn == true){
          if (_selectedIndex == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const CataloguePage(), // Todo ganti ke katalog buku
              ),
            );
          } else if (_selectedIndex == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ReviewPage()));

          } else if (_selectedIndex == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const EventPage(),
              ),
            );
          } else if (_selectedIndex == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text("Login terlebih dahulu !")));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }));
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30.0,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu_book_rounded,
            size: 30.0,
          ),
          label: "Catalogue",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.comment,
            size: 30.0,
          ),
          label: "Reviews",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.campaign,
            size: 30.0,
          ),
          label: "Events",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30.0,
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
