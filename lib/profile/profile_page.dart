import 'package:booka_mobile/profile/tambah_buku_profil.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:booka_mobile/models/user.dart';

import 'book_list.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final user = context.read<UserProvider>();
    String? userName = user.username;
    String? profilePicture = user.profile_picture;
    String? email = user.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(profilePicture),
                ),
              ),
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
            const SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Center(
                child: Column(
                  children: [
                    Text('Buku Favorit'),
                    BookList('favorit'),
                    AddBookButton('favorit')
                  ],
                  )
                ),
              ),
            const SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Center(
                child: Column(
                  children: [
                    Text('Buku Wishlist'),
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
