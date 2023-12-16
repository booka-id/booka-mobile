import 'package:booka_mobile/profile/tambah_buku_profil.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/models/user.dart';

import '../landing_page/menu.dart';
import '../review/feeds.dart';
import 'book_list.dart';
import 'edit_profile_picture.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.read<UserProvider>();
    String? userName = user.username;
    String? profilePicture = user.profile_picture;
    String? email = user.email;
    int _selectedIndex = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
          } else if (_selectedIndex == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ReviewPage(),
              ),
            );
          }
          else if (_selectedIndex == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProfilePage()
              ),
            );
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserProvider>(
                builder: (context, user, child) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 4,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(profilePicture!),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const EditProfilePic();
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: const Center(
                child: Column(
                  children: [
                    Text('Buku Favorit',
                      style: TextStyle(
                        fontSize: 20,
                      )
                    ),
                    BookList('favorit'),
                    AddBookButton('favorit')
                  ],
                  )
                ),
              ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: const Center(
                child: Column(
                  children: [
                    Text('Buku Wishlist',
                      style: TextStyle(
                        fontSize: 20,
                      )
                    ),
                    BookList('wishlist'),
                    AddBookButton('wishlist')
                  ],
                )
              ),
            ),

          ],
        ),
      ),
    );
  }
}
